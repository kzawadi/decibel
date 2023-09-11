// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:decibel/application/bloc/episode_state.dart';
import 'package:decibel/application/bloc/persistent_state.dart';
import 'package:decibel/application/bloc/queue_event_state.dart';
import 'package:decibel/domain/podcast/chapter.dart';
import 'package:decibel/domain/podcast/downloadable.dart';
import 'package:decibel/domain/podcast/episode.dart';
import 'package:decibel/domain/podcast/persistable.dart';
import 'package:decibel/domain/podcast/sleep.dart';
import 'package:decibel/infrastructure/core/utils.dart';
import 'package:decibel/infrastructure/podcast/podcast_service.dart';
import 'package:decibel/infrastructure/podcast/repository/repository.dart';
import 'package:decibel/infrastructure/podcast/services/audio/audio_player_service.dart';
import 'package:decibel/infrastructure/settings/settings_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

/// This is the default implementation of [AudioPlayerService]. This implementation uses
/// the [audio_service](https://pub.dev/packages/audio_service) package to run the audio
/// layer as a service to allow background play, and playback is handled by the
/// [just_audio](https://pub.dev/packages/just_audio) package.
class DefaultAudioPlayerService extends AudioPlayerService {
  DefaultAudioPlayerService({
    required this.repository,
    required this.settingsService,
    required this.podcastService,
  }) {
    AudioService.init(
      builder: () => _DefaultAudioPlayerHandler(
        repository: repository,
        settings: settingsService,
      ),
      config: const AudioServiceConfig(
        androidNotificationChannelName: 'Decibal Player',
        fastForwardInterval: Duration(seconds: 30),

        // androidNotificationIcon: 'drawable/ic_stat_name',
      ),
    ).then((value) {
      _audioHandler = value;
      _initialised = true;
      _handleAudioServiceTransitions();
      _loadQueue();
    });
  }
  final log = Logger('DefaultAudioPlayerService');
  final Repository repository;
  final SettingsService settingsService;
  final PodcastService? podcastService;

  late AudioHandler _audioHandler;
  var _initialised = false;
  var _cold = false;
  var _playbackSpeed = 1.0;
  var _trimSilence = false;
  var _volumeBoost = false;
  var _queue = <Episode>[];
  var _sleep = Sleep(type: SleepType.none);

  /// The currently playing episode
  Episode? _currentEpisode;

  /// Subscription to the position ticker.
  StreamSubscription<int>? _positionSubscription;

  /// Subscription to the sleep ticker.
  StreamSubscription<int>? _sleepSubscription;

  /// Stream showing our current playing state.
  final BehaviorSubject<AudioState> _playingState =
      BehaviorSubject<AudioState>.seeded(AudioState.none);

  /// Ticks whilst playing. Updates our current position within an episode.
  final _durationTicker = Stream<int>.periodic(
    const Duration(milliseconds: 500),
    (count) => count,
  ).asBroadcastStream();

  /// Ticks twice every second if a time-based sleep has been started.
  final _sleepTicker = Stream<int>.periodic(
    const Duration(milliseconds: 500),
    (count) => count,
  ).asBroadcastStream();

  /// Stream for the current position of the playing track.
  final _playPosition = BehaviorSubject<PositionState>();

  /// Stream the current playing episode
  final _episodeEvent = BehaviorSubject<Episode?>(sync: true);

  /// Stream for the last audio error as an integer code.
  final _playbackError = PublishSubject<int>();

  final _queueState = BehaviorSubject<QueueListState>();

  final _sleepState = BehaviorSubject<Sleep>();

  @override
  Future<void> pause() async => _audioHandler.pause();

  @override
  Future<void> play() {
    if (_cold) {
      _cold = false;
      return playEpisode(episode: _currentEpisode!, resume: true);
    } else {
      return _audioHandler.play();
    }
  }

  /// Called by the client (UI), or when we move to a different episode within the queue, to play an episode.
  /// If we have a downloaded copy of the requested episode we will use that; otherwise we will stream the
  /// episode directly.
  @override
  Future<void> playEpisode({required Episode episode, bool? resume}) async {
    if (episode.guid != '' && _initialised) {
      final uri = (await _generateEpisodeUri(episode))!;

      log
        ..info(
          'Playing episode ${episode.id} - ${episode.title} from position ${episode.position}',
        )
        ..fine(' - $uri');

      _playingState.add(AudioState.buffering);
      _playbackSpeed = settingsService.playbackSpeed;
      _trimSilence = settingsService.trimSilence;
      _volumeBoost = settingsService.volumeBoost;

      // If we are currently playing a track - save the position of the current
      // track before switching to the next.
      final currentState = _audioHandler.playbackState.value.processingState;

      log.fine(
        'Current playback state is $currentState. Speed = $_playbackSpeed. Trim = $_trimSilence. Volume Boost = $_volumeBoost}',
      );

      if (currentState == AudioProcessingState.ready) {
        await _saveCurrentEpisodePosition();
      } else if (currentState == AudioProcessingState.loading) {
        log.fine('We are loading, so call stop on current playback');
        await _audioHandler.stop();
      }

      // If we have a queue, we are currently playing and the user has elected to play something new,
      // place the current episode at the top of the queue before moving on.
      if (_currentEpisode != null &&
          _currentEpisode!.guid != episode.guid &&
          _queue.isNotEmpty) {
        _queue.insert(0, _currentEpisode!);
      }

      // If we are attempting to play an episode that is also in the queue, remove it from the queue.
      _queue.removeWhere((e) => episode.guid == e.guid);

      // Current episode is saved. Now we re-point the current episode to the new one passed in.
      _currentEpisode = episode;
      _currentEpisode!.played = false;

      await repository.saveEpisode(_currentEpisode!);

      /// Update the state of the queue.
      _updateQueueState();
      _updateEpisodeState();

      /// And the position of our current episode.
      _broadcastEpisodePosition(_currentEpisode!);

      try {
        // Load ancillary items
        await _loadEpisodeAncillaryItems();

        await _audioHandler
            .playMediaItem(_episodeToMediaItem(_currentEpisode!, uri));

        _currentEpisode!.duration =
            _audioHandler.mediaItem.value?.duration?.inSeconds ?? 0;

        await repository.saveEpisode(_currentEpisode!);
      } catch (e) {
        log
          ..fine('Error during playback')
          ..fine(e.toString());

        _playingState
          ..add(AudioState.error)
          ..add(AudioState.stopped);

        await _audioHandler.stop();
      }
    } else {
      log.fine('ERROR: Attempting to play an empty episode');
    }
  }

  @override
  Future<void> rewind() => _audioHandler.rewind();

  @override
  Future<void> fastForward() => _audioHandler.fastForward();

  @override
  Future<void> seek({required int position}) async {
    final currentMediaItem = _audioHandler.mediaItem.value;
    final duration = currentMediaItem?.duration ?? const Duration(seconds: 1);
    final p = Duration(seconds: position);
    final complete =
        p.inSeconds > 0 ? (duration.inSeconds / p.inSeconds) * 100 : 0;

    // Pause the ticker whilst we seek to prevent jumpy UI.
    _positionSubscription?.pause();

    _updateChapter(p.inSeconds, duration.inSeconds);

    _playPosition.add(
      PositionState(
        position: p,
        length: duration,
        percentage: complete.toInt(),
        episode: _currentEpisode,
        buffering: true,
      ),
    );

    await _audioHandler.seek(Duration(seconds: position));

    _positionSubscription?.resume();
  }

  @override
  Future<void> setPlaybackSpeed(double speed) => _audioHandler.setSpeed(speed);

  @override
  Future<void> addUpNextEpisode(Episode episode) async {
    log.fine('addUpNextEpisode Adding ${episode.title} - ${episode.guid}');

    if (episode.guid != _currentEpisode!.guid) {
      _queue.add(episode);
      _updateQueueState();
    }
  }

  @override
  Future<bool> removeUpNextEpisode(Episode episode) async {
    var removed = false;
    log.fine('removeUpNextEpisode Removing ${episode.title} - ${episode.guid}');

    final i = _queue.indexWhere((element) => element.guid == episode.guid);

    if (i >= 0) {
      removed = true;
      _queue.removeAt(i);
      _updateQueueState();
    }

    return removed;
  }

  @override
  Future<bool> moveUpNextEpisode(
    Episode episode,
    int oldIndex,
    int newIndex,
  ) async {
    const moved = false;
    log.fine(
      'moveUpNextEpisode Moving ${episode.title} - ${episode.guid} from $oldIndex to $newIndex',
    );

    final oldEpisode = _queue.removeAt(oldIndex);

    _queue.insert(newIndex, oldEpisode);
    _updateQueueState();

    return moved;
  }

  @override
  Future<void> clearUpNext() async {
    _queue.clear();
    _updateQueueState();
  }

  @override
  Future<void> stop() {
    _currentEpisode = null;
    return _audioHandler.stop();
  }

  @override
  void sleep(Sleep sleep) {
    switch (sleep.type) {
      case SleepType.none:
      case SleepType.episode:
        _stopSleepTicker();
      case SleepType.time:
        _startSleepTicker();
    }

    _sleep = sleep;
    _sleepState.sink.add(_sleep);
  }

  void updateCurrentPosition(Episode? e) {
    if (e != null) {
      final duration = Duration(seconds: e.duration);
      final complete =
          e.position > 0 ? (duration.inSeconds / e.position) * 100 : 0;

      _playPosition.add(
        PositionState(
          position: Duration(milliseconds: e.position),
          length: duration,
          percentage: complete.toInt(),
          episode: e,
        ),
      );
    }
  }

  @override
  Future<void> suspend() async {
    await _stopPositionTicker();

    await _persistState();
  }

  @override
  Future<Episode?> resume() async {
    /// If _episode is null, we must have stopped whilst still active or we were killed.
    if (_currentEpisode == null) {
      if (_initialised && _audioHandler.mediaItem.value != null) {
        final extras = _audioHandler.mediaItem.value?.extras;

        if (extras != null && extras['eid'] != null) {
          _currentEpisode =
              await repository.findEpisodeByGuid(extras['eid'] as String);
        }
      } else {
        // Let's see if we have a persisted state
        final ps = await PersistentState.fetchState();

        if (ps.state == LastState.paused) {
          _currentEpisode = await repository.findEpisodeById(ps.episodeId);
          _currentEpisode!.position = ps.position;
          _playingState.add(AudioState.pausing);

          updateCurrentPosition(_currentEpisode);

          _cold = true;
        }
      }
    } else {
      final playbackState = _audioHandler.playbackState.value;
      final basicState = playbackState.processingState;

      // If we have no state we'll have to assume we stopped whilst suspended.
      if (basicState == AudioProcessingState.idle) {
        /// We will have to assume we have stopped.
        _playingState.add(AudioState.stopped);
      } else if (basicState == AudioProcessingState.ready) {
        await _startPositionTicker();
      }
    }

    await PersistentState.clearState();

    _episodeEvent.sink.add(_currentEpisode);

    return Future.value(_currentEpisode);
  }

  void _updateEpisodeState() {
    _episodeEvent.sink.add(_currentEpisode);
  }

  void _updateQueueState() {
    _queueState.add(QueueListState(playing: _currentEpisode, queue: _queue));
  }

  Future<String?> _generateEpisodeUri(Episode episode) async {
    var uri = episode.contentUrl;

    if (episode.downloadState == DownloadState.downloaded) {
      if (await hasStoragePermission()) {
        uri = await resolvePath(episode);

        episode.streaming = false;
      } else {
        throw Exception('Insufficient storage permissions');
      }
    }

    return uri;
  }

  Future<void> _persistState() async {
    final currentPosition =
        _audioHandler.playbackState.value.position.inMilliseconds;

    /// We only need to persist if we are paused.
    if (_playingState.value == AudioState.pausing) {
      await PersistentState.persistState(
        Persistable(
          pguid: '',
          episodeId: _currentEpisode!.id!,
          position: currentPosition,
          state: LastState.paused,
        ),
      );
    }
  }

  @override
  Future<void> trimSilence(bool trim) {
    return _audioHandler.customAction('trim', <String, dynamic>{
      'value': trim,
    });
  }

  @override
  Future<void> volumeBoost(bool boost) {
    return _audioHandler.customAction('boost', <String, dynamic>{
      'value': boost,
    });
  }

  MediaItem _episodeToMediaItem(Episode episode, String uri) {
    return MediaItem(
      id: uri,
      title: episode.title ?? 'Unknown Title',
      artist: episode.author ?? 'Unknown Title',
      artUri: Uri.parse(
        episode.imageUrl ??
            'https://firebasestorage.googleapis.com/v0/b/decibel-app.appspot.com/o/assets%2Fdecibel_logo.png?alt=media&token=8b7db9df-9aeb-4f30-a399-9eb25f1217fa',
      ), //todo(kzawadi)
      duration: Duration(seconds: episode.duration),
      extras: <String, dynamic>{
        'position': episode.position,
        'downloaded': episode.downloaded,
        'speed': _playbackSpeed,
        'trim': _trimSilence,
        'boost': _volumeBoost,
        'eid': episode.guid,
      },
    );
  }

  void _handleAudioServiceTransitions() {
    _audioHandler.playbackState.distinct((previousState, currentState) {
      return previousState.playing == currentState.playing &&
          previousState.processingState == currentState.processingState;
    }).listen((PlaybackState state) {
      switch (state.processingState) {
        case AudioProcessingState.idle:
          _playingState.add(AudioState.none);
          _stopPositionTicker();
        case AudioProcessingState.loading:
          _playingState.add(AudioState.buffering);
        case AudioProcessingState.buffering:
          _playingState.add(AudioState.buffering);
        case AudioProcessingState.ready:
          if (state.playing) {
            _startPositionTicker();
            _playingState.add(AudioState.playing);
          } else {
            _stopPositionTicker();
            _playingState.add(AudioState.pausing);
          }
        case AudioProcessingState.completed:
          _completed();
        case AudioProcessingState.error:
          _playingState.add(AudioState.error);
      }
    });
  }

  Future<void> _loadQueue() async {
    _queue = await podcastService!.loadQueue();
  }

  Future<void> _completed() async {
    await _saveCurrentEpisodePosition(complete: true);

    log.fine('We have completed episode ${_currentEpisode?.title}');

    await _stopPositionTicker();

    if (_queue.isEmpty) {
      log.fine('Queue is empty so we will stop');
      _queue = <Episode>[];
      _currentEpisode = null;
      _playingState.add(AudioState.stopped);

      await _audioHandler.customAction('queueend');
    } else if (_sleep.type == SleepType.episode) {
      log.fine('Sleeping at end of episode');

      await _audioHandler.customAction('sleep');
      _playingState.add(AudioState.pausing);
      await _stopSleepTicker();
    } else {
      log.fine('Queue has ${_queue.length} episodes left');
      _currentEpisode = null;
      final ep = _queue.removeAt(0);

      await playEpisode(episode: ep);

      _updateQueueState();
    }
  }

  /// This method is called when audio_service sends a [AudioProcessingState.loading] event.
  Future<void> _loadEpisodeAncillaryItems() async {
    if (_currentEpisode == null) {
      log.fine('_onLoadEpisode: _episode is null - cannot load!');
      return;
    }

    _updateEpisodeState();

    // Chapters
    if (_currentEpisode!.hasChapters && _currentEpisode!.streaming) {
      _currentEpisode!.chaptersLoading = true;
      _currentEpisode!.chapters = <Chapter>[];

      _updateEpisodeState();

      await _onUpdatePosition();

      log.fine('Loading chapters from ${_currentEpisode!.chaptersUrl}');

      _currentEpisode!.chapters = await podcastService!.loadChaptersByUrl(
        url: _currentEpisode!.chaptersUrl!,
      );
      _currentEpisode!.chaptersLoading = false;

      _updateEpisodeState();

      log.fine('We have ${_currentEpisode!.chapters.length} chapters');
      _currentEpisode = await repository.saveEpisode(_currentEpisode!);
    }

    /// Update the state of the current episode & transcript.
    _updateEpisodeState();

    await _onUpdatePosition();
  }

  void _broadcastEpisodePosition(Episode? e) {
    if (e != null) {
      final duration = Duration(seconds: e.duration);
      final complete =
          e.position > 0 ? (duration.inSeconds / e.position) * 100 : 0;

      _playPosition.add(
        PositionState(
          position: Duration(milliseconds: e.position),
          length: duration,
          percentage: complete.toInt(),
          episode: e,
        ),
      );
    }
  }

  /// Saves the current play position to persistent storage. This enables a
  /// podcast to continue playing where it left off if played at a later
  /// time.
  Future<void> _saveCurrentEpisodePosition({bool complete = false}) async {
    if (_currentEpisode != null) {
      // The episode may have been updated elsewhere - re-fetch it.
      final currentPosition =
          _audioHandler.playbackState.value.position.inMilliseconds;

      _currentEpisode =
          await repository.findEpisodeByGuid(_currentEpisode!.guid);

      log.fine(
        '_saveCurrentEpisodePosition(): Current position is $currentPosition - stored position is ${_currentEpisode!.position} complete is $complete',
      );

      if (currentPosition != _currentEpisode!.position) {
        _currentEpisode!.position = complete ? 0 : currentPosition;
        _currentEpisode!.played = complete;

        _currentEpisode = await repository.saveEpisode(_currentEpisode!);
      }
    } else {
      log.fine(' - Cannot save position as episode is null');
    }
  }

  /// Called when play starts. Each time we receive an event in the stream
  /// we check the current position of the episode from the audio service
  /// and then push that information out via the [_playPosition] stream
  /// to inform our listeners.
  Future<void> _startPositionTicker() async {
    if (_positionSubscription == null) {
      _positionSubscription = _durationTicker.listen((int period) async {
        await _onUpdatePosition();
      });
    } else if (_positionSubscription!.isPaused) {
      _positionSubscription!.resume();
    }
  }

  Future<void> _stopPositionTicker() async {
    if (_positionSubscription != null) {
      await _positionSubscription!.cancel();
      _positionSubscription = null;
    }
  }

  /// We only want to start the sleep timer ticker when the user has requested a sleep.
  Future<void> _startSleepTicker() async {
    _sleepSubscription ??= _sleepTicker.listen((int period) async {
      if (_sleep.type == SleepType.time &&
          DateTime.now().isAfter(_sleep.endTime)) {
        await pause();
        _sleep = Sleep(type: SleepType.none);
        _sleepState.sink.add(_sleep);
        await _sleepSubscription?.cancel();
        _sleepSubscription = null;
      } else {
        _sleepState.sink.add(_sleep);
      }
    });
  }

  /// Once we have stopped sleeping we call this method to tidy up the ticker subscription.
  Future<void> _stopSleepTicker() async {
    _sleep = Sleep(type: SleepType.none);
    _sleepState.sink.add(_sleep);

    if (_sleepSubscription != null) {
      await _sleepSubscription!.cancel();
      _sleepSubscription = null;
    }
  }

  Future<void> _onUpdatePosition() async {
    final playbackState = _audioHandler.playbackState.value;

    final currentMediaItem = _audioHandler.mediaItem.value;
    final duration = currentMediaItem?.duration ?? const Duration(seconds: 1);
    final position = playbackState.position;
    final complete = position.inSeconds > 0
        ? (duration.inSeconds / position.inSeconds) * 100
        : 0;
    final buffering =
        playbackState.processingState == AudioProcessingState.buffering;

    _updateChapter(position.inSeconds, duration.inSeconds);

    _playPosition.add(
      PositionState(
        position: position,
        length: duration,
        percentage: complete.toInt(),
        episode: _currentEpisode,
        buffering: buffering,
      ),
    );
  }

  /// Calculate our current chapter based on playback position, and if it's different to
  /// the currently stored chapter - update.
  void _updateChapter(int seconds, int duration) {
    if (_currentEpisode == null) {
      log.fine(
        'Warning. Attempting to update chapter information on a null _episode',
      );
    } else if (_currentEpisode!.hasChapters &&
        _currentEpisode!.chaptersAreLoaded) {
      final chapters = _currentEpisode!.chapters;

      for (var chapterPtr = 0;
          chapterPtr < _currentEpisode!.chapters.length;
          chapterPtr++) {
        final startTime = chapters[chapterPtr].startTime;
        final endTime = chapterPtr == (_currentEpisode!.chapters.length - 1)
            ? duration
            : chapters[chapterPtr + 1].startTime;

        if (seconds >= startTime && seconds < endTime) {
          if (chapters[chapterPtr] != _currentEpisode!.currentChapter) {
            _currentEpisode!.currentChapter = chapters[chapterPtr];
            _episodeEvent.sink.add(_currentEpisode);
            break;
          }
        }
      }
    }
  }

  @override
  Episode get nowPlaying => _currentEpisode!;

  /// Get the current playing state
  @override
  Stream<AudioState> get playingState => _playingState.stream;

  Stream<EpisodeState> get episodeListener => repository.episodeListener;

  @override
  Stream<PositionState> get playPosition => _playPosition.stream;

  @override
  Stream<Episode?> get episodeEvent => _episodeEvent.stream;

  @override
  // Stream<TranscriptState> get transcriptEvent => _transcriptEvent.stream;

  @override
  Stream<int> get playbackError => _playbackError.stream;

  @override
  Stream<QueueListState> get queueState => _queueState.stream;
}

/// This is the default audio handler used by the [DefaultAudioPlayerService] service.
/// This handles the interaction between the service (via the audio service package) and
/// the underlying player.
class _DefaultAudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  _DefaultAudioPlayerHandler({
    required this.repository,
    required this.settings,
  }) {
    _initPlayer();
  }
  final log = Logger('DefaultAudioPlayerHandler');
  final Repository repository;
  final SettingsService settings;

  static const rewindMillis = 10001;
  static const fastForwardMillis = 30000;
  static const audioGain = 0.8;
  bool _trimSilence = false;

  late AndroidLoudnessEnhancer _androidLoudnessEnhancer;
  AudioPipeline? _audioPipeline;
  late AudioPlayer _player;
  MediaItem? _currentItem;

  static const MediaControl rewindControl = MediaControl(
    androidIcon: 'drawable/ic_action_rewind_10',
    label: 'Rewind',
    action: MediaAction.rewind,
  );

  static const MediaControl fastforwardControl = MediaControl(
    androidIcon: 'drawable/ic_action_fastforward_30',
    label: 'Fastforward',
    action: MediaAction.fastForward,
  );

  void _initPlayer() {
    if (Platform.isAndroid) {
      _androidLoudnessEnhancer = AndroidLoudnessEnhancer();
      _androidLoudnessEnhancer.setEnabled(true);
      _audioPipeline =
          AudioPipeline(androidAudioEffects: [_androidLoudnessEnhancer]);
      _player = AudioPlayer(
        audioPipeline: _audioPipeline,
      );
    } else {
      _player = AudioPlayer(
        /// Temporarily disable custom user agent to get over proxy issue in just_audio on iOS.
        /// https://github.com/ryanheise/audio_service/issues/915
        //   userAgent: Environment.userAgent(),
        audioLoadConfiguration: AudioLoadConfiguration(
          androidLoadControl: AndroidLoadControl(
            backBufferDuration: const Duration(seconds: 45),
          ),
          darwinLoadControl: DarwinLoadControl(),
        ),
      );
    }

    /// List to events from the player itself, transform the player event to an audio service one
    /// and hand it off to the playback state stream to inform our client(s).
    _player.playbackEventStream
        .map(_transformEvent)
        .pipe(playbackState)
        .catchError((Object o, StackTrace s) async {
      log
        ..fine('Playback error received')
        ..fine(o.toString());

      await _player.stop();
    });
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    _currentItem = mediaItem;

    final downloaded = mediaItem.extras!['downloaded'] as bool? ?? true;
    final startPosition = mediaItem.extras!['position'] as int? ?? 0;
    final playbackSpeed = mediaItem.extras!['speed'] as double? ?? 0.0;
    final start = startPosition > 0
        ? Duration(milliseconds: startPosition)
        : Duration.zero;
    final boost = mediaItem.extras!['boost'] as bool? ?? true;
    // Commented out until just audio position bug is fixed
    // var trim = mediaItem.extras['trim'] as bool ?? true;

    log.fine(
        'loading new track ${mediaItem.id} - from position ${start.inSeconds} (${start.inMilliseconds})');

    final source = downloaded
        ? AudioSource.uri(
            Uri.parse('file://${mediaItem.id}'),
            tag: mediaItem.id,
          )
        : AudioSource.uri(Uri.parse(mediaItem.id), tag: mediaItem.id);

    try {
      final duration =
          await _player.setAudioSource(source, initialPosition: start);

      /// If we don't already have a duration and we have been able to calculate it from
      /// beginning to fetch the media, update the current media item with the duration.
      if (duration != null &&
          (_currentItem!.duration == null ||
              _currentItem!.duration!.inSeconds == 0)) {
        _currentItem = _currentItem!.copyWith(duration: duration);
      }

      if (_player.processingState != ProcessingState.idle) {
        try {
          if (_player.speed != playbackSpeed) {
            await _player.setSpeed(playbackSpeed);
          }

          if (Platform.isAndroid) {
            if (_player.skipSilenceEnabled != _trimSilence) {
              await _player.setSkipSilenceEnabled(_trimSilence);
            }

            await volumeBoost(boost);
          }

          await _player.play();
        } catch (e) {
          log.fine('State error ${e}');
        }
      }
    } on PlayerException catch (e) {
      log.fine('PlayerException');
      log.fine(' - Error code ${e.code}');
      log.fine('  - ${e.message}');
      await stop();
      log.fine(e);
    } on PlayerInterruptedException catch (e) {
      log.fine('PlayerInterruptedException');
      await stop();
      log.fine(e);
    } catch (e) {
      log.fine('General playback exception');
      await stop();
      log.fine(e);
    }

    super.mediaItem.add(_currentItem);
  }

  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> pause() async {
    log.fine('pause() triggered - saving position');
    await _savePosition();
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    log.fine('stop() triggered - saving position');

    await _player.stop();
    await _savePosition();
  }

  Future<void> complete() async {
    log.fine('complete() triggered - saving position');
    await _savePosition(complete: true);
  }

  @override
  Future<void> fastForward() async {
    final forwardPosition = _player.position.inMilliseconds;

    await _player
        .seek(Duration(milliseconds: forwardPosition + fastForwardMillis));
  }

  @override
  Future<void> seek(Duration position) async {
    return _player.seek(position);
  }

  @override
  Future<void> rewind() async {
    var rewindPosition = _player.position.inMilliseconds;

    if (rewindPosition > 0) {
      rewindPosition -= rewindMillis;

      if (rewindPosition < 0) {
        rewindPosition = 0;
      }

      await _player.seek(Duration(milliseconds: rewindPosition));
    }
  }

  @override
  Future<dynamic> customAction(String name,
      [Map<String, dynamic>? extras]) async {
    switch (name) {
      case 'trim':
        final t = extras!['value'] as bool;
        return trimSilence(t);
      case 'boost':
        final t = extras!['value'] as bool?;
        return volumeBoost(t);
      case 'queueend':
        log.fine('Received custom action: queue end');
        await _player.stop();
      case 'sleep':
        log.fine('Received custom action: sleep end of episode');
        // We need to wind back a several milliseconds to stop just_audio
        // from sending more complete events on iOS when we pause.
        var position = _player.position.inMilliseconds - 200;

        if (position < 0) {
          position = 0;
        }

        await _player.seek(Duration(milliseconds: position));
        await _player.pause();
    }
  }

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  Future<void> trimSilence(bool trim) async {
    _trimSilence = trim;
    await _player.setSkipSilenceEnabled(trim);
  }

  Future<void> volumeBoost(bool? boost) async {
    /// For now, we know we only have one effect so we can cheat
    final e = _audioPipeline!.androidAudioEffects[0];

    if (e is AndroidLoudnessEnhancer) {
      await e.setTargetGain(boost! ? audioGain : 0.0);
    }
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    log.fine(
      '_transformEvent Sending state ${_player.processingState}. Playing: ${_player.playing}',
    );

    if (_player.processingState == ProcessingState.completed) {
      log.fine('Transform event has received a complete - calling complete();');
      complete();
    }

    return PlaybackState(
      controls: [
        rewindControl,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        fastforwardControl,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: {
        ProcessingState.idle: _player.playing
            ? AudioProcessingState.ready
            : AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }

  Future<void> _savePosition({bool complete = false}) async {
    if (_currentItem != null) {
      // The episode may have been updated elsewhere - re-fetch it.
      final currentPosition = playbackState.value.position.inMilliseconds;
      final storedEpisode = await repository
          .findEpisodeByGuid(_currentItem!.extras!['eid'] as String);

      log.fine(
        '_savePosition(): Current position is $currentPosition - stored position is ${storedEpisode!.position} complete is $complete on episode ${storedEpisode.title}',
      );

      if (complete) {
        storedEpisode
          ..position = 0
          ..played = true;

        await repository.saveEpisode(storedEpisode);
      } else if (currentPosition != storedEpisode.position) {
        storedEpisode.position = currentPosition;

        await repository.saveEpisode(storedEpisode);
      }
    } else {
      log.fine(' - Cannot save position as episode is null');
    }
  }
}

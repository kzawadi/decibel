// Copyright 2023 Kelvin Zawadi. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:decibel/application/bloc/audio_bloc.dart';
import 'package:decibel/application/bloc/now_playing.dart';
import 'package:decibel/domain/podcast/episode.dart';
import 'package:decibel/infrastructure/podcast/services/audio/audio_player_service.dart';
import 'package:decibel/presentation/core/assets_constants.dart';
import 'package:decibel/presentation/core/placeholder_builder.dart';
import 'package:decibel/presentation/core/podcast_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// Displays a mini podcast player widget if a podcast is playing or paused.
/// If stopped a zero height box is built instead.
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);

    return StreamBuilder<AudioState>(
      stream: audioBloc.playingState,
      initialData: AudioState.stopped,
      builder: (context, snapshot) {
        return snapshot.data != AudioState.stopped &&
                snapshot.data != AudioState.none &&
                snapshot.data != AudioState.error
            ? _MiniPlayerBuilder()
            : const SizedBox(
                height: 0,
              );
      },
    );
  }
}

class _MiniPlayerBuilder extends StatefulWidget {
  @override
  _MiniPlayerBuilderState createState() => _MiniPlayerBuilderState();
}

class _MiniPlayerBuilderState extends State<_MiniPlayerBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _playPauseController;
  late StreamSubscription<AudioState> _audioStateSubscription;

  @override
  void initState() {
    super.initState();

    _playPauseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _playPauseController.value = 1;

    _audioStateListener();
  }

  @override
  void dispose() {
    _audioStateSubscription.cancel();
    _playPauseController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final placeholderBuilder = PlaceholderBuilder.of(context);

    return Dismissible(
      // key: Key('miniplayerdismissable'),
      key: UniqueKey(),
      confirmDismiss: (direction) async {
        await _audioStateSubscription.cancel();
        audioBloc.transitionState(TransitionState.stop);
        return true;
      },
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Theme.of(context).colorScheme.background,
        height: 64,
      ),
      child: GestureDetector(
        key: const Key('miniplayergesture'),
        onTap: () async {
          await _audioStateSubscription.cancel();

          await showModalBottomSheet<void>(
            context: context,
            routeSettings: const RouteSettings(name: 'nowplaying'),
            isScrollControlled: true,
            builder: (BuildContext modalContext) {
              return Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: const NowPlaying(),
              );
            },
          ).then((_) {
            _audioStateListener();
          });
        },
        child: Container(
          height: 66,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            border: Border(
              top: Divider.createBorderSide(context,
                  width: 1, color: Theme.of(context).dividerColor),
              bottom: Divider.createBorderSide(context,
                  width: 0, color: Theme.of(context).dividerColor),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<Episode?>(
                stream: audioBloc.nowPlaying,
                builder: (context, snapshot) {
                  return Row(
                    children: <Widget>[
                      SizedBox(
                        height: 58,
                        width: 58,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: snapshot.hasData
                              ? PodcastImage(
                                  key: Key('mini${snapshot.data!.imageUrl}'),
                                  url: snapshot.data!.imageUrl!,
                                  width: 58,
                                  height: 58,
                                  borderRadius: 4,
                                  placeholder: placeholderBuilder != null
                                      ? placeholderBuilder.builder()(context)
                                      : SvgPicture.asset(
                                          AssetsConstants.logo,
                                        ),
                                  errorPlaceholder: placeholderBuilder != null
                                      ? placeholderBuilder
                                          .errorBuilder()(context)
                                      : SvgPicture.asset(
                                          AssetsConstants.logo,
                                        ),
                                )
                              : Container(),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              snapshot.data?.title ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                snapshot.data?.author ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 64,
                        width: 64,
                        child: StreamBuilder<AudioState>(
                          stream: audioBloc.playingState,
                          builder: (context, snapshot) {
                            final playing = snapshot.data == AudioState.playing;

                            return TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(),
                                shape: CircleBorder(
                                  side: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      width: 0),
                                ),
                              ),
                              onPressed: () {
                                if (playing) {
                                  _pause(audioBloc);
                                } else {
                                  _play(audioBloc);
                                }
                              },
                              child: AnimatedIcon(
                                size: 48,
                                icon: AnimatedIcons.play_pause,
                                color: Theme.of(context).iconTheme.color,
                                progress: _playPauseController,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              StreamBuilder<PositionState>(
                stream: audioBloc.playPosition,
                builder: (context, snapshot) {
                  var cw = 0.0;
                  final position = snapshot.hasData
                      ? snapshot.data!.position
                      : const Duration();
                  final length = snapshot.hasData
                      ? snapshot.data!.length
                      : const Duration();

                  if (length.inSeconds > 0) {
                    final pc = length.inSeconds / position.inSeconds;
                    cw = width / pc;
                  }

                  return Container(
                    width: cw,
                    height: 1,
                    color: Theme.of(context).primaryColor,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// We call this method to setup a listener for changing [AudioState]. This in turns calls upon the [_pauseController]
  /// to animate the play/pause icon. The [AudioBloc] playingState method is backed by a [BehaviorSubject] so we'll
  /// always get the current state when we subscribe. This, however, has a side effect causing the play/pause icon to
  /// animate when returning from the full-size player, which looks a little odd. Therefore, on the first event we move
  /// the controller to the correct state without animating. This feels a little hacky, but stops the UI from looking a
  /// little odd.
  void _audioStateListener() {
    if (mounted) {
      final audioBloc = Provider.of<AudioBloc>(context, listen: false);
      var firstEvent = true;

      _audioStateSubscription = audioBloc.playingState!.listen((event) {
        if (event == AudioState.playing || event == AudioState.buffering) {
          if (firstEvent) {
            _playPauseController.value = 1;
            firstEvent = false;
          } else {
            _playPauseController.forward();
          }
        } else {
          if (firstEvent) {
            _playPauseController.value = 0;
            firstEvent = false;
          } else {
            _playPauseController.reverse();
          }
        }
      });
    }
  }

  void _play(AudioBloc audioBloc) {
    audioBloc.transitionState(TransitionState.play);
  }

  void _pause(AudioBloc audioBloc) {
    audioBloc.transitionState(TransitionState.pause);
  }
}

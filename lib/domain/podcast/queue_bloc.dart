// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/bloc/bloc.dart';
import 'package:decibel/application/bloc/queue_event_state.dart';
import 'package:decibel/infrastructure/podcast/podcast_service.dart';
import 'package:decibel/infrastructure/podcast/services/audio/audio_player_service.dart';
import 'package:rxdart/rxdart.dart';

class QueueBloc extends Bloc {
  QueueBloc({
    required this.audioPlayerService,
    required this.podcastService,
  }) {
    _handleQueueEvents();
  }
  final AudioPlayerService audioPlayerService;
  final PodcastService podcastService;
  final PublishSubject<QueueEvent> _queueEvent = PublishSubject<QueueEvent>();

  void _handleQueueEvents() {
    _queueEvent.listen((QueueEvent event) async {
      if (event is QueueAddEvent) {
        final e = event.episode!;
        await audioPlayerService.addUpNextEpisode(e);
      } else if (event is QueueRemoveEvent) {
        final e = event.episode!;
        await audioPlayerService.removeUpNextEpisode(e);
      } else if (event is QueueMoveEvent) {
        final e = event.episode!;
        await audioPlayerService.moveUpNextEpisode(
          e,
          event.oldIndex,
          event.newIndex,
        );
      } else if (event is QueueClearEvent) {
        await audioPlayerService.clearUpNext();
      }
    });

    audioPlayerService.queueState!
        .debounceTime(const Duration(seconds: 2))
        .listen((event) {
      podcastService.saveQueue(event.queue).then((value) {
        /// Queue saved.
      });
    });
  }

  Function(QueueEvent) get queueEvent => _queueEvent.sink.add;

  Stream<QueueListState> get queue => audioPlayerService.queueState!;

  @override
  void dispose() {
    _queueEvent.close();

    super.dispose();
  }
}

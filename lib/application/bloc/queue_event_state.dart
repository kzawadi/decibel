// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/domain/podcast/episode.dart';

abstract class QueueEvent {
  QueueEvent({
    this.episode,
    this.position,
  });
  final Episode? episode;
  int? position;
}

class QueueAddEvent extends QueueEvent {
  QueueAddEvent({required super.episode, super.position});
}

class QueueRemoveEvent extends QueueEvent {
  QueueRemoveEvent({required super.episode});
}

class QueueMoveEvent extends QueueEvent {
  QueueMoveEvent({
    required super.episode,
    required this.oldIndex,
    required this.newIndex,
  });
  final int oldIndex;
  final int newIndex;
}

class QueueClearEvent extends QueueEvent {}

abstract class QueueState {
  QueueState({
    required this.playing,
    required this.queue,
  });
  final Episode playing;
  final List<Episode> queue;
}

class QueueListState extends QueueState {
  QueueListState({
    required super.playing,
    required super.queue,
  });
}

class QueueEmptyState extends QueueState {
  QueueEmptyState()
      : super(
          playing: Episode(
            guid: '',
            pguid: '',
            podcast: '',
            id: 0,
            downloadTaskId: '',
            filepath: '',
            filename: '',
            title: '',
            description: '',
            content: '',
            link: '',
            publicationDate: DateTime.now(),
            contentUrl: '',
            author: '',
            chaptersUrl: '',
            chapters: [],
            lastUpdated: DateTime.now(),
          ),
          queue: <Episode>[],
        );
}

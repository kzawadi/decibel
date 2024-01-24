// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/domain/podcast/episode.dart';

abstract class EpisodeState {
  EpisodeState(this.episode);
  final Episode episode;
}

class EpisodeUpdateState extends EpisodeState {
  EpisodeUpdateState(super.episode);
}

class EpisodeDeleteState extends EpisodeState {
  EpisodeDeleteState(super.episode);
}

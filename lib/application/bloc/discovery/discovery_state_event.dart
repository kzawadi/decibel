// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Events
class DiscoveryEvent {}

class DiscoveryChartEvent extends DiscoveryEvent {
  DiscoveryChartEvent({
    this.genre = '',
  });
  String genre;
}

/// States
class DiscoveryState {}

class DiscoveryLoadingState extends DiscoveryState {}

class DiscoveryPopulatedState<T> extends DiscoveryState {
  DiscoveryPopulatedState({
    required this.results,
    this.genre,
    this.index = 0,
  });
  final String? genre;
  final int index;
  final T results;
}

// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/bloc/bloc.dart';
import 'package:decibel/application/bloc/discovery/discovery_state_event.dart';
import 'package:decibel/domain/podcast/search_result.dart';
import 'package:decibel/infrastructure/podcast/podcast_service.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

/// A BLoC to interact with the Discovery UI page and the [PodcastService] to
/// fetch charts. As charts will not change very frequently
/// the results are cached for [cacheMinutes].
class DiscoveryBloc extends Bloc {
  DiscoveryBloc({required this.podcastService}) {
    _init();
  }
  static const cacheMinutes = 30;

  final log = Logger('DiscoveryBloc');
  final PodcastService podcastService;

  /// Takes an event which triggers a loading of chart data from the selected provider.
  final _discoveryInput = BehaviorSubject<DiscoveryEvent>();

  /// A stream of genres from the selected provider.
  final _genres = PublishSubject<List<String>>();

  /// The last genre to be passed in a [DiscoveryEvent].
  final _selectedGenre = BehaviorSubject<SelectedGenre>(sync: true);

  /// The last fetched results.
  Stream<DiscoveryState>? _discoveryResults;

  /// To save bandwidth we cache the results.
  late SearchResult? _resultsCache;

  void _init() {
    _discoveryResults = _discoveryInput.switchMap<DiscoveryState>(_charts);
    _selectedGenre.value = SelectedGenre(index: 0, genre: '');
    _genres.onListen = _loadGenres;
  }

  void _loadGenres() {
    _genres.sink.add(podcastService.genres());
  }

  Stream<DiscoveryState> _charts(DiscoveryEvent event) async* {
    yield DiscoveryLoadingState();

    if (event is DiscoveryChartEvent) {
      _resultsCache = await podcastService.charts();

      yield DiscoveryPopulatedState<SearchResult>(
        genre: event.genre,
        index: podcastService.genres().indexOf(event.genre),
        results: _resultsCache!,
      );
    }
  }

  @override
  void dispose() {
    _discoveryInput.close();
  }

  void Function(DiscoveryEvent) get discover => _discoveryInput.add;

  Stream<DiscoveryState>? get results => _discoveryResults;

  Stream<List<String>> get genres => _genres.stream;

  SelectedGenre get selectedGenre => _selectedGenre.value;
}

class SelectedGenre {
  SelectedGenre({
    required this.index,
    required this.genre,
  });
  final int index;
  final String genre;
}

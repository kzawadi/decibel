// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/bloc/episode_state.dart';
import 'package:decibel/domain/podcast/episode.dart';
import 'package:decibel/domain/podcast/podcast.dart';

/// An abstract class that represent the actions supported by the chosen
/// database or storage implementation.
abstract class Repository {
  /// General
  Future<void> close();

  /// Podcasts
  Future<Podcast?> findPodcastById(num id);

  Future<Podcast?> findPodcastByGuid(String guid);

  Future<Podcast> savePodcast(Podcast podcast);

  Future<void> deletePodcast(Podcast podcast);

  Future<List<Podcast>> subscriptions();

  /// Episodes
  Future<List<Episode>> findAllEpisodes();

  Future<Episode> findEpisodeById(int id);

  Future<Episode?> findEpisodeByGuid(String guid);

  Future<List<Episode?>> findEpisodesByPodcastGuid(String pguid);

  Future<Episode?> findEpisodeByTaskId(String taskId);

  Future<Episode> saveEpisode(Episode episode, [bool updateIfSame]);

  Future<void> deleteEpisode(Episode episode);

  Future<void> deleteEpisodes(List<Episode> episodes);

  Future<List<Episode>> findDownloadsByPodcastGuid(String pguid);

  Future<List<Episode>> findDownloads();

  /// Queue
  Future<void> saveQueue(List<Episode> episodes);

  Future<List<Episode>> loadQueue();

  /// Event listeners
  late Stream<Podcast> podcastListener;
  late Stream<EpisodeState> episodeListener;
}

// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/domain/podcast/search_result.dart';
import 'package:podcast_search/podcast_search.dart' as pslib;

/// A simple wrapper class that interacts with the firebase feed API via
/// and then use the podcast_search package to load the rss links for podcast.
abstract class PodcastApi {
  /// Request the top podcast charts from backEnd, and at most [size] records.
  Future<SearchResult> charts();

  /// URL representing the RSS feed for a podcast.
  Future<pslib.Podcast> loadFeed(String url);

  /// Load episode chapters via JSON file.
  Future<pslib.Chapters> loadChapters(String url);
}

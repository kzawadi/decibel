// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decibel/domain/podcast/item.dart';
import 'package:decibel/domain/podcast/search_result.dart';
import 'package:decibel/infrastructure/podcast/services/podcast_api.dart';
import 'package:podcast_search/podcast_search.dart' as podcast_search;

/// An implementation of the [PodcastApi]. A simple wrapper class that
/// interacts with the backend API via the
/// podcast_search package.
class MobilePodcastApi extends PodcastApi {
  final firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<SearchResult> charts() async {
    const nothing = '';

    return _charts(nothing); //compute(_charts, nothing);
  }

  @override
  Future<podcast_search.Podcast> loadFeed(String url) async {
    return _loadFeed(url);
  }

  @override
  Future<podcast_search.Chapters> loadChapters(String url) async {
    return podcast_search.Podcast.loadChaptersByUrl(url: url);
  }

  Future<SearchResult> _charts(String nothing) async {
    final feedcollection = firebaseFirestore.collection('feed');

    final snapshot = await feedcollection.get();

    final itemu = snapshot.docs.map((doc) {
      final data = doc.data();
      return Item.fromJson(json: data);
    }).toList();

    final sr = SearchResult(
      items: itemu,
    );

    print('The fetched data from firestore is$itemu');
    return sr;
  }
}

Future<podcast_search.Podcast> _loadFeed(String url) {
  return podcast_search.Podcast.loadFeed(
    url: url,
  );
}

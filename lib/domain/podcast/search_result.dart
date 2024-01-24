// Copyright (c) 2023 Kelvin Zawadi and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'package:decibel/domain/podcast/item.dart';

/// This class is a container for our search results or for any error message
/// received whilst attempting to fetch the podcast data.
class SearchResult {
  SearchResult({
    this.resultCount = 0,
    this.items = const <Item>[],
  })  : successful = true,
        lastError = '',
        processedTime = DateTime.now();

  factory SearchResult.fromJson({required dynamic json}) {
    /// Fetch the results from the JSON data.
    final items = (json as List)
        .cast<Map<String, dynamic>>()
        .map((Map<String, dynamic> item) {
      return Item.fromJson(json: item);
    }).toList();

    return SearchResult(
      items: items ?? <Item>[],
    );
  }

  /// The number of podcasts found.
  final int resultCount;

  /// True if the search was successful; false otherwise.
  final bool successful;

  /// The list of search results.
  final List<Item> items;

  /// The last error.
  final String lastError;

  /// Date & time of search
  final DateTime processedTime;
}

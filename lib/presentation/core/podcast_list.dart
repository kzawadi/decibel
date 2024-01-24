// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/settings/settings_bloc.dart';
import 'package:decibel/domain/podcast/app_settings.dart';
import 'package:decibel/domain/podcast/podcast.dart';
import 'package:decibel/domain/podcast/search_result.dart';
import 'package:decibel/presentation/core/podcast_grid_tile.dart';
import 'package:decibel/presentation/core/podcast_tile.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class PodcastList extends StatelessWidget {
  const PodcastList({
    required this.results,
    super.key,
  });

  // final search.SearchResult results;
  final SearchResult results;

  @override
  Widget build(BuildContext context) {
    final settingsBloc = Provider.of<SettingsBloc>(context);

    if (results.items.isNotEmpty) {
      return StreamBuilder<AppSettings>(
        stream: settingsBloc.settings,
        builder: (context, settingsSnapshot) {
          if (settingsSnapshot.hasData) {
            final mode = settingsSnapshot.data!.layout;
            final size = mode == 1 ? 100.0 : 160.0;

            if (mode == 0) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final i = results.items[index];
                    final p = Podcast.fromSearchResultItem(i);

                    return PodcastTile(podcast: p);
                  },
                  childCount: results.items.length,
                  addAutomaticKeepAlives: false,
                ),
              );
            }
            return SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: size,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final i = results.items[index];
                  final p = Podcast.fromSearchResultItem(i);

                  return PodcastGridTile(podcast: p);
                },
                childCount: results.items.length,
              ),
            );
          } else {
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: SizedBox(
                height: 0,
                width: 0,
              ),
            );
          }
        },
      );
    } else {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.search,
                size: 75,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                'L.of(context).no_search_results_message',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }
}

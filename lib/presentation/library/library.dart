// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/bloc/podcast_bloc.dart';
import 'package:decibel/application/settings/settings_bloc.dart';
import 'package:decibel/domain/podcast/app_settings.dart';
import 'package:decibel/domain/podcast/podcast.dart';
import 'package:decibel/domain/podcast/podcast_model.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/core/platform_progress_indicator.dart';
import 'package:decibel/presentation/core/podcast_grid_tile.dart';
import 'package:decibel/presentation/core/podcast_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    final podcastBloc = Provider.of<PodcastBloc>(context);
    final settingsBloc = Provider.of<SettingsBloc>(context);

    return StreamBuilder<List<Podcast>>(
      stream: podcastBloc.subscriptions,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.headset,
                      size: 75,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(
                      AppStrings.noSubscriptionsMessage,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else {
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
                          return PodcastTile(
                            podcast: snapshot.data!.elementAt(index),
                          );
                        },
                        childCount: snapshot.data!.length,
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
                        return PodcastGridTile(
                          podcast: snapshot.data!.elementAt(index),
                        );
                      },
                      childCount: snapshot.data!.length,
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
          }
        } else {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PlatformProgressIndicator(),
              ],
            ),
          );
        }
      },
    );
  }
}

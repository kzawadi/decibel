// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/bloc/bloc_state.dart';
import 'package:decibel/application/bloc/episode_bloc.dart';
import 'package:decibel/application/bloc/queue_event_state.dart';
import 'package:decibel/domain/podcast/episode.dart';
import 'package:decibel/domain/podcast/queue_bloc.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/core/episode_tile.dart';
import 'package:decibel/presentation/core/platform_progress_indicator.dart';
import 'package:decibel/presentation/podcast/podcast_episode_list.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class Downloads extends StatefulWidget {
  const Downloads({
    super.key,
  });

  @override
  State<Downloads> createState() => _DownloadsState();
}

/// Displays a list of podcast episodes that the user has downloaded.
class _DownloadsState extends State<Downloads> {
  @override
  void initState() {
    super.initState();

    final bloc = Provider.of<EpisodeBloc>(context, listen: false);

    bloc.fetchDownloads(false);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EpisodeBloc>(context);

    return StreamBuilder<BlocState>(
      stream: bloc.downloads,
      builder: (BuildContext context, AsyncSnapshot<BlocState> snapshot) {
        final state = snapshot.data;

        if (state is BlocPopulatedState<List<Episode>>) {
          return PodcastEpisodeList(
            episodes: state.results,
            play: true,
            download: false,
            icon: Ionicons.download,
            emptyMessage: AppStrings.noDownloadsMessage,
          );
        } else {
          if (state is BlocLoadingState) {
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PlatformProgressIndicator(),
                ],
              ),
            );
          } else if (state is BlocErrorState) {
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: Text('ERROR'),
            );
          }

          return SliverFillRemaining(
            hasScrollBody: false,
            child: Container(),
          );
        }
      },
    );
  }

  ///TODO: Refactor out into a separate Widget class
  Widget buildResults(BuildContext context, List<Episode> episodes) {
    if (episodes.isNotEmpty) {
      final queueBloc = Provider.of<QueueBloc>(context);

      return StreamBuilder<QueueState>(
        stream: queueBloc.queue,
        builder: (context, snapshot) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                var queued = false;
                final episode = episodes[index];

                if (snapshot.hasData) {
                  queued = snapshot.data!.queue
                      .any((element) => element.guid == episode.guid);
                }

                return EpisodeTile(
                  episode: episode,
                  download: false,
                  play: true,
                  queued: queued,
                );
              },
              childCount: episodes.length,
              addAutomaticKeepAlives: false,
            ),
          );
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
                Ionicons.download,
                size: 75,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                AppStrings.noDownloadsMessage,
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

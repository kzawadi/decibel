// Copyright 2023 Kelvin Zawadi . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/bloc/podcast_bloc.dart';
import 'package:decibel/domain/podcast/podcast.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/core/podcast_details.dart';
import 'package:decibel/presentation/core/tile_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PodcastGridTile extends StatelessWidget {
  const PodcastGridTile({
    required this.podcast,
    super.key,
  });
  final Podcast podcast;

  @override
  Widget build(BuildContext context) {
    final podcastBloc = Provider.of<PodcastBloc>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            settings: const RouteSettings(name: 'podcastdetails'),
            builder: (context) => PodcastDetails(podcast, podcastBloc),
          ),
        );
      },
      child: GridTile(
        child: Hero(
          key: Key('tilehero${podcast.imageUrl}:${podcast.link}'),
          tag: '${podcast.imageUrl}:${podcast.link}',
          child: TileImage(
            url: podcast.imageUrl!,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class PodcastTitledGridTile extends StatelessWidget {
  const PodcastTitledGridTile({
    required this.podcast,
    super.key,
  });
  final Podcast podcast;

  @override
  Widget build(BuildContext context) {
    final podcastBloc = Provider.of<PodcastBloc>(context);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            settings: const RouteSettings(name: 'podcastdetails'),
            builder: (context) => PodcastDetails(podcast, podcastBloc),
          ),
        );
      },
      child: GridTile(
        child: Hero(
          key: Key('tilehero${podcast.imageUrl}:${podcast.link}'),
          tag: '${podcast.imageUrl}:${podcast.link}',
          child: Column(
            children: [
              TileImage(
                url: podcast.imageUrl!,
                size: 128,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                ),
                child: Text(
                  podcast.title ?? AppStrings.noTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

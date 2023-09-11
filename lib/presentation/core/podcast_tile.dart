// Copyright 2023 Kelvin Zawadi. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/bloc/podcast_bloc.dart';
import 'package:decibel/domain/podcast/podcast.dart';
import 'package:decibel/presentation/core/podcast_details.dart';
import 'package:decibel/presentation/core/tile_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PodcastTile extends StatelessWidget {
  const PodcastTile({
    required this.podcast,
    super.key,
  });
  final Podcast podcast;

  @override
  Widget build(BuildContext context) {
    final podcastBloc = Provider.of<PodcastBloc>(context);

    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            settings: const RouteSettings(name: 'podcastdetails'),
            builder: (context) => PodcastDetails(podcast, podcastBloc),
          ),
        );
      },
      minVerticalPadding: 9,
      leading: Hero(
        key: Key('tilehero${podcast.imageUrl}:${podcast.link}'),
        tag: '${podcast.imageUrl}:${podcast.link}',
        child: TileImage(
          url: podcast.imageUrl!,
          size: 60,
        ),
      ),
      title: Text(
        podcast.title,
        maxLines: 1,
      ),

      /// A ListTile's density changes depending upon whether we have 2 or more lines of text. We
      /// manually add a newline character here to ensure the density is consistent whether the
      /// podcast subtitle spans 1 or more lines. Bit of a hack, but a simple solution.
      subtitle: Text(
        '${podcast.copyright ?? ''}\n',
        maxLines: 2,
      ),
    );
  }
}

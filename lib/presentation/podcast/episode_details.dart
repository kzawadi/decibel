// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/domain/podcast/episode.dart';
import 'package:decibel/presentation/core/episode_tile.dart';
import 'package:decibel/presentation/core/person_avatar.dart';
import 'package:decibel/presentation/core/podcast_html.dart';
import 'package:decibel/presentation/core/tile_image.dart';
import 'package:decibel/presentation/podcast/transport_controls.dart';
import 'package:flutter/material.dart';

class EpisodeDetails extends StatefulWidget {
  const EpisodeDetails({
    required this.episode,
    super.key,
  });
  final Episode episode;

  @override
  State<EpisodeDetails> createState() => _EpisodeDetailsState();
}

class _EpisodeDetailsState extends State<EpisodeDetails> {
  @override
  Widget build(BuildContext context) {
    final episode = widget.episode;

    /// Ensure we do not highlight this as a new episode
    episode.highlight = false;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              ExpansionTile(
                key: const Key('episodemoreinfo'),
                trailing: PlayControl(
                  episode: episode,
                ),
                leading: Stack(
                  alignment: Alignment.bottomLeft,
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    TileImage(
                      url: episode.thumbImageUrl ?? episode.imageUrl!,
                      size: 56,
                      highlight: episode.highlight,
                    ),
                    SizedBox(
                      height: 5,
                      width: 56.0 * (episode.percentagePlayed / 100),
                      child: Container(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                subtitle: EpisodeSubtitle(episode),
                title: Text(
                  episode.title ?? 'no title',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: false,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    episode.title ?? 'no title',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (episode.persons.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: Container(
                    child: ListView.builder(
                      itemCount: episode.persons.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return PersonAvatar(person: episode.persons[index]);
                      },
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                ),
                child: PodcastHtml(
                  content: episode.content ??
                      episode.description ??
                      'no descritpition',
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

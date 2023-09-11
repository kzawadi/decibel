// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/bloc/audio_bloc.dart';
import 'package:decibel/domain/podcast/episode.dart';
import 'package:decibel/presentation/core/episode_tile.dart';
import 'package:decibel/presentation/core/tile_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DraggableEpisodeTile extends StatelessWidget {
  const DraggableEpisodeTile({
    required this.episode,
    super.key,
    this.index = 0,
    this.draggable = true,
    this.playable = false,
  });
  final Episode episode;
  final int index;
  final bool draggable;
  final bool playable;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);

    return ListTile(
      key: Key('DT${episode.guid}'),
      enabled: playable,
      leading: TileImage(
        url: episode.thumbImageUrl ?? episode.imageUrl ?? '',
        size: 56,
        highlight: episode.highlight,
      ),
      title: Text(
        episode.title ?? 'no title',
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        softWrap: false,
        style: textTheme.bodyMedium,
      ),
      subtitle: EpisodeSubtitle(episode),
      trailing: draggable
          ? ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.error_outline),
            )
          : const SizedBox(
              width: 0,
              height: 0,
            ),
      onTap: () {
        if (playable) {
          audioBloc.play(episode);
        }
      },
    );
  }
}

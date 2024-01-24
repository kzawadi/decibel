// Copyright 2023 Kelvin Zawadi . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/bloc/bloc_state.dart';
import 'package:decibel/application/bloc/podcast_bloc.dart';
import 'package:decibel/domain/podcast/podcast.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This class is responsible for rendering the context menu on the podcast details
/// page. It returns either a [_MaterialPodcastMenu] or a [_CupertinoContextMenu}
/// instance depending upon which platform we are running on.
///
/// The target platform is based on the current [Theme]: [ThemeData.platform].
class PodcastContextMenu extends StatelessWidget {
  const PodcastContextMenu(this.podcast, {super.key});
  final Podcast podcast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return _MaterialPodcastMenu(podcast);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return _CupertinoContextMenu(podcast);
    }
  }
}

/// This is the material design version of the context menu. This will be rendered
/// for all platforms that are not iOS.
class _MaterialPodcastMenu extends StatelessWidget {
  const _MaterialPodcastMenu(this.podcast);
  final Podcast podcast;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PodcastBloc>(context);

    return StreamBuilder<BlocState<Podcast>>(
      stream: bloc.details,
      builder: (context, snapshot) {
        return PopupMenuButton<String>(
          onSelected: (event) {
            togglePlayed(value: event, bloc: bloc);
          },
          icon: const Icon(
            Icons.more_vert,
          ),
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'ma',
                enabled: podcast.subscribed,
                child: const Text(AppStrings.markEpisodesPlayedLabel),
              ),
              PopupMenuItem<String>(
                value: 'ua',
                enabled: podcast.subscribed,
                child: const Text(AppStrings.markEpisodesNotPlayedLabel),
              ),
            ];
          },
        );
      },
    );
  }

  void togglePlayed({
    required String value,
    required PodcastBloc bloc,
  }) {
    if (value == 'ma') {
      bloc.podcastEvent(PodcastEvent.markAllPlayed);
    } else if (value == 'ua') {
      bloc.podcastEvent(PodcastEvent.clearAllPlayed);
    }
  }
}

/// This is the Cupertino context menu and is rendered only when running on
/// an iOS device.
class _CupertinoContextMenu extends StatelessWidget {
  const _CupertinoContextMenu(this.podcast);
  final Podcast podcast;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PodcastBloc>(context);

    return StreamBuilder<BlocState<Podcast>>(
      stream: bloc.details,
      builder: (context, snapshot) {
        return IconButton(
          icon: const Icon(CupertinoIcons.ellipsis),
          onPressed: () => showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) {
              return CupertinoActionSheet(
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: () {
                      bloc.podcastEvent(PodcastEvent.markAllPlayed);
                      Navigator.pop(context, 'Cancel');
                    },
                    child: const Text(AppStrings.markEpisodesPlayedLabel),
                  ),
                  CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: () {
                      bloc.podcastEvent(PodcastEvent.clearAllPlayed);
                      Navigator.pop(context, 'Cancel');
                    },
                    child: const Text(AppStrings.markEpisodesNotPlayedLabel),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                  },
                  child: Text(AppStrings.cancelOptionLabel),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

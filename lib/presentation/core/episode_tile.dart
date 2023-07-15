// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/bloc/episode_bloc.dart';
import 'package:decibel/application/bloc/queue_event_state.dart';
import 'package:decibel/domain/podcast/episode.dart';
import 'package:decibel/domain/podcast/queue_bloc.dart';
import 'package:decibel/presentation/core/action_text.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/core/tile_image.dart';
import 'package:decibel/presentation/podcast/episode_details.dart';
import 'package:decibel/presentation/podcast/transport_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

/// An EpisodeTitle is built with an [ExpandedTile] widget and displays the
/// episode's basic details, thumbnail and play button. It can then be
/// expanded to present addition information about the episode and further
/// controls.
///
/// TODO: Replace [Opacity] with [Container] with a transparent colour.
class EpisodeTile extends StatelessWidget {
  const EpisodeTile({
    required this.episode,
    required this.download,
    required this.play,
    super.key,
    this.playing = false,
    this.queued = false,
  });
  final Episode episode;
  final bool download;
  final bool play;
  final bool playing;
  final bool queued;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final episodeBloc = Provider.of<EpisodeBloc>(context);
    final queueBloc = Provider.of<QueueBloc>(context);

    return ExpansionTile(
      key: Key('PT${episode.guid}'),
      trailing: Opacity(
        opacity: episode.played ? 0.5 : 1.0,
        child: EpisodeTransportControls(
          episode: episode,
          download: download,
          play: play,
        ),
      ),
      leading: Stack(
        alignment: Alignment.bottomLeft,
        fit: StackFit.passthrough,
        children: <Widget>[
          Opacity(
            opacity: episode.played ? 0.5 : 1.0,
            child: TileImage(
              url: episode.thumbImageUrl ?? episode.imageUrl!,
              size: 56,
              highlight: episode.highlight,
            ),
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
      subtitle: Opacity(
        opacity: episode.played ? 0.5 : 1.0,
        child: EpisodeSubtitle(episode),
      ),
      title: Opacity(
        opacity: episode.played ? 0.5 : 1.0,
        child: Text(
          episode.title ?? 'no title',
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          softWrap: false,
          style: textTheme.bodyMedium,
        ),
      ),
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            child: Text(
              episode.descriptionText ?? 'No description',
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 5,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: episode.downloaded
                      ? () {
                          showPlatformDialog<void>(
                            context: context,
                            useRootNavigator: false,
                            builder: (_) => BasicDialogAlert(
                              title: const Text(
                                AppStrings.deleteEpisodeLabel,
                              ),
                              content: const Text(
                                AppStrings.deleteEpisodeConfirmation,
                              ),
                              actions: <Widget>[
                                BasicDialogAction(
                                  title: const ActionText(
                                    AppStrings.cancleButtonLabel,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                BasicDialogAction(
                                  title: const ActionText(
                                    AppStrings.deleteButtonLabel,
                                  ),
                                  iosIsDefaultAction: true,
                                  iosIsDestructiveAction: true,
                                  onPressed: () {
                                    episodeBloc.deleteDownload(episode);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      : null,
                  child: const Column(
                    children: <Widget>[
                      Icon(
                        // Icons.delete_outline,
                        Ionicons.trash_outline,
                        size: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                      ),
                      Text(
                        AppStrings.deleteLabel,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: playing
                      ? null
                      : () {
                          if (queued) {
                            queueBloc
                                .queueEvent(QueueRemoveEvent(episode: episode));
                          } else {
                            queueBloc
                                .queueEvent(QueueAddEvent(episode: episode));
                          }
                        },
                  child: Column(
                    children: <Widget>[
                      Icon(
                        queued
                            ? Icons.playlist_add_check_outlined
                            : Icons.playlist_add_outlined,
                        size: 22,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                      ),
                      Text(
                        queued ? 'Remove' : 'Add',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () {
                    episodeBloc.togglePlayed(episode);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        episode.played
                            ? Icons.unpublished_outlined
                            : Ionicons
                                .checkmark_circle_outline, //Icons.check_circle_outline,
                        size: 22,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                      ),
                      Text(
                        episode.played
                            ? AppStrings.markUnplayedLabel
                            : AppStrings.markPlayedLabel,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      backgroundColor: theme.bottomAppBarTheme.color,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      builder: (context) {
                        return EpisodeDetails(
                          episode: episode,
                        );
                      },
                    );
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.unfold_more_outlined,
                        size: 22,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                      ),
                      Text(
                        AppStrings.moreLabel,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class EpisodeTransportControls extends StatelessWidget {
  const EpisodeTransportControls({
    required this.episode,
    required this.download,
    required this.play,
    super.key,
  });
  final Episode episode;
  final bool download;
  final bool play;

  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[];

    if (download) {
      buttons.add(
        Padding(
          padding: const EdgeInsets.only(),
          child: DownloadControl(
            episode: episode,
          ),
        ),
      );
    }

    if (play) {
      buttons.add(
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: PlayControl(
            episode: episode,
          ),
        ),
      );
    }

    return SizedBox(
      width: (buttons.length * 38.0) + 8.0,
      child: Row(
        children: <Widget>[...buttons],
      ),
    );
  }
}

class EpisodeSubtitle extends StatelessWidget {
  EpisodeSubtitle(this.episode, {super.key})
      : date = episode.publicationDate == null
            ? ''
            : DateFormat(
                episode.publicationDate!.year == DateTime.now().year
                    ? 'd MMM'
                    : 'd MMM yy',
              ).format(episode.publicationDate!),
        length = Duration(seconds: episode.duration);
  final Episode episode;
  final String date;
  final Duration length;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final timeRemaining = episode.timeRemaining;

    String title;

    if (length.inSeconds > 0) {
      if (length.inSeconds < 60) {
        title = '$date - ${length.inSeconds} sec';
      } else {
        title = '$date - ${length.inMinutes} min';
      }
    } else {
      title = date;
    }

    if (timeRemaining.inSeconds > 0) {
      if (timeRemaining.inSeconds < 60) {
        title = '$title / ${timeRemaining.inSeconds} sec left';
      } else {
        title = '$title / ${timeRemaining.inMinutes} min left';
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        title,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: textTheme.bodySmall,
      ),
    );
  }
}

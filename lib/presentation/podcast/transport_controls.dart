// Copyright 2023 Kelvin zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/bloc/audio_bloc.dart';
import 'package:decibel/application/bloc/episode_bloc.dart';
import 'package:decibel/application/bloc/now_playing.dart';
import 'package:decibel/application/bloc/podcast_bloc.dart';
import 'package:decibel/application/settings/settings_bloc.dart';
import 'package:decibel/domain/podcast/app_settings.dart';
import 'package:decibel/domain/podcast/downloadable.dart';
import 'package:decibel/domain/podcast/episode.dart';
import 'package:decibel/infrastructure/podcast/services/audio/audio_player_service.dart';
import 'package:decibel/presentation/core/action_text.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/core/download_button.dart';
import 'package:decibel/presentation/core/play_pause_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

/// Handles the state of the episode transport controls. This currently
/// consists of the [PlayControl] and [DownloadControl] to handle the
/// play/pause and download control state respectively.
class PlayControl extends StatelessWidget {
  const PlayControl({
    required this.episode,
    super.key,
  });
  final Episode episode;

  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    final settings =
        Provider.of<SettingsBloc>(context, listen: false).currentSettings;

    return StreamBuilder<PlayerControlState>(
      stream: Rx.combineLatest2(
        audioBloc.playingState!,
        audioBloc.nowPlaying!,
        PlayerControlState.new,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final audioState = snapshot.data!.audioState;
          final nowPlaying = snapshot.data!.episode;

          if (episode.downloadState != DownloadState.downloading) {
            // If this episode is the one we are playing, allow the user
            // to toggle between play and pause.
            if (snapshot.hasData && nowPlaying?.guid == episode.guid) {
              if (audioState == AudioState.playing) {
                return InkWell(
                  onTap: () {
                    audioBloc.transitionState(TransitionState.pause);
                  },
                  child: PlayPauseButton(
                    title: episode.title ?? 'no title',
                    label: AppStrings.pauseButtonLabel,
                    icon: Icons.pause,
                  ),
                );
              } else if (audioState == AudioState.buffering) {
                return PlayPauseBusyButton(
                  title: episode.title ?? 'no title',
                  label: AppStrings.pauseButtonLabel,
                  icon: Icons.pause,
                );
              } else if (audioState == AudioState.pausing) {
                return InkWell(
                  onTap: () {
                    audioBloc.transitionState(TransitionState.play);
                    optionalShowNowPlaying(context, settings);
                  },
                  child: PlayPauseButton(
                    title: episode.title ?? 'no title',
                    label: AppStrings.playButtonLabel,
                    icon: Icons.play_arrow,
                  ),
                );
              }
            }

            // If this episode is not the one we are playing, allow the
            // user to start playing this episode.
            return InkWell(
              onTap: () {
                audioBloc.play(episode);
                optionalShowNowPlaying(context, settings);
              },
              child: PlayPauseButton(
                title: episode.title ?? 'no title',
                label: AppStrings.playButtonLabel,
                icon: Icons.play_arrow,
              ),
            );
          } else {
            // We are currently downloading this episode. Do not allow
            // the user to play it until the download is complete.
            return Opacity(
              opacity: 0.2,
              child: PlayPauseButton(
                title: episode.title ?? 'no title',
                label: AppStrings.playButtonLabel,
                icon: Icons.play_arrow,
              ),
            );
          }
        } else {
          // We have no playing information at the moment. Show a play button
          // until the stream wakes up.
          if (episode.downloadState != DownloadState.downloading) {
            return InkWell(
              onTap: () {
                audioBloc.play(episode);
                optionalShowNowPlaying(context, settings);
              },
              child: PlayPauseButton(
                title: episode.title ?? 'no title',
                label: AppStrings.playButtonLabel,
                icon: Icons.play_arrow,
              ),
            );
          } else {
            return Opacity(
              opacity: 0.2,
              child: PlayPauseButton(
                title: episode.title ?? 'no title',
                label: AppStrings.playButtonLabel,
                icon: Icons.play_arrow,
              ),
            );
          }
        }
      },
    );
  }

  /// If we have the 'show now playing upon play' option set to true, launch
  /// the [NowPlaying] widget automatically.
  void optionalShowNowPlaying(BuildContext context, AppSettings settings) {
    if (settings.autoOpenNowPlaying) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => const NowPlaying(),
          settings: const RouteSettings(name: 'nowplaying'),
        ),
      );
    }
  }
}

class DownloadControl extends StatelessWidget {
  const DownloadControl({
    required this.episode,
    super.key,
  });
  final Episode episode;

  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context);
    final podcastBloc = Provider.of<PodcastBloc>(context);

    return StreamBuilder<PlayerControlState>(
      stream: Rx.combineLatest2(
        audioBloc.playingState!,
        audioBloc.nowPlaying!,
        PlayerControlState.new,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final audioState = snapshot.data!.audioState;
          final nowPlaying = snapshot.data!.episode;

          if (nowPlaying?.guid == episode.guid &&
              (audioState == AudioState.playing ||
                  audioState == AudioState.buffering)) {
            if (episode.downloadState != DownloadState.downloaded) {
              return Opacity(
                opacity: 0.2,
                child: DownloadButton(
                  onPressed: () {},
                  title: episode.title ?? 'no title',
                  icon: Icons.save_alt,
                  percent: 0,
                  label: AppStrings.downloadEpisodeButtonLabel,
                ),
              );
            } else {
              return Opacity(
                opacity: 0.2,
                child: DownloadButton(
                  onPressed: () {},
                  title: episode.title ?? 'no title',
                  icon: Icons.check,
                  percent: 0,
                  label: AppStrings.downloadEpisodeButtonLabel,
                ),
              );
            }
          }
        }

        if (episode.downloadState == DownloadState.downloaded) {
          return DownloadButton(
            onPressed: () {},
            title: episode.title ?? 'no title',
            icon: Icons.check,
            percent: 0,
            label: AppStrings.downloadEpisodeButtonLabel,
          );
        } else if (episode.downloadState == DownloadState.queued) {
          return DownloadButton(
            onPressed: () => _showCancelDialog(context),
            title: episode.title ?? 'no title',
            icon: Icons.timer_outlined,
            percent: 0,
            label: AppStrings.downloadEpisodeButtonLabel,
          );
        } else if (episode.downloadState == DownloadState.downloading) {
          return DownloadButton(
            onPressed: () => _showCancelDialog(context),
            title: episode.title ?? 'no title',
            icon: Icons.timer_outlined,
            percent: episode.downloadPercentage!,
            label: AppStrings.downloadEpisodeButtonLabel,
          );
        }

        return DownloadButton(
          onPressed: () => podcastBloc.downloadEpisode(episode),
          title: episode.title ?? 'no title',
          icon: Icons.save_alt,
          percent: 0,
          label: AppStrings.downloadEpisodeButtonLabel,
        );
      },
    );
  }

  Future<void> _showCancelDialog(BuildContext context) {
    final episodeBloc = Provider.of<EpisodeBloc>(context, listen: false);

    return showPlatformDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (_) => BasicDialogAlert(
        title: const Text(
          AppStrings.stopDownloadTitle,
        ),
        content: const Text(AppStrings.stopDownloadConfirmation),
        actions: <Widget>[
          BasicDialogAction(
            title: const ActionText(
              AppStrings.cancelButtonLabel,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          BasicDialogAction(
            title: const ActionText(
              AppStrings.stopDownloadButtonLabel,
            ),
            iosIsDefaultAction: true,
            onPressed: () {
              episodeBloc.deleteDownload(episode);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

/// This class acts as a wrapper between the current audio state and
/// downloadables. Saves all that nesting of StreamBuilders.
class PlayerControlState {
  PlayerControlState(this.audioState, this.episode);
  final AudioState audioState;
  final Episode? episode;
}

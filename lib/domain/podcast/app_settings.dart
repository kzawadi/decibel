// Copyright 2023 Kelvin zawadi @kzawadi. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

class AppSettings {
  AppSettings({
    required this.theme,
    required this.markDeletedEpisodesAsPlayed,
    required this.storeDownloadsSDCard,
    required this.playbackSpeed,
    required this.autoOpenNowPlaying,
    required this.autoUpdateEpisodePeriod,
    required this.trimSilence,
    required this.volumeBoost,
    required this.layout,
  });
  AppSettings.decibelDefaults()
      : theme = 'dark',
        markDeletedEpisodesAsPlayed = false,
        storeDownloadsSDCard = false,
        playbackSpeed = 1.0,
        autoOpenNowPlaying = false,
        autoUpdateEpisodePeriod = -1,
        trimSilence = false,
        volumeBoost = false,
        layout = 0;

  /// The current theme name.
  final String theme;

  /// True if episodes are marked as played when deleted.
  final bool markDeletedEpisodesAsPlayed;

  /// True if downloads should be saved to the SD card.
  final bool storeDownloadsSDCard;

  /// The default playback speed.
  final double playbackSpeed;

  /// If true the main player window will open as soon as an episode starts.
  final bool autoOpenNowPlaying;

  /// If true the funding link icon will appear (if the podcast supports it).
  // final bool showFunding;

  /// If -1 never; 0 always; otherwise time in minutes.
  final int? autoUpdateEpisodePeriod;

  /// If true, silence in audio playback is trimmed. Currently Android only.
  final bool trimSilence;

  /// If true, volume is boosted. Currently Android only.
  final bool volumeBoost;

  /// If 0, list view; else grid view
  final int layout;
}

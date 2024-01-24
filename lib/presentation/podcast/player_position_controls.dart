// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:decibel/application/bloc/audio_bloc.dart';
import 'package:decibel/infrastructure/podcast/services/audio/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This class handles the rendering of the positional controls: the current playback
/// time, time remaining and the time [Slider].
class PlayerPositionControls extends StatefulWidget {
  const PlayerPositionControls({super.key});

  @override
  State<PlayerPositionControls> createState() => _PlayerPositionControlsState();
}

class _PlayerPositionControlsState extends State<PlayerPositionControls> {
  /// Current playback position
  int currentPosition = 0;

  /// Indicates the user is moving the position slide. We should ignore
  /// position updates until the user releases the slide.
  bool dragging = false;

  /// Seconds left of this episode.
  int timeRemaining = 0;

  /// The length of the episode in seconds.
  int episodeLength = 0;

  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context);

    return StreamBuilder<PositionState>(
      stream: audioBloc.playPosition,
      builder: (context, snapshot) {
        final position =
            snapshot.hasData ? snapshot.data!.position.inSeconds : 0;
        episodeLength = snapshot.hasData ? snapshot.data!.length.inSeconds : 0;
        final divisions = episodeLength == 0 ? 1 : episodeLength;

        if (!dragging) {
          currentPosition = position;

          if (currentPosition < 0) {
            currentPosition = 0;
          }

          if (currentPosition > episodeLength) {
            currentPosition = episodeLength;
          }

          timeRemaining = episodeLength - position;

          if (timeRemaining < 0) {
            timeRemaining = 0;
          }
        }

        return Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 4,
          ),
          child: Row(
            children: <Widget>[
              FittedBox(
                child: Text(
                  _formatDuration(Duration(seconds: currentPosition)),
                  style: const TextStyle(
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Expanded(
                child: snapshot.hasData
                    ? Slider(
                        label:
                            _formatDuration(Duration(seconds: currentPosition)),
                        onChanged: (value) {
                          setState(() {
                            _calculatePositions(value.toInt());
                          });
                        },
                        onChangeStart: (value) {
                          if (!snapshot.data!.buffering) {
                            setState(() {
                              dragging = true;
                              _calculatePositions(currentPosition);
                            });
                          } else {
                            return;
                          }
                        },
                        onChangeEnd: (value) {
                          setState(() {
                            dragging = false;
                          });

                          return snapshot.data!.buffering
                              ? null
                              : audioBloc.transitionPosition(value);
                        },
                        value: currentPosition.toDouble(),
                        max: episodeLength.toDouble(),
                        divisions: divisions,
                        activeColor: Theme.of(context).primaryColor,
                      )
                    : Slider(
                        onChanged: null,
                        value: 0,
                        activeColor: Theme.of(context).primaryColor,
                      ),
              ),
              FittedBox(
                child: Text(
                  _formatDuration(Duration(seconds: timeRemaining)),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _calculatePositions(int p) {
    currentPosition = p;
    timeRemaining = episodeLength - p;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}

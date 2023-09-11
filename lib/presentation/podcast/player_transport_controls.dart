// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:decibel/application/bloc/audio_bloc.dart';
import 'package:decibel/infrastructure/podcast/services/audio/audio_player_service.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/core/sleep_selector.dart';
import 'package:decibel/presentation/core/speed_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

/// Builds a transport control bar for rewind, play and fast-forward.
/// See [NowPlaying].
class PlayerTransportControls extends StatefulWidget {
  const PlayerTransportControls({super.key});

  @override
  State<PlayerTransportControls> createState() =>
      _PlayerTransportControlsState();
}

class _PlayerTransportControlsState extends State<PlayerTransportControls> {
  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<AudioState>(
        stream: audioBloc.playingState,
        initialData: AudioState.none,
        builder: (context, snapshot) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SleepSelectorWidget(),
              IconButton(
                onPressed: () {
                  return snapshot.data == AudioState.buffering
                      ? null
                      : _rewind(audioBloc);
                },
                tooltip: AppStrings.rewindButtonLabel,
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.replay_10,
                  size: 48,
                ),
              ),
              AnimatedPlayButton(audioState: snapshot.data!),
              IconButton(
                onPressed: () {
                  return snapshot.data == AudioState.buffering
                      ? null
                      : _fastforward(audioBloc);
                },
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.forward_30,
                  size: 48,
                ),
              ),
              const SpeedSelectorWidget(),
            ],
          );
        },
      ),
    );
  }

  void _rewind(AudioBloc audioBloc) {
    audioBloc.transitionState(TransitionState.rewind);
  }

  void _fastforward(AudioBloc audioBloc) {
    audioBloc.transitionState(TransitionState.fastforward);
  }
}

typedef PlayHandler = Function(AudioBloc audioBloc);

class AnimatedPlayButton extends StatefulWidget {
  const AnimatedPlayButton({
    required this.audioState,
    super.key,
    this.onPlay = _onPlay,
    this.onPause = _onPause,
  });
  final AudioState audioState;
  final PlayHandler onPlay;
  final PlayHandler onPause;

  @override
  State<AnimatedPlayButton> createState() => _AnimatedPlayButtonState();
}

void _onPlay(AudioBloc audioBloc) {
  audioBloc.transitionState(TransitionState.play);
}

void _onPause(AudioBloc audioBloc) {
  audioBloc.transitionState(TransitionState.pause);
}

class _AnimatedPlayButtonState extends State<AnimatedPlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _playPauseController;
  late StreamSubscription<AudioState> _audioStateSubscription;
  bool init = true;

  @override
  void initState() {
    super.initState();

    final audioBloc = Provider.of<AudioBloc>(context, listen: false);

    _playPauseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    /// Seems a little hacky, but when we load the form we want the play/pause
    /// button to be in the correct state. If we are building the first frame,
    /// just set the animation controller to the correct state; for all other
    /// frames we want to animate. Doing it this way prevents the play/pause
    /// button from animating when the form is first loaded.
    _audioStateSubscription = audioBloc.playingState!.listen((event) {
      if (event == AudioState.playing || event == AudioState.buffering) {
        if (init) {
          _playPauseController.value = 1;
          init = false;
        } else {
          _playPauseController.forward();
        }
      } else {
        if (init) {
          _playPauseController.value = 0;
          init = false;
        } else {
          _playPauseController.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    _audioStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);

    final playing = widget.audioState == AudioState.playing;
    final buffering = widget.audioState == AudioState.buffering;

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        if (buffering)
          SpinKitRing(
            lineWidth: 4,
            color: Theme.of(context).primaryColor,
            size: 84,
          ),
        if (!buffering)
          const SizedBox(
            height: 84,
            width: 84,
          ),
        Tooltip(
          message: playing
              ? AppStrings.pauseButtonLabel
              : AppStrings.playButtonLabel,
          child: TextButton(
            style: TextButton.styleFrom(
              shape: CircleBorder(
                side: BorderSide(
                  color: Theme.of(context).highlightColor,
                  width: 0,
                ),
              ),
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.orange
                  : Colors.grey[800],
              foregroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.orange
                  : Colors.grey[800],
              padding: const EdgeInsets.all(6),
            ),
            onPressed: () {
              if (playing) {
                widget.onPause(audioBloc);
                // audioBloc.transitionState(TransitionState.pause);
              } else {
                widget.onPlay(audioBloc);
                // audioBloc.transitionState(TransitionState.play);
              }
            },
            child: AnimatedIcon(
              size: 60,
              icon: AnimatedIcons.play_pause,
              color: Colors.white,
              progress: _playPauseController,
            ),
          ),
        ),
      ],
    );
  }
}

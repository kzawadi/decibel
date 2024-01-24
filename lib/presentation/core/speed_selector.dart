// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/bloc/audio_bloc.dart';
import 'package:decibel/application/settings/settings_bloc.dart';
import 'package:decibel/domain/podcast/app_settings.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/core/slider_handle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This widget allows the user to change the playback speed and toggle audio
/// effects. The two audio effects, trim silence and volume boost, are
/// currently Android only.
class SpeedSelectorWidget extends StatefulWidget {
  const SpeedSelectorWidget({super.key});

  @override
  State<SpeedSelectorWidget> createState() => _SpeedSelectorWidgetState();
}

class _SpeedSelectorWidgetState extends State<SpeedSelectorWidget> {
  double speed = 1.0;

  @override
  void initState() {
    final settingsBloc = Provider.of<SettingsBloc>(context, listen: false);

    speed = settingsBloc.currentSettings.playbackSpeed;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settingsBloc = Provider.of<SettingsBloc>(context);
    final theme = Theme.of(context);

    return StreamBuilder<AppSettings>(
      stream: settingsBloc.settings,
      initialData: AppSettings.decibelDefaults(),
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: theme.secondaryHeaderColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  builder: (context) {
                    return const SpeedSlider();
                  },
                );
              },
              child: SizedBox(
                height: 36,
                width: 36,
                child: Center(
                  child: Text(
                    snapshot.data!.playbackSpeed == 1.0
                        ? 'x1'
                        : 'x${snapshot.data!.playbackSpeed}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SpeedSlider extends StatefulWidget {
  const SpeedSlider({super.key});

  @override
  State<SpeedSlider> createState() => _SpeedSliderState();
}

class _SpeedSliderState extends State<SpeedSlider> {
  double speed = 1.0;
  bool trimSilence = false;
  bool volumeBoost = false;

  @override
  void initState() {
    final settingsBloc = Provider.of<SettingsBloc>(context, listen: false);

    speed = settingsBloc.currentSettings.playbackSpeed;
    trimSilence = settingsBloc.currentSettings.trimSilence;
    volumeBoost = settingsBloc.currentSettings.volumeBoost;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    final settingsBloc = Provider.of<SettingsBloc>(context, listen: false);
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SliderHandle(),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            AppStrings.audioSettingsPlaybackSpeedLabel,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            '${speed}x',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: IconButton(
                iconSize: 28,
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: (speed <= 0.5)
                    ? null
                    : () {
                        setState(() {
                          speed -= 0.25;
                          audioBloc.playbackSpeed(speed);
                          settingsBloc.setPlaybackSpeed(speed);
                        });
                      },
              ),
            ),
            Expanded(
              flex: 4,
              child: Slider(
                value: speed,
                min: 0.5,
                max: 2,
                divisions: 6,
                onChanged: (value) {
                  setState(() {
                    speed = value;
                  });
                },
                onChangeEnd: (value) {
                  audioBloc.playbackSpeed(speed);
                  settingsBloc.setPlaybackSpeed(value);
                },
              ),
            ),
            Expanded(
              child: IconButton(
                iconSize: 28,
                icon: const Icon(Icons.add_circle_outline),
                onPressed: (speed >= 2.0)
                    ? null
                    : () {
                        setState(() {
                          speed += 0.25;
                          audioBloc.playbackSpeed(speed);
                          settingsBloc.setPlaybackSpeed(speed);
                        });
                      },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        const Divider(),
        if (theme.platform == TargetPlatform.android) ...[
          /// Disable the trim silence option for now until the positioning bug
          /// in just_audio is resolved.
          // ListTile(
          //   title: Text(L.of(context).audio_effect_trim_silence_label),
          //   trailing: Switch.adaptive(
          //     value: trimSilence,
          //     onChanged: (value) {
          //       setState(() {
          //         trimSilence = value;
          //         audioBloc.trimSilence(value);
          //         settingsBloc.trimSilence(value);
          //       });
          //     },
          //   ),
          // ),
          ListTile(
            title: const Text(AppStrings.audioEffectVolumeBoostLabel),
            trailing: Switch.adaptive(
              value: volumeBoost,
              onChanged: (boost) {
                setState(() {
                  volumeBoost = boost;
                  audioBloc.volumeBoost(boost);
                  settingsBloc.volumeBoost(boost);
                });
              },
            ),
          ),
        ] else
          const SizedBox(
            width: 0,
            height: 0,
          ),
      ],
    );
  }
}

// Copyright 2020 Ben Hills and the project contributors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/bloc/audio_bloc.dart';
import 'package:decibel/application/settings/settings_bloc.dart';
import 'package:decibel/domain/podcast/app_settings.dart';
import 'package:decibel/domain/podcast/sleep.dart';
import 'package:decibel/presentation/core/slider_handle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This widget allows the user to change the playback speed and toggle audio effects.
///
/// The two audio effects, trim silence and volume boost, are currently Android only.
class SleepSelectorWidget extends StatefulWidget {
  const SleepSelectorWidget({
    super.key,
  });

  @override
  State<SleepSelectorWidget> createState() => _SleepSelectorWidgetState();
}

class _SleepSelectorWidgetState extends State<SleepSelectorWidget> {
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
              excludeFromSemantics: true,
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
                    return const SleepSlider();
                  },
                );
              },
              child: SizedBox(
                height: 48,
                width: 48,
                child: Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.bedtime_outlined,
                      semanticLabel: 'Sleep Timer',
                      size: 20,
                    ),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        backgroundColor: theme.secondaryHeaderColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        builder: (context) {
                          return const SleepSlider();
                        },
                      );
                    },
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

class SleepSlider extends StatefulWidget {
  const SleepSlider({super.key});

  @override
  State<SleepSlider> createState() => _SleepSliderState();
}

class _SleepSliderState extends State<SleepSlider> {
  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);

    return StreamBuilder<Sleep>(
      stream: audioBloc.sleepStream,
      initialData: Sleep(type: SleepType.none),
      builder: (context, snapshot) {
        final s = snapshot.data;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SliderHandle(),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                'Sleep Timer',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (s != null && s.type == SleepType.none)
              Text(
                '(${'Off'})',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            if (s != null && s.type == SleepType.time)
              Text(
                '(${_formatDuration(s.timeRemaining)})',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            if (s != null && s.type == SleepType.episode)
              Text(
                '(${'End of episode'})',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                shrinkWrap: true,
                children: [
                  SleepSelectorEntry(
                    sleep: Sleep(type: SleepType.none),
                    current: s,
                  ),
                  const Divider(),
                  SleepSelectorEntry(
                    sleep: Sleep(
                      type: SleepType.time,
                      duration: const Duration(minutes: 5),
                    ),
                    current: s,
                  ),
                  const Divider(),
                  SleepSelectorEntry(
                    sleep: Sleep(
                      type: SleepType.time,
                      duration: const Duration(minutes: 10),
                    ),
                    current: s,
                  ),
                  const Divider(),
                  SleepSelectorEntry(
                    sleep: Sleep(
                      type: SleepType.time,
                      duration: const Duration(minutes: 15),
                    ),
                    current: s,
                  ),
                  const Divider(),
                  SleepSelectorEntry(
                    sleep: Sleep(
                      type: SleepType.time,
                      duration: const Duration(minutes: 30),
                    ),
                    current: s,
                  ),
                  const Divider(),
                  SleepSelectorEntry(
                    sleep: Sleep(
                      type: SleepType.time,
                      duration: const Duration(minutes: 45),
                    ),
                    current: s,
                  ),
                  const Divider(),
                  SleepSelectorEntry(
                    sleep: Sleep(
                      type: SleepType.time,
                      duration: const Duration(minutes: 60),
                    ),
                    current: s,
                  ),
                  const Divider(),
                  SleepSelectorEntry(
                    sleep: Sleep(
                      type: SleepType.episode,
                    ),
                    current: s,
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
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

class SleepSelectorEntry extends StatelessWidget {
  const SleepSelectorEntry({
    required this.sleep,
    required this.current,
    super.key,
  });

  final Sleep sleep;
  final Sleep? current;

  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        audioBloc.sleep(
          Sleep(
            type: sleep.type,
            duration: sleep.duration,
          ),
        );

        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 4,
          bottom: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (sleep.type == SleepType.none)
              Text(
                'Off',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            if (sleep.type == SleepType.time)
              Text(
                'minutes${sleep.duration.inMinutes}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            if (sleep.type == SleepType.episode)
              Text(
                'End Of Episode',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            if (sleep == current)
              const Icon(
                Icons.check,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}

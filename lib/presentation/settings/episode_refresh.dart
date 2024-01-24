// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/settings/settings_bloc.dart';
import 'package:decibel/domain/podcast/app_settings.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:provider/provider.dart';

class EpisodeRefreshWidget extends StatefulWidget {
  const EpisodeRefreshWidget({super.key});

  @override
  State<EpisodeRefreshWidget> createState() => _EpisodeRefreshWidgetState();
}

class _EpisodeRefreshWidgetState extends State<EpisodeRefreshWidget> {
  @override
  Widget build(BuildContext context) {
    final settingsBloc = Provider.of<SettingsBloc>(context);

    return StreamBuilder<AppSettings>(
      stream: settingsBloc.settings,
      initialData: AppSettings.decibelDefaults(),
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text(AppStrings.settingsAutoUpdateEpisodes),
              subtitle: updateSubtitle(snapshot.data!),
              onTap: () {
                showPlatformDialog<void>(
                  context: context,
                  useRootNavigator: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        AppStrings.settingsAutoUpdateEpisodesHeading,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      scrollable: true,
                      content: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Column(
                            children: <Widget>[
                              RadioListTile<int>(
                                title: const Text(
                                    AppStrings.settingsAutoUpdateEpisodesNever),
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(),
                                value: -1,
                                groupValue:
                                    snapshot.data!.autoUpdateEpisodePeriod,
                                onChanged: (int? value) {
                                  setState(() {
                                    settingsBloc.autoUpdatePeriod(value);

                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              RadioListTile<int>(
                                title: const Text(AppStrings
                                    .settingsAutoUpdateEpisodesAlways),
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(),
                                value: 0,
                                groupValue:
                                    snapshot.data!.autoUpdateEpisodePeriod,
                                onChanged: (int? value) {
                                  setState(() {
                                    settingsBloc.autoUpdatePeriod(value);

                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              RadioListTile<int>(
                                title: const Text(
                                    AppStrings.settingsAutoUpdateEpisodes30min),
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(),
                                value: 30,
                                groupValue:
                                    snapshot.data!.autoUpdateEpisodePeriod,
                                onChanged: (int? value) {
                                  setState(() {
                                    settingsBloc.autoUpdatePeriod(value);

                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              RadioListTile<int>(
                                title: const Text(
                                    AppStrings.settingsAutoUpdateEpisodes1hour),
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(),
                                value: 60,
                                groupValue:
                                    snapshot.data!.autoUpdateEpisodePeriod,
                                onChanged: (int? value) {
                                  setState(() {
                                    settingsBloc.autoUpdatePeriod(value);

                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              RadioListTile<int>(
                                title: const Text(
                                    AppStrings.settingsAutoUpdateEpisodes3hour),
                                dense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                value: 180,
                                groupValue:
                                    snapshot.data!.autoUpdateEpisodePeriod,
                                onChanged: (int? value) {
                                  setState(() {
                                    settingsBloc.autoUpdatePeriod(value);

                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              RadioListTile<int>(
                                title: const Text(
                                    AppStrings.settingsAutoUpdateEpisodes6hour),
                                dense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                value: 360,
                                groupValue:
                                    snapshot.data!.autoUpdateEpisodePeriod,
                                onChanged: (int? value) {
                                  setState(() {
                                    settingsBloc.autoUpdatePeriod(value);

                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              RadioListTile<int>(
                                title: const Text(AppStrings
                                    .settingsAutoUpdateEpisodes12hour),
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(),
                                value: 720,
                                groupValue:
                                    snapshot.data!.autoUpdateEpisodePeriod,
                                onChanged: (int? value) {
                                  setState(() {
                                    settingsBloc.autoUpdatePeriod(value);

                                    Navigator.pop(context);
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Text updateSubtitle(AppSettings settings) {
    switch (settings.autoUpdateEpisodePeriod) {
      case -1:
        return const Text(AppStrings.settingsAutoUpdateEpisodesNever);
      case 0:
        return const Text(AppStrings.settingsAutoUpdateEpisodesAlways);
      case 10:
        return const Text(AppStrings.settingsAutoUpdateEpisodes10min);
      case 30:
        return const Text(AppStrings.settingsAutoUpdateEpisodes30min);
      case 60:
        return const Text(AppStrings.settingsAutoUpdateEpisodes1hour);
      case 180:
        return const Text(AppStrings.settingsAutoUpdateEpisodes2hour);
      case 360:
        return const Text(AppStrings.settingsAutoUpdateEpisodes6hour);
      case 720:
        return const Text(AppStrings.settingsAutoUpdateEpisodes12hour);
    }

    return const Text('Never');
  }
}

// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/settings/settings_bloc.dart';
import 'package:decibel/domain/podcast/app_settings.dart';
import 'package:decibel/infrastructure/core/utils.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/settings/episode_refresh.dart';
import 'package:decibel/presentation/settings/settings_section_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:provider/provider.dart';

/// This is the settings page and allows the user to select various
/// options for the app. This is a self contained page and so, unlike
/// the other forms, talks directly to a settings service rather than
/// a BLoC. Whilst this deviates slightly from the overall architecture,
/// adding a BLoC to simply be consistent with the rest of the
/// application would add unnecessary complexity.

class Settings extends StatefulWidget {
  const Settings({
    super.key,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool sdcard = false;

  Widget _buildList(BuildContext context) {
    final settingsBloc = Provider.of<SettingsBloc>(context);
    // final podcastBloc = Provider.of<PodcastBloc>(context);

    return StreamBuilder<AppSettings>(
      stream: settingsBloc.settings,
      initialData: settingsBloc.currentSettings,
      builder: (context, snapshot) {
        return ListView(
          children: [
            const SettingsDividerLabel(
              label: AppStrings.settingsPersonalisationDividerLabel,
            ),
            ListTile(
              shape: const RoundedRectangleBorder(),
              title: const Text(AppStrings.settingsThemeSwitchLabel),
              trailing: Switch.adaptive(
                value: snapshot.data!.theme == 'dark',
                onChanged: (value) {
                  settingsBloc.darkMode(value);
                },
              ),
            ),
            const SettingsDividerLabel(
              label: AppStrings.settingsEpisodeDividerLabel,
            ),
            ListTile(
              title: const Text(AppStrings.settingsMarkDeletedPlayedLabel),
              trailing: Switch.adaptive(
                value: snapshot.data!.markDeletedEpisodesAsPlayed,
                onChanged: (value) =>
                    setState(() => settingsBloc.markDeletedAsPlayed(value)),
              ),
            ),
            if (sdcard)
              ListTile(
                title: const Text(AppStrings.settingDownloadSDCardLabel),
                trailing: Switch.adaptive(
                  value: snapshot.data!.storeDownloadsSDCard,
                  onChanged: (value) => sdcard
                      ? setState(() {
                          if (value) {
                            _showStorageDialog(enableExternalStorage: true);
                          } else {
                            _showStorageDialog(enableExternalStorage: false);
                          }

                          settingsBloc.storeDownloadonSDCard(value);
                        })
                      : null,
                ),
              )
            else
              const SizedBox(
                height: 0,
                width: 0,
              ),
            const SettingsDividerLabel(
              label: AppStrings.settingsPlaybackDividerLabel,
            ),
            ListTile(
              title: const Text(AppStrings.settingAutoOpenNowPlaying),
              trailing: Switch.adaptive(
                value: snapshot.data!.autoOpenNowPlaying,
                onChanged: (value) =>
                    setState(() => settingsBloc.setAutoOpenNowPlaying(value)),
              ),
            ),
            const EpisodeRefreshWidget(),
          ],
        );
      },
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          AppStrings.settingsLabel,
        ),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      child: Material(child: _buildList(context)),
    );
  }

  void _showStorageDialog({required bool enableExternalStorage}) {
    showPlatformDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (_) => BasicDialogAlert(
        title: const Text(AppStrings.settingsDownloadSwitchLabel),
        content: Text(
          enableExternalStorage
              ? AppStrings.settingsDownloadSwitchCard
              : AppStrings.settingsDownloadSwitchInternal,
        ),
        actions: <Widget>[
          BasicDialogAction(
            title: const Text(
              AppStrings.okButtonLabel,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _buildAndroid(context);
      case TargetPlatform.iOS:
        return _buildIos(context);
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return _buildAndroid(context);
    }
  }

  @override
  void initState() {
    super.initState();

    hasExternalStorage().then((value) {
      setState(() {
        sdcard = value;
      });
    });
  }
}

import 'package:decibel/domain/podcast/app_settings.dart';

abstract class SettingsService {
  AppSettings? get settings;

  set settings(AppSettings? settings);

  bool get themeDarkMode;

  set themeDarkMode(bool value);

  bool get markDeletedEpisodesAsPlayed;

  set markDeletedEpisodesAsPlayed(bool value);

  bool get storeDownloadsSDCard;

  set storeDownloadsSDCard(bool value);

  set playbackSpeed(double playbackSpeed);

  double get playbackSpeed;

  set autoOpenNowPlaying(bool autoOpenNowPlaying);

  bool get autoOpenNowPlaying;

  set autoUpdateEpisodePeriod(int period);

  int get autoUpdateEpisodePeriod;

  set trimSilence(bool trim);

  bool get trimSilence;

  set volumeBoost(bool boost);

  bool get volumeBoost;

  set layoutMode(int mode);

  int get layoutMode;

  Stream<String> get settingsListener;
}

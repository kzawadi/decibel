import 'package:decibel/domain/podcast/app_settings.dart';
import 'package:decibel/infrastructure/settings/settings_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An implementation [SettingsService] for mobile devices backed by
/// shared preferences.
class MobileSettingsService extends SettingsService {
  MobileSettingsService._create();
  static late SharedPreferences _sharedPreferences;
  static MobileSettingsService? _instance;

  final settingsNotifier = PublishSubject<String>();

  static Future<MobileSettingsService?> instance() async {
    if (_instance == null) {
      _instance = MobileSettingsService._create();

      _sharedPreferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  @override
  bool get markDeletedEpisodesAsPlayed =>
      _sharedPreferences.getBool('markplayedasdeleted') ?? false;

  @override
  set markDeletedEpisodesAsPlayed(bool value) {
    _sharedPreferences.setBool('markplayedasdeleted', value);
    settingsNotifier.sink.add('markplayedasdeleted');
  }

  @override
  bool get storeDownloadsSDCard =>
      _sharedPreferences.getBool('savesdcard') ?? false;

  @override
  set storeDownloadsSDCard(bool value) {
    _sharedPreferences.setBool('savesdcard', value);
    settingsNotifier.sink.add('savesdcard');
  }

  @override
  bool get themeDarkMode {
    final theme = _sharedPreferences.getString('theme') ?? 'dark';

    return theme == 'dark';
  }

  @override
  set themeDarkMode(bool value) {
    _sharedPreferences.setString('theme', value ? 'dark' : 'light');
    settingsNotifier.sink.add('theme');
  }

  @override
  set playbackSpeed(double playbackSpeed) {
    _sharedPreferences.setDouble('speed', playbackSpeed);
    settingsNotifier.sink.add('speed');
  }

  @override
  double get playbackSpeed {
    return _sharedPreferences.getDouble('speed') ?? 1.0;
  }

  @override
  set autoOpenNowPlaying(bool autoOpenNowPlaying) {
    _sharedPreferences.setBool('autoopennowplaying', autoOpenNowPlaying);
    settingsNotifier.sink.add('autoopennowplaying');
  }

  @override
  bool get autoOpenNowPlaying {
    return _sharedPreferences.getBool('autoopennowplaying') ?? false;
  }

  @override
  set autoUpdateEpisodePeriod(int period) {
    _sharedPreferences.setInt('autoUpdateEpisodePeriod', period);
    settingsNotifier.sink.add('autoUpdateEpisodePeriod');
  }

  @override
  int get autoUpdateEpisodePeriod {
    /// Default to 3 hours.
    return _sharedPreferences.getInt('autoUpdateEpisodePeriod') ?? 180;
  }

  @override
  set trimSilence(bool trim) {
    _sharedPreferences.setBool('trimSilence', trim);
    settingsNotifier.sink.add('trimSilence');
  }

  @override
  bool get trimSilence {
    return _sharedPreferences.getBool('trimSilence') ?? false;
  }

  @override
  set volumeBoost(bool boost) {
    _sharedPreferences.setBool('volumeBoost', boost);
    settingsNotifier.sink.add('volumeBoost');
  }

  @override
  bool get volumeBoost {
    return _sharedPreferences.getBool('volumeBoost') ?? false;
  }

  @override
  set layoutMode(int mode) {
    _sharedPreferences.setInt('layout', mode);
    settingsNotifier.sink.add('layout');
  }

  @override
  int get layoutMode {
    return _sharedPreferences.getInt('layout') ?? 0;
  }

  @override
  AppSettings? settings;

  @override
  Stream<String> get settingsListener => settingsNotifier.stream;
}

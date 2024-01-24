// ignore_for_file: must_be_immutable

import 'package:decibel/application/auth/auth_bloc.dart';
import 'package:decibel/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:decibel/application/auth/sign_up_form/sign_up_form_bloc.dart';
import 'package:decibel/application/bloc/audio_bloc.dart';
import 'package:decibel/application/bloc/discovery/discovery_bloc.dart';
import 'package:decibel/application/bloc/episode_bloc.dart';
import 'package:decibel/application/bloc/podcast_bloc.dart';
import 'package:decibel/application/data_collection/bloc/onboard_bloc.dart';
import 'package:decibel/application/settings/settings_bloc.dart';
import 'package:decibel/application/theme/pager_bloc.dart';
import 'package:decibel/domain/podcast/queue_bloc.dart';
import 'package:decibel/infrastructure/podcast/download/download_service.dart';
import 'package:decibel/infrastructure/podcast/download/mobile_download_manager.dart';
import 'package:decibel/infrastructure/podcast/download/mobile_download_service.dart';
import 'package:decibel/infrastructure/podcast/mobile_podcast_service.dart';
import 'package:decibel/infrastructure/podcast/podcast_service.dart';
import 'package:decibel/infrastructure/podcast/repository/repository.dart';
import 'package:decibel/infrastructure/podcast/repository/sembast/sembast_repository.dart';
import 'package:decibel/infrastructure/podcast/services/audio/audio_player_service.dart';
import 'package:decibel/infrastructure/podcast/services/audio/default_audio_player_service.dart';
import 'package:decibel/infrastructure/podcast/services/mobile_podcast_api.dart';
import 'package:decibel/infrastructure/podcast/services/podcast_api.dart';
import 'package:decibel/infrastructure/settings/mobile_settings_service.dart';
import 'package:decibel/injection.dart';
import 'package:decibel/l10n/l10n.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/core/themes.dart';
import 'package:decibel/presentation/routes/decibel_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class DecibelPodcast extends StatefulWidget {
  DecibelPodcast({
    required this.mobileSettingsService,
    super.key,
  }) : repository = SembastRepository() {
    podcastApi = MobilePodcastApi();

    downloadService = MobileDownloadService(
      repository: repository,
      downloadManager: MobileDownloaderManager(),
    );
    podcastService = MobilePodcastService(
      api: podcastApi,
      repository: repository,
      settingsService: mobileSettingsService,
    );

    audioPlayerService = DefaultAudioPlayerService(
      repository: repository,
      settingsService: mobileSettingsService,
      podcastService: podcastService,
    );

    settingsBloc = SettingsBloc(mobileSettingsService);
  }

  final MobileSettingsService mobileSettingsService;
  final Repository repository;
  late PodcastApi podcastApi;
  late DownloadService downloadService;
  PodcastService? podcastService;
  late AudioPlayerService audioPlayerService;
  SettingsBloc? settingsBloc;

  @override
  _DecibelPodcastState createState() => _DecibelPodcastState();
}

class _DecibelPodcastState extends State<DecibelPodcast> {
  ThemeData? theme;

  @override
  void initState() {
    super.initState();

    /// Listen to theme change events from settings.
    widget.settingsBloc!.settings.listen((event) {
      setState(() {
        final newTheme = event.theme == 'dark'
            ? Themes.darkTheme().themeData
            : Themes.lightTheme().themeData;

        /// Only update the theme if it has changed.
        if (newTheme != theme) {
          theme = newTheme;
        }
      });
    });

    if (widget.mobileSettingsService.themeDarkMode) {
      theme = Themes.darkTheme().themeData;
    } else {
      theme = Themes.lightTheme().themeData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DiscoveryBloc>(
          create: (_) => DiscoveryBloc(
            podcastService: widget.podcastService!,
          ),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<EpisodeBloc>(
          create: (_) => EpisodeBloc(
            podcastService: widget.podcastService!,
            audioPlayerService: widget.audioPlayerService,
          ),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<PodcastBloc>(
          create: (_) => PodcastBloc(
            podcastService: widget.podcastService!,
            audioPlayerService: widget.audioPlayerService,
            downloadService: widget.downloadService,
            settingsService: widget.mobileSettingsService,
          ),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<PagerBloc>(
          create: (_) => PagerBloc(),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<AudioBloc>(
          create: (_) =>
              AudioBloc(audioPlayerService: widget.audioPlayerService),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<SettingsBloc?>(
          create: (_) => widget.settingsBloc,
          dispose: (_, value) => value!.dispose(),
        ),
        Provider<QueueBloc>(
          create: (_) => QueueBloc(
            audioPlayerService: widget.audioPlayerService,
            podcastService: widget.podcastService!,
          ),
          dispose: (_, value) => value.dispose(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthEvent.authCheckRequested()),
        ),
        BlocProvider<OnboardBloc>(
          create: (context) =>
              getIt<OnboardBloc>()..add(const OnboardEvent.started()),
        ),
        BlocProvider<SignInFormBloc>(
          create: (context) => getIt<SignInFormBloc>(),
        ),
        BlocProvider<SignUpFormBloc>(
          create: (context) => getIt<SignUpFormBloc>(),
        ),
      ],
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarContrastEnforced: false,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
        child: MaterialApp.router(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routeInformationProvider: router.routeInformationProvider,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          builder: (context, router) => router!,
          theme: theme,
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:hydrated_bloc/hydrated_bloc.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

// Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
//   FlutterError.onError = (details) {
//     log(details.exceptionAsString(), stackTrace: details.stack);
//   };
//   // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light); // 1
//   // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.
//   //edgeToEdge,overlays: );

//   await runZonedGuarded(
//     () async {
//       WidgetsFlutterBinding.ensureInitialized();
//       // final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

//       // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

//       Bloc.observer = const AppBlocObserver();
//       Logger.root.level = Level.FINE;
//       Logger.root.onRecord.listen((record) {
//         print(
//           '${record.level.name}: - ${record.time}: ${record.loggerName}: ${record.message}',
//         );
//       });

//       Logger.root.onRecord.listen((record) {
//         print(
//           '${record.level.name}: - ${record.time}: ${record.loggerName}: ${record.message}',
//         );
//       });

//       configureDependencies();
//       await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform,
//       );

//       // HydratedBloc.storage = await HydratedStorage.build(
//       //   storageDirectory: kIsWeb
//       //       ? HydratedStorage.webStorageDirectory
//       //       : await getTemporaryDirectory(),
//       // );
//       final Repository repository;
//       PodcastApi podcastApi;
//       DownloadService downloadService;
//       PodcastService podcastService;
//       AudioPlayerService audioPlayerService;
//       SettingsBloc settingsBloc;
//       MobileSettingsService mobileSettingsService;
//       repository = SembastRepository();
//       mobileSettingsService = (await MobileSettingsService.instance())!;
//       podcastApi = MobilePodcastApi();
//       settingsBloc = SettingsBloc(mobileSettingsService);

//       downloadService = MobileDownloadService(
//         repository: repository,
//         downloadManager: MobileDownloaderManager(),
//       );

//       podcastService = MobilePodcastService(
//         api: podcastApi,
//         repository: repository,
//         settingsService: mobileSettingsService,
//       );

//       audioPlayerService = DefaultAudioPlayerService(
//         repository: repository,
//         settingsService: mobileSettingsService,
//         podcastService: podcastService,
//       );

//       await SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//       ]).then(
//         (value) async {
//           await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)
//               .then((value) {});
//           // return runApp(await builder());
//         },
//       );
//       runApp(
//         AnnotatedRegion<SystemUiOverlayStyle>(
//           value: const SystemUiOverlayStyle(
//             statusBarColor: Colors.transparent,
//             statusBarBrightness: Brightness.dark,
//             statusBarIconBrightness: Brightness.dark,
//             systemNavigationBarColor: Colors.transparent,
//             systemNavigationBarIconBrightness: Brightness.dark,
//             systemNavigationBarContrastEnforced: false,
//             systemNavigationBarDividerColor: Colors.transparent,
//           ),
//           child: MultiProvider(
//             providers: [
//               Provider<DiscoveryBloc>(
//                 create: (_) => DiscoveryBloc(
//                   podcastService: podcastService,
//                 ),
//                 dispose: (_, value) => value.dispose(),
//               ),
//               Provider<EpisodeBloc>(
//                 create: (_) => EpisodeBloc(
//                   podcastService: podcastService,
//                   audioPlayerService: audioPlayerService,
//                 ),
//                 dispose: (_, value) => value.dispose(),
//               ),
//               Provider<PodcastBloc>(
//                 create: (_) => PodcastBloc(
//                   podcastService: podcastService,
//                   audioPlayerService: audioPlayerService,
//                   downloadService: downloadService,
//                   settingsService: mobileSettingsService,
//                 ),
//                 dispose: (_, value) => value.dispose(),
//               ),
//               // Provider<PagerBloc>(
//               //   create: (_) => PagerBloc(),
//               //   dispose: (_, value) => value.dispose(),
//               // ),
//               Provider<AudioBloc>(
//                 create: (_) =>
//                     AudioBloc(audioPlayerService: audioPlayerService),
//                 dispose: (_, value) => value.dispose(),
//               ),
//               Provider<SettingsBloc>(
//                 create: (_) => settingsBloc,
//                 dispose: (_, value) => value.dispose(),
//               ),
//               Provider<QueueBloc>(
//                 create: (_) => QueueBloc(
//                   audioPlayerService: audioPlayerService,
//                   podcastService: podcastService,
//                 ),
//                 dispose: (_, value) => value.dispose(),
//               )
//             ],
//             child: await builder(),
//           ),
//         ),
//       );
//       FlutterNativeSplash.remove();
//     },
//     (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
//   );
// }

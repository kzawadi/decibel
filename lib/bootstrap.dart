// import 'dart:async';
// import 'dart:developer';

// import 'package:bloc/bloc.dart';
// import 'package:flutter/widgets.dart';

// class AppBlocObserver extends BlocObserver {
//   const AppBlocObserver();

//   @override
//   void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
//     super.onChange(bloc, change);
//     log('onChange(${bloc.runtimeType}, $change)');
//   }

//   @override
//   void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
//     log('onError(${bloc.runtimeType}, $error, $stackTrace)');
//     super.onError(bloc, error, stackTrace);
//   }
// }

// Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
//   FlutterError.onError = (details) {
//     log(details.exceptionAsString(), stackTrace: details.stack);
//   };

//   Bloc.observer = const AppBlocObserver();

//   // Add cross-flavor configuration here

//   runApp(await builder());
// }

import 'dart:async';
import 'dart:developer';

import 'package:decibel/injection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

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

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light); // 1
  // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.
  //edgeToEdge,overlays: );

  await runZonedGuarded(
    () async {
      // WidgetsFlutterBinding.ensureInitialized();
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      Bloc.observer = const AppBlocObserver();

      configureDependencies();
      await Firebase.initializeApp();

      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: kIsWeb
            ? HydratedStorage.webStorageDirectory
            : await getTemporaryDirectory(),
      );

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]).then(
        (value) async {
          await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)
              .then((value) {});
          // return runApp(await builder());
        },
      );
      runApp(
        AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarContrastEnforced: false,
            systemNavigationBarDividerColor: Colors.transparent,
          ),
          child: await builder(),
        ),
      );
      FlutterNativeSplash.remove();
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

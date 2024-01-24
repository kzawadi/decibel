import 'dart:async';
import 'dart:developer';

import 'package:decibel/bootstrap.dart';
import 'package:decibel/decibel_podcast.dart';
import 'package:decibel/firebase_options.dart';
import 'package:decibel/infrastructure/settings/mobile_settings_service.dart';
import 'package:decibel/injection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Bloc.observer = const AppBlocObserver();
    configureDependencies();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen((record) {
      print(
        '${record.level.name}: - ${record.time}: ${record.loggerName}: ${record.message}',
      );
    });

    final mobileSettingsService = (await MobileSettingsService.instance())!;

    runApp(
      DecibelPodcast(
        mobileSettingsService: mobileSettingsService,
      ),
    );
  }, (error, stack) {
    return log(error.toString(), stackTrace: stack);
  });
}

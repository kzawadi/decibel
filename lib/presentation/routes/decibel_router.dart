// GoRouter configuration
import 'package:decibel/presentation/routes/routes_observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:go_router/go_router.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

final router = GoRouter(
  observers: [
    GoRouterObserver(),
    AlignFirebaseAnalyticsObserver(),
  ],
  routes: [
    GoRoute(
      path: '/',
      // builder: (context, state) => const IntroPage(),
    ),
  ],
);

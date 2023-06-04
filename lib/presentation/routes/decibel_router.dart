// GoRouter configuration
import 'package:decibel/presentation/intro/intro_page.dart';
import 'package:decibel/presentation/login/login-page.dart';
import 'package:decibel/presentation/routes/routes_observer.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  observers: [
    GoRouterObserver(),
    AlignFirebaseAnalyticsObserver(),
  ],
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const IntroScreens(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
  ],
);

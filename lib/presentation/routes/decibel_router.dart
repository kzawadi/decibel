// GoRouter configuration
import 'package:decibel/decibel_home.dart';
import 'package:decibel/presentation/home/data_collection_page.dart';
import 'package:decibel/presentation/home/podcast_home/podcast_home.dart';
import 'package:decibel/presentation/intro/intro_page.dart';
import 'package:decibel/presentation/library/discovery.dart';
import 'package:decibel/presentation/login/forgot_password_page.dart';
import 'package:decibel/presentation/login/sign_in_page.dart';
import 'package:decibel/presentation/login/sign_in_view.dart';
import 'package:decibel/presentation/login/sign_up_page.dart';
import 'package:decibel/presentation/routes/routes_observer.dart';
import 'package:decibel/presentation/routes/unknown_route.dart';
import 'package:decibel/presentation/splash/intro_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  observers: [
    GoRouterObserver(),
    DecibelFirebaseAnalyticsObserver(),
  ],
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const IntroPage(),
    ),
    GoRoute(
      path: '/introScreen',
      builder: (context, state) => const IntroScreens(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signIn',
      builder: (context, state) => const SignInForm(),
    ),
    GoRoute(
      path: '/signUp',
      builder: (context, state) => const SigningUpPage(),
    ),
    GoRoute(
      path: '/forgotPassword',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/discovery',
      builder: (context, state) => const Discovery(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const DecibelHome(),
    ),
    GoRoute(
      path: '/dataCollection',
      builder: (context, state) => const DataCollectionPage(),
    ),
    GoRoute(
      path: '/unknownRoute',
      builder: (context, state) => const UnknownRoute(),
    ),
    GoRoute(
      path: '/PodcastHome',
      builder: (context, state) => const PodcastHome(),
    ),
  ],
);

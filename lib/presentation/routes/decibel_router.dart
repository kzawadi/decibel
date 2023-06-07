// GoRouter configuration
import 'package:decibel/presentation/intro/intro_page.dart';
import 'package:decibel/presentation/login/forgot_password_page.dart';
import 'package:decibel/presentation/login/sign_in_view.dart';
import 'package:decibel/presentation/login/sign_up_page.dart';
import 'package:decibel/presentation/routes/routes_observer.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  observers: [
    GoRouterObserver(),
    DecibelFirebaseAnalyticsObserver(),
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
    GoRoute(
      path: '/signIn',
      builder: (context, state) => const SignInForm(),
    ),
    GoRoute(
      path: '/forgotPassword',
      builder: (context, state) => const ForgotPasswordPage(),
    )
  ],
);

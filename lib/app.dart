import 'package:decibel/application/auth/auth_bloc.dart';
import 'package:decibel/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:decibel/application/auth/sign_up_form/sign_up_form_bloc.dart';
import 'package:decibel/application/data_collection/bloc/onboard_bloc.dart';
import 'package:decibel/application/theme/theme_cubit.dart';
import 'package:decibel/injection.dart';
import 'package:decibel/l10n/l10n.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/routes/decibel_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// The root widget of the Decibel application.
///
/// The [DecibelApp] class is the root widget of the Decibel application.
/// It is a [StatelessWidget] that provides the necessary [BlocProvider]s for the application's blocs
/// and configures the [MaterialApp] with the appropriate theme and routing.
class DecibelApp extends StatelessWidget {
  /// Creates an instance of [DecibelApp].
  const DecibelApp({super.key});

  /// Builds the widget hierarchy for the Decibel application.
  ///
  /// This method returns a [MultiBlocProvider] widget that wraps the entire application.
  /// It provides the necessary [BlocProvider]s for the theme, authentication, onboarding,
  /// sign-in form, and sign-up form blocs.
  ///
  /// The [MaterialApp.router] widget is used as the root widget, which enables routing in the application.
  /// It uses the [router] instance to handle routing configurations.
  ///
  /// The theme, dark theme, and theme mode are configured based on the current state of the [ThemeCubit],
  /// which is obtained using [context.watch<ThemeCubit>()].
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => getIt<ThemeCubit>(),
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
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) => MaterialApp.router(
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
          theme: context.watch<ThemeCubit>().lightTheme,
          darkTheme: context.watch<ThemeCubit>().darkTheme,
          themeMode: context.watch<ThemeCubit>().themeMode,
        ),
      ),
    );
  }
}

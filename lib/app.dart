import 'package:decibel/application/auth/auth_bloc.dart';
import 'package:decibel/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:decibel/application/theme/theme_cubit.dart';
import 'package:decibel/injection.dart';
import 'package:decibel/l10n/l10n.dart';
import 'package:decibel/presentation/routes/decibel_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class DecibelApp extends StatelessWidget {
  const DecibelApp({super.key});

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
        BlocProvider<SignInFormBloc>(
          create: (context) => getIt<SignInFormBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) => MaterialApp.router(
          title: 'Decibel',
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

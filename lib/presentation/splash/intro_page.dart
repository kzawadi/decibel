import 'package:decibel/application/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.map(
          initial: (_) {},
          authenticated: (_) {
            // getIt<OnboardBloc>().add(const OnboardEvent.started());

            context.replace('/home');
          },
          unauthenticated: (_) => context.replace('/introScreen'),
          unAuthenticatingFailure: (UnAuthenticatingFailure value) =>
              context.replace('/unknownRoute'),
          notOnboarded: (_) => context.replace('/dataCollection'),
        );
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}

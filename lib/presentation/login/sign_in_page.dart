import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:decibel/application/auth/auth_bloc.dart';
import 'package:decibel/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:decibel/presentation/core/app_button.dart';
import 'package:decibel/presentation/core/app_sizes.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/core/assets_constants.dart';
import 'package:decibel/presentation/core/google_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ///we do provide our bloc here [SignInFormBloc] so we can use on
    ///the descendants  of the
    return BlocListener<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (failure) {
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'On Snap!',
                  message: failure.map(
                    cancelledByUser: (_) => AppStrings.loginCancelled,
                    serverError: (_) => AppStrings.serverError,
                    emailAlreadyInUse: (_) => AppStrings.emailAlreadyInUse,
                    invalidEmailAndPasswordCombination: (_) =>
                        AppStrings.invalidEmailAndPassword,
                  ),
                  contentType: ContentType.failure,
                ),
              );
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
            },
            (_) {
              context
                  .read<AuthBloc>()
                  .add(const AuthEvent.authCheckRequested());
              context.replace('/');
            },
          ),
        );
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(
              AppSizes.DEFAULT_PADDING,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /* <---- HeadLine ----> */
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Discover your \n favourite podcast',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),

                /* <---- Hero Image ----> */
                Expanded(
                  child: Image.asset(
                    AssetsConstants.login,
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                ),

                /* <---- Login ----> */
                Column(
                  children: [
                    AppButton(
                      width: MediaQuery.of(context).size.width * 0.6,
                      label: 'Login With Email',
                      onTap: () {
                        context.go('/signIn');
                      },
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    AppSizes.hGap20,
                    GoogleSignInButton(
                      width: MediaQuery.of(context).size.width * 0.6,
                      onTap: () {
                        context.read<SignInFormBloc>().add(
                              const SignInFormEvent.signInWithGooglePressed(),
                            );
                      },
                    ),
                    // AppSizes.hGap30,
                  ],
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don’t have an account?'),
                      TextButton(
                        onPressed: () => context.go('/signUp'),
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:decibel/application/auth/auth_bloc.dart';
import 'package:decibel/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:decibel/injection.dart';
import 'package:decibel/presentation/core/app_button.dart';
import 'package:decibel/presentation/core/app_sizes.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/core/assets_constants.dart';
import 'package:decibel/presentation/login/widget/email_and_password_widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

// its best practice to do relative imports

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  SignInFormsState createState() => SignInFormsState();
}

class SignInFormsState extends State<SignInForm> {
  final _loginKey = GlobalKey<FormState>();

  final List<FocusNode> _singInFocusNodes = [
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    super.initState();
    for (final element in _singInFocusNodes) {
      element.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      bloc: getIt<SignInFormBloc>(),
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (failure) {
              final snackBar = SnackBar(
                // backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                content: Text(
                  failure.map(
                    cancelledByUser: (_) => AppStrings.loginCancelled,
                    serverError: (_) => AppStrings.serverError,
                    emailAlreadyInUse: (_) => AppStrings.emailAlreadyInUse,
                    invalidEmailAndPasswordCombination: (_) =>
                        AppStrings.invalidEmailAndPassword,
                  ),
                ),
                action: SnackBarAction(
                  label: AppStrings.ok,
                  onPressed: () {},
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
      builder: (context, state) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(28, 20, 30, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.welcomeText01,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    AppStrings.welcomeText02,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                            Flexible(
                              child: SvgPicture.asset(
                                AssetsConstants.logo,
                                width: 35,
                                height: 35,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    AppStrings.loginWithEmail,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: SignInFormWidget(
                                      loginKey: _loginKey,
                                      singInFocusNodes: _singInFocusNodes,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  GestureDetector(
                                    onTap: () => context.go('/forgotPassword'),
                                    child: Text(
                                      AppStrings.forgotPassword,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                    ),
                                  ),
                                  AppSizes.hGap40,
                                  Flexible(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 65,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            AppStrings.dontHaveAccount,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          AppButton(
                                            label: AppStrings.signUp,
                                            onTap: () =>
                                                context.go('/SignUpPage'),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:decibel/application/auth/auth_bloc.dart';
import 'package:decibel/application/auth/sign_up_form/sign_up_form_bloc.dart';
import 'package:decibel/presentation/core/app_button.dart';
import 'package:decibel/presentation/core/app_sizes.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/core/google_sign_in_button.dart';
import 'package:decibel/presentation/login/widget/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

class SigningUpPage extends StatefulWidget {
  const SigningUpPage({super.key});

  @override
  SigningUpPageState createState() => SigningUpPageState();
}

class SigningUpPageState extends State<SigningUpPage> {
  final _signUpKey = GlobalKey<FormState>();

  final List<FocusNode> _signUpFocusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    super.initState();
    for (final element in _signUpFocusNodes) {
      element.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpFormBloc, SignUpFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (failure) {
              final snackBar = SnackBar(
                /// need to set following properties for best effect of awesome_snackbar_content
                elevation: 0,
                behavior: SnackBarBehavior.floating,

                backgroundColor: Theme.of(context).colorScheme.error,

                content: AwesomeSnackbarContent(
                  title: 'On Snap!',
                  color: Theme.of(context).colorScheme.error,
                  message: failure.map(
                    cancelledByUser: (_) => AppStrings.loginCancelled,
                    serverError: (_) => AppStrings.serverError,
                    emailAlreadyInUse: (_) => AppStrings.emailAlreadyInUse,
                    invalidEmailAndPasswordCombination: (_) =>
                        AppStrings.invalidEmailAndPassword,
                  ),

                  /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
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
      builder: (context, state) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppSizes.hGap40,
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(28, 20, 30, 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppStrings.welcomeText01,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
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
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            AppSizes.hGap15,
                            Text(
                              AppStrings.createAccountInstructions,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          autovalidateMode: state.showErrorMessages
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,
                          key: _signUpKey,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'First Name',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                        border:
                                            OutlineInputBorder(gapPadding: 5),
                                        alignLabelWithHint: true,
                                        contentPadding: EdgeInsets.all(8),
                                        prefixIcon: Icon(
                                          Ionicons.person_outline,
                                          size: 17,
                                        ),
                                      ),
                                      focusNode: _signUpFocusNodes[0],
                                      validator: nameValidator.call,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Last Name',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                        border:
                                            OutlineInputBorder(gapPadding: 5),
                                        alignLabelWithHint: true,
                                        contentPadding: EdgeInsets.all(8),
                                        prefixIcon: Icon(
                                          Ionicons.person_outline,
                                          size: 17,
                                        ),
                                      ),
                                      focusNode: _signUpFocusNodes[1],
                                      validator: nameValidator.call,
                                    ),
                                  ],
                                ),
                              ),
                              // Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Text(
                              //       'Phone Number',
                              //       style:
                              //           Theme.of(context).textTheme.labelLarge,
                              //     ),
                              //     SizedBox(
                              //       height: 150,
                              //       width: double.infinity,
                              //       child: Card(
                              //         elevation: 0,
                              //         child: Column(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.center,
                              //           children: [
                              //             const Flexible(
                              //               child: CountryCodeDropdown(),
                              //             ),
                              //             Flexible(
                              //               // flex: 2,
                              //               child: TextFormField(
                              //                 keyboardType:
                              //                     TextInputType.emailAddress,
                              //                 decoration: const InputDecoration(
                              //                   border: OutlineInputBorder(
                              //                     gapPadding: 5,
                              //                   ),
                              //                   alignLabelWithHint: true,
                              //                   contentPadding:
                              //                       EdgeInsets.all(8),
                              //                   prefixIcon: Icon(
                              //                     Ionicons
                              //                         .phone_portrait_outline,
                              //                     size: 17,
                              //                   ),
                              //                 ),
                              //                 focusNode: _signUpFocusNodes[2],
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'E-mail',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        border:
                                            OutlineInputBorder(gapPadding: 5),
                                        alignLabelWithHint: true,
                                        contentPadding: EdgeInsets.all(8),
                                        prefixIcon: Icon(
                                          Ionicons.mail_outline,
                                          size: 17,
                                        ),
                                      ),
                                      focusNode: _signUpFocusNodes[3],
                                      onChanged: (value) =>
                                          context.read<SignUpFormBloc>().add(
                                                SignUpFormEvent.emailChanged(
                                                  value,
                                                ),
                                              ),
                                      validator: (_) => context
                                          .read<SignUpFormBloc>()
                                          .state
                                          .emailAddress
                                          .value
                                          .fold(
                                            (f) => f.maybeMap(
                                              invalidEmail: (_) =>
                                                  'Invalid Email',
                                              orElse: () => null,
                                            ),
                                            (_) => null,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Password',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        border:
                                            OutlineInputBorder(gapPadding: 5),
                                        alignLabelWithHint: true,
                                        contentPadding: EdgeInsets.all(8),
                                        prefixIcon: Icon(
                                          Ionicons.key_outline,
                                          size: 17,
                                        ),
                                      ),
                                      focusNode: _signUpFocusNodes[4],
                                      onChanged: (value) =>
                                          context.read<SignUpFormBloc>().add(
                                                SignUpFormEvent.passwordChanged(
                                                  value,
                                                ),
                                              ),
                                      validator: (_) => context
                                          .read<SignUpFormBloc>()
                                          .state
                                          .password
                                          .value
                                          .fold(
                                            (f) => f.maybeMap(
                                              shortPassword: (_) =>
                                                  'Short Password',
                                              orElse: () => null,
                                            ),
                                            (_) => null,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Checkbox(
                                        value: true,
                                        onChanged: (v) {},
                                      ),
                                    ),
                                    Flexible(
                                      flex: 4,
                                      child: Text(
                                        AppStrings.termsAndConditions,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AppButton(
                                // buttonName: 'Create',
                                onTap: () {
                                  context.read<SignUpFormBloc>().add(
                                        const SignUpFormEvent
                                            .registerWithEmailAndPasswordPressed(),
                                      );
                                },

                                label: 'create',
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Text(
                              AppStrings.alternateSignUptText,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GoogleSignInButton(
                              onTap: () => context.read<SignUpFormBloc>().add(
                                    const SignUpFormEvent
                                        .signInWithGooglePressed(),
                                  ),
                            ),
                          ),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already Have An Account? ',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                TextButton(
                                  onPressed: () => context.go('/login'),
                                  child: const Text(
                                    AppStrings.loginLabel,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
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

import 'package:decibel/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:decibel/presentation/core/app_button.dart';
import 'package:decibel/presentation/core/app_sizes.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

class SignInFormWidget extends StatelessWidget {
  const SignInFormWidget({
    required GlobalKey<FormState> loginKey,
    required List<FocusNode> singInFocusNodes,
    // required SignInFormState state,
    super.key,
  })  : _loginKey = loginKey,
        _singInFocusNodes = singInFocusNodes;
  // _state = state;

  final GlobalKey<FormState> _loginKey;
  final List<FocusNode> _singInFocusNodes;
  // final SignInFormState _state;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInFormBloc, SignInFormState>(
      builder: (context, state) {
        return Form(
          autovalidateMode: state.showErrorMessages
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          key: _loginKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.emailHint,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(gapPadding: 8),
                        alignLabelWithHint: true,
                        contentPadding: EdgeInsets.all(16),
                        prefixIcon: Icon(Ionicons.mail_outline),
                      ),
                      focusNode: _singInFocusNodes[0],
                      onChanged: (value) => context
                          .read<SignInFormBloc>()
                          .add(SignInFormEvent.emailChanged(value)),
                      validator: (_) => context
                          .read<SignInFormBloc>()
                          .state
                          .emailAddress
                          .value
                          .fold(
                            (f) => f.maybeMap(
                              invalidEmail: (_) => AppStrings.invalidEmailText,
                              orElse: () => AppStrings.emailFormatingerror,
                            ),
                            (_) => null,
                          ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(AppStrings.passwordHint),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(gapPadding: 8),
                        alignLabelWithHint: true,
                        contentPadding: const EdgeInsets.all(16),
                        prefixIcon: const Icon(Ionicons.key_outline),
                        suffixIcon: GestureDetector(
                          onTap: () => context
                              .read<SignInFormBloc>()
                              .add(const SignInFormEvent.showPassword()),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ),
                            child: Icon(
                              !state.showPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: !state.showPassword
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).disabledColor,
                            ),
                          ),
                        ),
                      ),
                      obscureText: state.showPassword,
                      focusNode: _singInFocusNodes[1],
                      onChanged: (value) => context.read<SignInFormBloc>().add(
                            SignInFormEvent.passwordChanged(
                              value,
                            ),
                          ),
                      validator: (_) => context
                          .read<SignInFormBloc>()
                          .state
                          .password
                          .value
                          .fold(
                            (f) => f.maybeMap(
                              shortPassword: (_) =>
                                  AppStrings.invalidPasswordText,
                              orElse: () => null,
                            ),
                            (_) => null,
                          ),
                    ),
                  ],
                ),
              ),
              AppSizes.hGap30,
              AppButton(
                width: MediaQuery.of(context).size.width * 0.6,
                label: AppStrings.loginWithEmail,
                onTap: () {
                  context.read<SignInFormBloc>().add(
                        const SignInFormEvent
                            .signInWithEmailAndPasswordPressed(),
                      );
                },
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ],
          ),
        );
      },
    );
  }
}

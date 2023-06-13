import 'package:decibel/presentation/core/app_button.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/login/widget/validators.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _forgotPassKey = GlobalKey<FormState>();

  void _onSumbit() {
    _forgotPassKey.currentState!.validate();
  }

  FocusNode focusNode1 = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode1.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: CircleAvatar(
            child: IconButton(
              icon: const Icon(
                Ionicons.chevron_back_outline,
              ),
              onPressed: () => context.go('/signIn'),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
                      child: Text(
                        AppStrings.forgotPasswordTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                        // style: kTitle2,
                      ),
                    ),
                  ),

                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Form(
                        key: _forgotPassKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              AppStrings.passwordResetInstructions,
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(gapPadding: 8),
                                  alignLabelWithHint: true,
                                  contentPadding: EdgeInsets.all(16),
                                  hintText: AppStrings.emailHint,
                                ),
                                focusNode: focusNode1,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                validator: emailValidator.call,
                              ),
                            ),
                            AppButton(
                              label: AppStrings.resetLabel,
                              onTap: _onSumbit,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              AppStrings.rememberPassword,
                            ),
                            TextButton(
                              onPressed: () => context.go('/SignIn'),
                              child: const Text(AppStrings.loginLabel),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

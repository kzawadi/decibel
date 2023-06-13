import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:decibel/application/data_collection/data_collection_bloc.dart';
import 'package:decibel/presentation/core/app_button.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/core/interests_widget.dart';
// import 'package:decibel/presentation/core/app_styles.dart';
// import 'package:decibel/presentation/sign_in/widgets/buttons/large_icon_button.dart';
// import 'package:decibel/presentation/sign_in/widgets/buttons/my_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocConsumer<DataCollectionBloc, DataCollectionState>(
            listener: (context, state) {
              // Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
              state.isLoading
                  ? ScaffoldMessenger.of(context).showSnackBar(snackBar)
                  : const SizedBox.shrink();
              state.dataFailureorSucces.fold(
                () => null,
                (t) => t.fold(
                  (l) => ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: AwesomeSnackbarContent(
                          title: 'ops',
                          message: l.maybeMap(
                            general: (_) => 'General Failure',
                            failedToSetData: (_) => 'failed to SetData',
                            orElse: () => 'failure',
                          ),
                          contentType: ContentType.success,
                        ),
                      ),
                    ),
                  (r) => context.go('/home'),
                ),
              );
            },
            builder: (context, state) {
              return Column(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, top: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppStrings.onboardingPage02HelperTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              AppStrings.onboardingPage02HelperText,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Flexible(
                    flex: 3,
                    child: InterestSelectScreen(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: SizedBox(
                      height: 75,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Hero(
                        tag: 'next',
                        child: AppButton(
                          label: AppStrings.nextLabel,
                          labelTextColor:
                              Theme.of(context).colorScheme.onPrimary,
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();

                            context.read<DataCollectionBloc>().add(
                                  const DataCollectionEvent.submit(),
                                );
                            // _pageController.animateToPage(
                            //   1,
                            //   curve: Curves.easeIn,
                            //   duration: const Duration(microseconds: 250),
                            // );
                            // context.read<SignInFormBloc>().add(
                            //     const SignInFormEvent.signInWithEmailAndPasswordPressed(),
                            //   );
                          },
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

const snackBar = SnackBar(
  margin: EdgeInsets.only(left: 50, right: 50, top: 8, bottom: 8),
  padding: EdgeInsets.all(16),
  content: LinearProgressIndicator(),
  // Row(
  //   children: [Text('Wait a bit!'), CircularProgressIndicator.adaptive()],
  // ),
);

import 'package:decibel/application/data_collection/data_collection_bloc.dart';
import 'package:decibel/presentation/core/app_button.dart';
import 'package:decibel/presentation/core/app_strings.dart';
// import 'package:decibel/presentation/sign_in/widgets/buttons/large_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PageOne extends HookWidget {
  const PageOne(this._pageController, {super.key});

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    final nameTextEditingController = useTextEditingController();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<DataCollectionBloc, DataCollectionState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.onboardingPage01HelperTitle,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500,
                                    // decoration: TextDecoration.underline,
                                  ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            AppStrings.onboardingPage01HelperText,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                        ),
                        CupertinoTextField.borderless(
                          padding: const EdgeInsets.all(12),
                          controller: nameTextEditingController,

                          // padding: EdgeInsets.only(left: 65, top: 10, right: 6, bottom: 10),
                          prefix: Text(
                            AppStrings.userNameLabel,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          placeholder: state.userName,
                          style: Theme.of(context).textTheme.titleLarge,
                          onChanged: (value) =>
                              context.read<DataCollectionBloc>().add(
                                    DataCollectionEvent.setName(
                                      nameTextEditingController.text,
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50),
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
                                    DataCollectionEvent.setName(
                                      nameTextEditingController.text,
                                    ),
                                  );
                              _pageController.animateToPage(
                                1,
                                curve: Curves.easeIn,
                                duration: const Duration(microseconds: 250),
                              );
                            },
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:decibel/application/data_collection/data_collection_bloc.dart';
import 'package:decibel/injection.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/core/rounded_app_bar.dart';
import 'package:decibel/presentation/home/data_collection_pages/data_collection_page_01.dart';
import 'package:decibel/presentation/home/data_collection_pages/data_collection_page_02.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DataCollectionPage extends HookWidget {
  const DataCollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    return Scaffold(
      appBar: const RoundedAppBar(title: Text(AppStrings.appName)),
      body: SafeArea(
        child: Stack(
          children: [
            BlocProvider<DataCollectionBloc>(
              create: (context) => getIt<DataCollectionBloc>(),
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                children: [
                  PageOne(pageController),
                  const PageTwo(),
                  // const PageThree()
                ],
              ),
            ),
            Positioned.fill(
              child: Align(
                heightFactor: 20,
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SmoothPageIndicator(
                    controller: pageController, // PageController
                    count: 2,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Theme.of(context).primaryColor,
                      dotHeight: 10,
                      dotWidth: 10,
                      radius: 8,
                    ), // your preferred effect
                    onDotClicked: (index) {},
                    // effect: const SlideEffect(
                    //   radius: 10,
                    //   dotWidth: 10,
                    //   dotHeight: 10,
                    //   spacing: 10,
                    //   strokeWidth: 1.5,
                    // ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GradientWidget extends StatelessWidget {
  const GradientWidget({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.amber[900]!,
            Colors.amber[700]!,
            Colors.amber[500]!,
          ],
        ),
      ),
      child: child,
    );
  }
}

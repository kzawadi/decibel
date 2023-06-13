import 'package:decibel/presentation/core/app_defaults.dart';
import 'package:decibel/presentation/core/app_sizes.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/core/assets_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreens extends StatefulWidget {
  const IntroScreens({super.key});

  @override
  _IntroScreensState createState() => _IntroScreensState();
}

class _IntroScreensState extends State<IntroScreens> {
  // Add or remove intro from here
  final List<Intro> _allIntros = [
    Intro(
      title: AppStrings.introTitle_00,
      imageLocation: AssetsConstants.discussion,
      description: AppStrings.intoText_00,
    ),
    Intro(
      title: AppStrings.introTitle_01,
      imageLocation: AssetsConstants.people,
      description: AppStrings.intoText_01,
    ),
    Intro(
      title: AppStrings.introTitle_02,
      imageLocation: AssetsConstants.play,
      description: AppStrings.intoText_02,
    ),
  ];

  /// Page Controller
  late PageController _pageController;

  /// Tracks currently active page
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(AppSizes.DEFAULT_PADDING),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* <---- Images And Title ----> */
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _allIntros.length,
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            _allIntros[index].imageLocation,
                            colorBlendMode: BlendMode.overlay,
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height / 2.4,
                          ),
                          Text(
                            _allIntros[index].title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          AppSizes.hGap10,
                          Text(
                            _allIntros[index].description,
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /* <---- Intro Dots ----> */

              SmoothPageIndicator(
                controller: _pageController, // PageController
                count: 3,
                effect: ExpandingDotsEffect(
                  activeDotColor: Theme.of(context).primaryColor,
                  dotHeight: 10,
                  dotWidth: 10,
                  radius: 8,
                ), // your preferred effect
                onDotClicked: (index) {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: const Text('SKIP'),
                  ),
                  InkWell(
                    borderRadius: AppDefaults.defaulBorderRadius,
                    onTap: () {
                      if (_currentPage == _allIntros.length - 1) {
                        // Get.to(LoginScreen);
                        context.go('/login');
                      } else {
                        _pageController.animateToPage(
                          _currentPage + 1,
                          duration: AppDefaults.defaultDuration,
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      //todo(kzawadi): look at any way to make this cool and not spoky
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Ionicons.arrow_forward_outline,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroDots extends StatelessWidget {
  const _IntroDots({
    required this.active,
  });

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDefaults.defaultDuration,
      width: 15,
      height: 15,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: active
            ? Theme.of(context).primaryColor
            : Theme.of(context).secondaryHeaderColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

class Intro {
  Intro({
    required this.title,
    required this.imageLocation,
    required this.description,
  });
  String title;
  String imageLocation;
  String description;
}

import 'package:decibel/presentation/core/app_button.dart';
import 'package:decibel/presentation/core/app_sizes.dart';
import 'package:decibel/presentation/core/assets_constants.dart';
import 'package:decibel/presentation/core/google_sign_in_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // width: Get.width,
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
                  AssetsConstants.people,
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
                      // Get.to(() => InterestSelectScreen());
                    },
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  AppSizes.hGap20,
                  GoogleSignInButton(
                    width: MediaQuery.of(context).size.width * 0.6,
                    onTap: () {
                      // Get.to(() => InterestSelectScreen());
                    },
                  ),
                  AppSizes.hGap30,
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don’t have an account?'),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Sign Up'),
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

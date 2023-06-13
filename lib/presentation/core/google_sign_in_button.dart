/* <---- !!!!!!

  Important Place downloaded google logo in assets

 ----> */

import 'package:decibel/presentation/core/app_defaults.dart';
import 'package:decibel/presentation/core/app_sizes.dart';
import 'package:decibel/presentation/core/assets_constants.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    required this.onTap,
    super.key,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.label,
  });

  final void Function() onTap;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Container(
        // margin: margin ?? const EdgeInsets.symmetric(vertical: 5),
        padding: padding ?? const EdgeInsets.all(10),
        height: height ?? MediaQuery.of(context).size.height * 0.07,
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: AppDefaults.defaulBorderRadius,
          // border: Border.all(
          //   color: const Color(0xFF4285F4),
          // ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: ClipRRect(
                borderRadius: AppDefaults.defaulBorderRadius,
                child: Container(
                  // color: Theme.of(context).canvasColor,
                  padding: const EdgeInsets.all(5),
                  child: Image.asset(
                    AssetsConstants.googleLogo,
                  ),
                ),
              ),
            ),
            AppSizes.wGap15,
            Flexible(
              flex: 4,
              child: Text(
                label ?? 'Login with Google',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

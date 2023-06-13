import 'package:decibel/presentation/core/app_sizes.dart';
import 'package:flutter/material.dart';

class AppDefaults {
  /// Used For Border Radius
  static BorderRadius defaulBorderRadius =
      BorderRadius.circular(AppSizes.DEFAULT_RADIUS);

  /// Used For Bottom Sheet
  static BorderRadius defaultBottomSheetRadius = const BorderRadius.only(
    topLeft: Radius.circular(AppSizes.DEFAULT_RADIUS),
    topRight: Radius.circular(AppSizes.DEFAULT_RADIUS),
  );

  /// Used For Top Sheet
  static BorderRadius defaultTopSheetRadius = const BorderRadius.only(
    bottomLeft: Radius.circular(AppSizes.DEFAULT_RADIUS),
    bottomRight: Radius.circular(AppSizes.DEFAULT_RADIUS),
  );

  /// Default Box Shadow used for containers
  static List<BoxShadow> defaultBoxShadow = [
    BoxShadow(
      blurRadius: 25,
      offset: const Offset(0, 2),
      color: Colors.black.withOpacity(0.08),
    ),
  ];

  /// Default Animation Duration used for the entire app
  static Duration defaultDuration = const Duration(milliseconds: 300);
}

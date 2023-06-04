import 'package:decibel/application/theme/colors.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Class that contains all the different styles of an app
class Style {
  /// Light style
  static final ThemeData light = FlexThemeData.light(
    scheme: FlexScheme.tealM3,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 20,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    swapLegacyOnMaterial3: true,
    subThemesData: const FlexSubThemesData(
      useM2StyleDividerInM3: true,
      defaultRadius: 8,
      inputDecoratorRadius: 15,
      inputDecoratorUnfocusedBorderIsColored: false,
    ),
    keyColors: const FlexKeyColors(),
    useMaterial3: true,
    useMaterial3ErrorColors: true,
    textTheme: GoogleFonts.interTextTheme(),
    fontFamily: GoogleFonts.inter().fontFamily,
  );

  /// Dark style
  static final ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.tealM3,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 20,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    swapLegacyOnMaterial3: true,
    keyColors: const FlexKeyColors(),
    subThemesData: const FlexSubThemesData(
      defaultRadius: 8,
      inputDecoratorRadius: 15,
      inputDecoratorUnfocusedBorderIsColored: false,
    ),
    useMaterial3: true,
    useMaterial3ErrorColors: true,
    textTheme: GoogleFonts.interTextTheme(),
    fontFamily: GoogleFonts.inter().fontFamily,
  );

  /// Black style (OLED)
  static final ThemeData black = FlexColorScheme.dark(
    scheme: FlexScheme.blueWhale,
    useMaterial3: true,
    textTheme: GoogleFonts.interTextTheme(),
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: lightPrimaryColor,
      // background: alternateBackground,
      // secondary: primaryInputBoxColor,
    ),
  ).toTheme;
}

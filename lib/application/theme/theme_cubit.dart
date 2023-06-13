import 'package:decibel/application/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

enum ThemeState { light, dark, black, system }

final Map<ThemeState, ThemeData> _themeData = {
  ThemeState.light: Style.light,
  ThemeState.dark: Style.dark,
  ThemeState.black: Style.black,
};

@injectable

/// Manages the theme state of the application.
///
/// The [ThemeCubit] class is responsible for managing the theme state of the application.
/// It extends [HydratedCubit] from the hydrated_bloc package, which allows for state persistence.
///
/// The theme state can be one of the following values: light, dark, black, or system.
///
/// Example usage:
/// ```dart
/// ThemeCubit themeCubit = ThemeCubit();
/// ```
class ThemeCubit extends HydratedCubit<ThemeState> {
  /// Creates an instance of [ThemeCubit] with the default theme.
  ///
  /// The default theme is set to [ThemeState.light].
  ThemeCubit() : super(defaultTheme);

  /// The default theme state.
  ///
  /// This constant represents the default theme state for the application, which is [ThemeState.light].
  static const defaultTheme = ThemeState.light;

  /// Converts the JSON representation of the state to a [ThemeState] enum value.
  ///
  /// This method is called by the hydrated_bloc library when restoring the state from JSON.
  @override
  ThemeState fromJson(Map<String, dynamic> json) {
    return ThemeState.values[json['value'] as int];
  }

  /// Converts the [ThemeState] enum value to its JSON representation.
  ///
  /// This method is called by the hydrated_bloc library when persisting the state to JSON.
  @override
  Map<String, int> toJson(ThemeState state) {
    return {
      'value': state.index,
    };
  }

  /// Returns the current theme state.
  ThemeState get theme => state;

  /// Sets the theme state to the specified value.
  ///
  /// This method updates the theme state and emits the new state.
  set theme(ThemeState themeState) => emit(themeState);

  /// Returns the [ThemeMode] based on the current theme state.
  ///
  /// This method maps the theme state to the corresponding [ThemeMode].
  ThemeMode get themeMode {
    switch (state) {
      case ThemeState.light:
        return ThemeMode.light;
      case ThemeState.dark:
      case ThemeState.black:
        return ThemeMode.dark;
      case ThemeState.system:
        return ThemeMode.system;
    }
  }

  /// Returns the light theme data.
  ThemeData? get lightTheme => _themeData[ThemeState.light];

  /// Returns the dark theme data.
  ///
  /// If the current theme state is [ThemeState.black], the black theme data is returned.
  /// Otherwise, the dark theme data is returned.
  ThemeData? get darkTheme => state == ThemeState.black
      ? _themeData[ThemeState.black]
      : _themeData[ThemeState.dark];
}

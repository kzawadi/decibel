import 'package:flutter/material.dart';

class PlaceholderBuilder extends InheritedWidget {
  const PlaceholderBuilder({
    required this.builder,
    required this.errorBuilder,
    required super.child,
    super.key,
  });
  final WidgetBuilder Function() builder;
  final WidgetBuilder Function() errorBuilder;

  static PlaceholderBuilder? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PlaceholderBuilder>();
  }

  @override
  bool updateShouldNotify(PlaceholderBuilder oldWidget) {
    return builder != oldWidget.builder ||
        errorBuilder != oldWidget.errorBuilder;
  }
}

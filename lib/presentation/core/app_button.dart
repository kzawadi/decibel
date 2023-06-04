import 'package:decibel/presentation/core/app_defaults.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onTap,
    required this.color,
    super.key,
    this.isLoading = false,
    this.width,
    this.margin,
    this.padding,
  });

  final String label;
  final void Function() onTap;
  final bool isLoading;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: AnimatedContainer(
        duration: AppDefaults.defaultDuration,
        // margin: margin ?? const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: AppDefaults.defaulBorderRadius,
        ),
        width: width,
        child: isLoading
            ? CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              )
            : Text(
                label,
                style: Theme.of(context).textTheme.labelLarge,
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Decibel ',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}

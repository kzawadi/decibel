// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.label,
    required this.title,
    required this.icon,
    required this.percent,
    required this.onPressed,
  });
  final String label;
  final String title;
  final IconData icon;
  final int percent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final progress = percent.toDouble() / 100;

    return Semantics(
      label: '$label $title',
      child: InkWell(
        onTap: onPressed,
        child: CircularPercentIndicator(
          radius: 19,
          lineWidth: 1.5,
          backgroundColor: Theme.of(context).primaryColor,
          progressColor: Theme.of(context).indicatorColor,
          animation: true,
          animateFromLastPercent: true,
          percent: progress,
          center: percent > 0
              ? Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                )
              : Icon(
                  icon,
                  size: 22,

                  /// Why is this not picking up the theme like other widgets?!?!?!
                  color: Theme.of(context).primaryColor,
                ),
        ),
      ),
    );
  }
}

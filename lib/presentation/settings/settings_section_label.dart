// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class SettingsDividerLabel extends StatelessWidget {
  const SettingsDividerLabel({
    Key? key,
    required this.label,
    this.padding = const EdgeInsets.fromLTRB(16.0, 24.0, 0.0, 0.0),
  }) : super(key: key);
  final String label;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontSize: 12,
              color: Theme.of(context).primaryColor,
            ),
      ),
    );
  }
}

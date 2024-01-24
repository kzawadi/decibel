// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:io';

import 'package:flutter/material.dart';

class PlatformBackButton extends StatelessWidget {
  const PlatformBackButton({
    required this.iconColour,
    required this.decorationColour,
    required this.onPressed,
    super.key,
  });
  final Color decorationColour;
  final Color iconColour;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Ink(
          width: Platform.isIOS ? 28.0 : 42.0,
          height: Platform.isIOS ? 28.0 : 42.0,
          decoration: ShapeDecoration(
            color: decorationColour,
            shape: const CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.close,
              size: Platform.isIOS ? 18.0 : 32.0,
            ),
            padding: Platform.isIOS
                ? const EdgeInsets.only(left: 7)
                : const EdgeInsets.all(0),
            color: iconColour,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

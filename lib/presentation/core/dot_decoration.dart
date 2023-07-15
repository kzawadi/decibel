// Copyright 2020-2022 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

class DotDecoration extends Decoration {
  const DotDecoration({required this.colour});
  final Color colour;

  @override
  BoxPainter createBoxPainter([void Function()? onChanged]) {
    return _DotDecorationPainter(decoration: this);
  }
}

class _DotDecorationPainter extends BoxPainter {
  _DotDecorationPainter({required this.decoration});
  final DotDecoration decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    const pillWidth = 8;
    const pillHeight = 3;

    final center = configuration.size!.center(offset);
    final height = configuration.size!.height;

    final newOffset = Offset(center.dx, height - 8);

    final paint = Paint();
    paint.color = decoration.colour;
    paint.style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromLTRBR(
        newOffset.dx - pillWidth,
        newOffset.dy - pillHeight,
        newOffset.dx + pillWidth,
        newOffset.dy + pillHeight,
        const Radius.circular(12),
      ),
      paint,
    );
  }
}

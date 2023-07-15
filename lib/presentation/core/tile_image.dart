// Copyright 2023 Kelvin Zawadi @kzawadi. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/presentation/core/assets_constants.dart';
import 'package:decibel/presentation/core/placeholder_builder.dart';
import 'package:decibel/presentation/core/podcast_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TileImage extends StatelessWidget {
  const TileImage({
    required this.url,
    required this.size,
    super.key,
    this.highlight = false,
  });

  /// The URL of the image to display.
  final String url;

  /// The size of the image container; both height and width.
  final double size;

  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final placeholderBuilder = PlaceholderBuilder.of(context);

    return PodcastImage(
      key: Key('tile$url'),
      highlight: highlight,
      url: url,
      height: size,
      width: size,
      borderRadius: 4,
      fit: BoxFit.contain,
      placeholder: placeholderBuilder != null
          ? placeholderBuilder.builder()(context)
          : SvgPicture.asset(
              AssetsConstants.logo,
            ),
      errorPlaceholder: placeholderBuilder != null
          ? placeholderBuilder.errorBuilder()(context)
          : SvgPicture.asset(
              AssetsConstants.logo,
            ),
    );
  }
}

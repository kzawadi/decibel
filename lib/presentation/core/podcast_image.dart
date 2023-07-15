// Copyright 2023 Kelvin Zawadi @kzawadi. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

/// This class handles rendering of podcast images from a url. Images will be
/// cached for quicker fetching on subsequent requests. An optional placeholder
/// and error placeholder can be specified which will be rendered whilst the image
/// is loading or has failed to load.
///
/// We cache the image at a fixed sized of [cacheHeight] and [cacheWidth] regardless
/// of render size. By doing this, large podcast artwork will not slow the
/// application down and the same image rendered at different sizes will return
/// the same cache hit reducing the need for fetching the image several times for
/// differing render sizes.
// ignore: must_be_immutable
class PodcastImage extends StatefulWidget {
  const PodcastImage({
    required this.url,
    required this.placeholder,
    super.key,
    this.height = double.infinity,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    this.errorPlaceholder,
    this.highlight = false,
    this.borderRadius = 0.0,
  });
  final String url;
  final double height;
  final double width;
  final BoxFit fit;
  final bool highlight;
  final double borderRadius;
  final Widget? placeholder;
  final Widget? errorPlaceholder;

  @override
  State<PodcastImage> createState() => _PodcastImageState();
}

class _PodcastImageState extends State<PodcastImage>
    with TickerProviderStateMixin {
  static const cacheWidth = 480;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      widget.url,
      key: widget.key,
      width: widget.height,
      height: widget.width,
      cacheWidth: cacheWidth,
      fit: widget.fit,
      loadStateChanged: (ExtendedImageState state) {
        Widget renderWidget;

        if (state.extendedImageLoadState == LoadState.failed) {
          renderWidget = ClipRRect(
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius)),
            child: widget.errorPlaceholder ??
                SizedBox(
                  width: widget.width,
                  height: widget.height,
                ),
          );
        } else {
          renderWidget = AnimatedCrossFade(
            crossFadeState: state.wasSynchronouslyLoaded ||
                    state.extendedImageLoadState == LoadState.completed
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 500),
            firstChild: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.borderRadius)),
              child: widget.placeholder ??
                  SizedBox(
                    width: widget.width,
                    height: widget.height,
                  ),
            ),
            secondChild: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.borderRadius)),
              child: ExtendedRawImage(
                image: state.extendedImageInfo?.image,
                fit: widget.fit,
              ),
            ),
            layoutBuilder: (
              Widget topChild,
              Key topChildKey,
              Widget bottomChild,
              Key bottomChildKey,
            ) {
              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: widget.highlight
                    ? [
                        PositionedDirectional(
                          key: bottomChildKey,
                          child: bottomChild,
                        ),
                        PositionedDirectional(
                          key: topChildKey,
                          child: topChild,
                        ),
                        Positioned(
                          top: -1.5,
                          right: -1.5,
                          child: Container(
                            width: 13,
                            height: 13,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).canvasColor,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).indicatorColor,
                            ),
                          ),
                        ),
                      ]
                    : [
                        PositionedDirectional(
                          key: bottomChildKey,
                          child: bottomChild,
                        ),
                        PositionedDirectional(
                          key: topChildKey,
                          child: topChild,
                        ),
                      ],
              );
            },
          );
        }

        return renderWidget;
      },
    );
  }
}

class PodcastBannerImage extends StatefulWidget {
  const PodcastBannerImage({
    required this.url,
    required this.placeholder,
    super.key,
    this.height = double.infinity,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    this.errorPlaceholder,
    this.borderRadius = 0.0,
  });
  final String url;
  final double height;
  final double width;
  final BoxFit fit;
  final double borderRadius;
  final Widget? placeholder;
  final Widget? errorPlaceholder;

  @override
  State<PodcastBannerImage> createState() => _PodcastBannerImageState();
}

class _PodcastBannerImageState extends State<PodcastBannerImage>
    with TickerProviderStateMixin {
  static const cacheWidth = 480;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      widget.url,
      key: widget.key,
      width: widget.height,
      height: widget.width,
      cacheWidth: cacheWidth,
      fit: widget.fit,
      loadStateChanged: (ExtendedImageState state) {
        Widget renderWidget;

        if (state.extendedImageLoadState == LoadState.failed) {
          renderWidget = Container(
            alignment: Alignment.topCenter,
            width: widget.width - 2.0,
            height: widget.height - 2.0,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.borderRadius)),
              child: widget.errorPlaceholder ??
                  SizedBox(
                    width: widget.width - 2.0,
                    height: widget.height - 2.0,
                  ),
            ),
          );
        } else {
          renderWidget = AnimatedCrossFade(
            crossFadeState: state.wasSynchronouslyLoaded ||
                    state.extendedImageLoadState == LoadState.completed
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(seconds: 1),
            firstChild: widget.placeholder ??
                SizedBox(
                  width: widget.width,
                  height: widget.height,
                ),
            secondChild: ExtendedRawImage(
              width: widget.width,
              height: widget.height,
              image: state.extendedImageInfo?.image,
              fit: widget.fit,
            ),
            layoutBuilder: (
              Widget topChild,
              Key topChildKey,
              Widget bottomChild,
              Key bottomChildKey,
            ) {
              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  PositionedDirectional(
                    key: bottomChildKey,
                    child: bottomChild,
                  ),
                  PositionedDirectional(
                    key: topChildKey,
                    child: topChild,
                  ),
                ],
              );
            },
          );
        }

        return renderWidget;
      },
    );
  }
}

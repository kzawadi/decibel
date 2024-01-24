// Copyright 2020-2022 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.title,
  }) : super(key: key);
  final IconData icon;
  final String label;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label $title',
      child: CircularPercentIndicator(
        radius: 19,
        lineWidth: 1.5,
        backgroundColor: Theme.of(context).primaryColor,
        center: Icon(
          icon,
          size: 22,

          /// Why is this not picking up the theme like other widgets?!?!?!
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class PlayPauseBusyButton extends StatelessWidget {
  const PlayPauseBusyButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.title,
  }) : super(key: key);
  final IconData icon;
  final String label;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label $title',
      child: Container(
        padding: const EdgeInsets.all(0),
        height: 40,
        width: 38,
        child: Stack(
          children: <Widget>[
            CircularPercentIndicator(
              radius: 19,
              lineWidth: 1.5,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              center: Icon(
                icon,
                size: 22,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SpinKitRing(
              lineWidth: 1.5,
              color: Theme.of(context).primaryColor,
              size: 38,
            ),
          ],
        ),
      ),
    );
  }
}

// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// ignore_for_file: must_be_immutable

import 'package:decibel/domain/podcast/person.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

/// This Widget handles rendering of a person avatar. The data comes from the <person>
/// tag in the Podcasting 2.0 namespace.
///
/// https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#person
class PersonAvatar extends StatelessWidget {
  PersonAvatar({
    required this.person,
    super.key,
  }) {
    initial = person.name!.substring(0, 1).toUpperCase();

    role =
        person.role!.substring(0, 1).toUpperCase() + person.role!.substring(1);
  }
  final Person person;
  String initial = '';
  String role = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      // onTap:
      // person .link.isNotEmpty
      //     ? () {
      //         final uri = Uri.parse(person!.link!);

      //         unawaited(
      //           canLaunchUrl(uri).then((value) => launchUrl(uri)),
      //         );
      //       }
      //     : null,
      child: SizedBox(
        width: 96,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 32,
                foregroundImage: ExtendedImage.network(
                  person.image ??
                      'https://avatars.githubusercontent.com/u/12481289?s=400&u=971f33c93bfdf135d3897af31fefe95ca811eeb6&v=4',
                ).image,
                child: Text(initial),
              ),
              Text(
                person.name ?? 'no-name',
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
              Text(role),
            ],
          ),
        ),
      ),
    );
  }
}

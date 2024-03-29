// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

class Queue {
  Queue({
    required this.guids,
  });
  List<String> guids = <String>[];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'q': guids,
    };
  }

  static Queue fromMap(int key, Map<String, dynamic> guids) {
    final g = guids['q'] as List<dynamic>?;
    var result = <String>[];

    if (g != null) {
      result = g.map((dynamic e) => e.toString()).toList();
    }

    return Queue(
      guids: result,
    );
  }
}

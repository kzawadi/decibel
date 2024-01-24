// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:rxdart/rxdart.dart';

/// This BLoC provides a sink and stream to set and listen for the current
/// page/tab on a bottom navigation bar.
class PagerBloc {
  final BehaviorSubject<int> page = BehaviorSubject<int>.seeded(0);

  void Function(int) get changePage => page.add;
  Stream<int> get currentPage => page.stream;

  void dispose() {
    page.close();
  }
}

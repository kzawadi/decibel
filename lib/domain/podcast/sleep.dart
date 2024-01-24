// Copyright 2023 Kelvin Zawadi.@kzawadi and the project contributors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

enum SleepType {
  none,
  time,
  episode,
}

final class Sleep {
  Sleep({
    required this.type,
    this.duration = const Duration(milliseconds: 0),
  }) {
    endTime = DateTime.now().add(duration);
  }
  final SleepType type;
  final Duration duration;
  late DateTime endTime;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sleep &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          duration == other.duration;

  @override
  int get hashCode => type.hashCode ^ duration.hashCode;

  Duration get timeRemaining => endTime.difference(DateTime.now());
}

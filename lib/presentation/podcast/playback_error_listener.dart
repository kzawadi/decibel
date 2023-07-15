// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:decibel/application/bloc/audio_bloc.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Listens for errors on the audio BLoC. We receive a code which we then
/// map to an error message. This needs to be placed below a [Scaffold].
class PlaybackErrorListener extends StatefulWidget {
  const PlaybackErrorListener({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  State<PlaybackErrorListener> createState() => _PlaybackErrorListenerState();
}

class _PlaybackErrorListenerState extends State<PlaybackErrorListener> {
  late StreamSubscription<int> errorSubscription;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);

    errorSubscription = audioBloc.playbackError!.listen((code) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_codeToMessage(context, code))));
    });
  }

  @override
  void dispose() {
    errorSubscription.cancel();
    super.dispose();
  }

  /// Ideally the BLoC would pass us the message to display; however, as we need a
  /// context to fetch the correct version of any text string we need to work it out here.
  String _codeToMessage(BuildContext context, int code) {
    var result = '';

    switch (code) {
      case 401:
        result = AppStrings.error_no_connection;
      case 501:
        result = AppStrings.error_playback_fail;
    }

    return result;
  }
}

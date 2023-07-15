// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:decibel/domain/podcast/downloadable.dart';
import 'package:decibel/infrastructure/podcast/download/download_manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:logging/logging.dart';

/// A [DownloadManager] for handling downloading of podcasts on a mobile device.
class MobileDownloaderManager implements DownloadManager {
  MobileDownloaderManager() {
    _init();
  }
  static const portName = 'downloader_send_port';
  final log = Logger('MobileDownloaderManager');
  final ReceivePort _port = ReceivePort();
  final downloadController = StreamController<DownloadProgress>();
  var _lastUpdateTime = 0;

  @override
  Stream<DownloadProgress> get downloadProgress => downloadController.stream;

  Future<void> _init() async {
    log.fine('Initialising download manager');

    await FlutterDownloader.initialize();
    IsolateNameServer.removePortNameMapping(portName);

    IsolateNameServer.registerPortWithName(_port.sendPort, portName);

    final tasks = await FlutterDownloader.loadTasks();

    // Update the status of any tasks that may have been updated whilst
    // AnyTime was close or in the background.
    if (tasks != null && tasks.isNotEmpty) {
      for (final t in tasks) {
        _updateDownloadState(
            id: t.taskId, progress: t.progress, status: t.status.value);

        /// If we are not queued or running we can safely clean up this event
        if (t.status != DownloadTaskStatus.enqueued &&
            t.status != DownloadTaskStatus.running) {
          await FlutterDownloader.remove(taskId: t.taskId);
        }
      }
    }

    _port.listen((dynamic data) {
      final id = data[0] as String;
      final status = data[1] as int;
      final progress = data[2] as int;

      _updateDownloadState(id: id, progress: progress, status: status);
    });

    await FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  Future<String?> enqueueTask(
      String url, String downloadPath, String fileName) async {
    return await FlutterDownloader.enqueue(
      url: url,
      savedDir: downloadPath,
      fileName: fileName,
      openFileFromNotification: false,
      // headers: {
      //   'User-Agent': Environment.userAgent(),
      // },
    );
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping(portName);
    downloadController.close();
  }

  void _updateDownloadState(
      {required String id, required int progress, required int status}) {
    var state = DownloadState.none;
    final updateTime = DateTime.now().millisecondsSinceEpoch;
    final downloadStatus = DownloadTaskStatus(status);

    if (downloadStatus == DownloadTaskStatus.enqueued) {
      state = DownloadState.queued;
    } else if (downloadStatus == DownloadTaskStatus.canceled) {
      state = DownloadState.cancelled;
    } else if (downloadStatus == DownloadTaskStatus.complete) {
      state = DownloadState.downloaded;
    } else if (downloadStatus == DownloadTaskStatus.running) {
      state = DownloadState.downloading;
    } else if (downloadStatus == DownloadTaskStatus.failed) {
      state = DownloadState.failed;
    } else if (downloadStatus == DownloadTaskStatus.paused) {
      state = DownloadState.paused;
    }

    /// If we are running, we want to limit notifications to 1 per second. Otherwise,
    /// small downloads can cause a flood of events. Any other status we always want
    /// to push through.
    if (downloadStatus != DownloadTaskStatus.running ||
        progress == 0 ||
        progress == 100 ||
        updateTime > _lastUpdateTime + 1000) {
      downloadController.add(DownloadProgress(id, progress, state));
      _lastUpdateTime = updateTime;
    }
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }
}

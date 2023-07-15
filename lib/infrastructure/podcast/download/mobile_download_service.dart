// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:decibel/domain/podcast/downloadable.dart';
import 'package:decibel/domain/podcast/episode.dart';
import 'package:decibel/infrastructure/core/utils.dart';
import 'package:decibel/infrastructure/podcast/download/download_manager.dart';
import 'package:decibel/infrastructure/podcast/download/download_service.dart';
import 'package:decibel/infrastructure/podcast/repository/repository.dart';
import 'package:logging/logging.dart';
import 'package:mp3_info/mp3_info.dart';
import 'package:rxdart/rxdart.dart';

/// An implementation of a [DownloadService] that handles downloading
/// of episodes on mobile.
class MobileDownloadService extends DownloadService {
  MobileDownloadService({
    required this.repository,
    required this.downloadManager,
  }) {
    downloadManager.downloadProgress.pipe(downloadProgress);
    downloadProgress.listen(_updateDownloadProgress);
  }
  static BehaviorSubject<DownloadProgress> downloadProgress =
      BehaviorSubject<DownloadProgress>();

  final log = Logger('MobileDownloadService');
  final Repository repository;
  final DownloadManager downloadManager;

  @override
  void dispose() {
    downloadManager.dispose();
  }

  @override
  Future<bool> downloadEpisode(Episode episode) async {
    final season = episode.season > 0 ? episode.season.toString() : '';
    final epno = episode.episode > 0 ? episode.episode.toString() : '';

    if (await hasStoragePermission()) {
      final savedEpisode = await repository.findEpisodeByGuid(episode.guid);

      if (savedEpisode != null) {
        episode = savedEpisode;
      }

      final episodePath = await resolveDirectory(episode: episode);
      final downloadPath = await resolveDirectory(episode: episode, full: true);
      var uri = Uri.parse(episode.contentUrl!);

      // Ensure the download directory exists
      await createDownloadDirectory(episode);

      // Filename should be last segment of URI.
      var filename = safeFile(
        uri.pathSegments.lastWhere(
          (e) => e.toLowerCase().endsWith('.mp3'),
        ),
      );

      filename ??= safeFile(
        uri.pathSegments.lastWhere(
          (e) => e.toLowerCase().endsWith('.m4a'),
        ),
      );

      if (filename == null) {
        //TODO: Handle unsupported format.
      } else {
        // The last segment could also be a full URL. Take a second pass.
        if (filename.contains('/')) {
          try {
            uri = Uri.parse(filename);
            filename = uri.pathSegments.last;
          } on FormatException {
            // It wasn't a URL...
          }
        }

        // Some podcasts use the same file name for each episode. If we have a
        // season and/or episode number provided by backend we can use that. We
        // will also append the filename with the publication date if available.
        var pubDate = '';

        if (episode.publicationDate != null) {
          pubDate =
              '${episode.publicationDate!.millisecondsSinceEpoch ~/ 1000}-';
        }

        filename = '$season$epno$pubDate$filename';

        log.fine(
          'Download episode (${episode.title}) $filename to $downloadPath/$filename',
        );

        /// If we get a redirect to an http endpoint the download will fail. Let's fully resolve
        /// the URL before calling download and ensure it is https.
        final url = await resolveUrl(episode.contentUrl!, forceHttps: true);

        final taskId =
            await downloadManager.enqueueTask(url, downloadPath, filename);

        // Update the episode with download data
        episode.filepath = episodePath;
        episode.filename = filename;
        episode.downloadTaskId = taskId!;
        episode.downloadState = DownloadState.downloading;
        episode.downloadPercentage = 0;

        await repository.saveEpisode(episode);

        return Future.value(true);
      }
    }

    return Future.value(false);
  }

  @override
  Future<Episode?> findEpisodeByTaskId(String taskId) {
    return repository.findEpisodeByTaskId(taskId);
  }

  Future<void> _updateDownloadProgress(DownloadProgress progress) async {
    final episode = await repository.findEpisodeByTaskId(progress.id);

    if (episode!.downloadPercentage != progress.percentage ||
        episode.downloadState != progress.status) {
      episode.downloadPercentage = progress.percentage;
      episode.downloadState = progress.status;

      if (progress.percentage == 100) {
        if (await hasStoragePermission()) {
          final filename = await resolvePath(episode);

          // If we do not have a duration for this file - let's calculate it
          if (episode.duration == 0) {
            final mp3Info = MP3Processor.fromFile(File(filename));

            episode.duration = mp3Info.duration.inSeconds;
          }
        }
      }

      await repository.saveEpisode(episode);
    }
  }
}

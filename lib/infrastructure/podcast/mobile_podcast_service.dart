// Copyright 2023 Kelvin Zawadi. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:collection';
import 'dart:io';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:decibel/application/bloc/episode_state.dart';
import 'package:decibel/domain/podcast/chapter.dart';
import 'package:decibel/domain/podcast/downloadable.dart';
import 'package:decibel/domain/podcast/episode.dart';
import 'package:decibel/domain/podcast/person.dart';
import 'package:decibel/domain/podcast/podcast.dart';
import 'package:decibel/domain/podcast/search_result.dart';
import 'package:decibel/infrastructure/core/utils.dart';
import 'package:decibel/infrastructure/podcast/podcast_service.dart';
import 'package:decibel/infrastructure/podcast/services/podcast_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:podcast_search/podcast_search.dart' as podcast_search;

class MobilePodcastService extends PodcastService {
  // final PodcastApi api;

  MobilePodcastService({
    required super.api,
    required super.repository,
    required super.settingsService,
  }) {
    // _init();
  }
  final descriptionRegExp1 =
      RegExp(r'(<\/p><br>|<\/p><\/br>|<p><br><\/p>|<p><\/br><\/p>)');
  final descriptionRegExp2 = RegExp(r'(<p><br><\/p>|<p><\/br><\/p>)');
  final log = Logger('MobilePodcastService');

  //TODO (kelvin): later on after some testing i should come up with a good caching params to avoid unnecesary network loads but also balance on new updates
  final _cache =
      _PodcastCache(maxItems: 10, expiration: const Duration(minutes: 30));
  final _categories = <String>[];
  final _intlCategories = <String>[];
  final _intlCategoriesSorted = <String>[];

  @override
  Future<SearchResult> charts() {
    // final providerGenre = _decodeGenre(genre);

    return api.charts();
  }

  @override
  List<String> genres() {
    return _intlCategoriesSorted;
  }

  /// Loads the specified [Podcast]. If the Podcast instance has an ID we'll fetch
  /// it from storage. If not, we'll check the cache to see if we have seen it
  /// recently and return that if available. If not, we'll make a call to load
  /// it from the network.
  @override
  Future<Podcast?> loadPodcast({
    required Podcast podcast,
    bool highlightNewEpisodes = false,
    bool refresh = false,
  }) async {
    log.fine('loadPodcast. ID ${podcast.id} (refresh $refresh)');

    if (podcast.id == null || refresh) {
      podcast_search.Podcast? loadedPodcast;
      var imageUrl = podcast.imageUrl;
      var thumbImageUrl = podcast.thumbImageUrl;

      if (!refresh) {
        log.fine('Not a refresh so try to fetch from cache');
        loadedPodcast = _cache.item(podcast.url);
      }

      // If we didn't get a cache hit load the podcast feed.
      if (loadedPodcast == null) {
        try {
          log.fine('Loading podcast from feed ${podcast.url}');
          loadedPodcast = await _loadPodcastFeed(url: podcast.url);
        } on Exception {
          rethrow;
        }

        _cache.store(loadedPodcast);
      }

      final title = _format(loadedPodcast.title);
      final description = _format(loadedPodcast.description);
      final copyright = _format(loadedPodcast.copyright);
      final persons = <Person>[];
      final existingEpisodes =
          await repository.findEpisodesByPodcastGuid(loadedPodcast.url!);

      // If imageUrl is null we have not loaded the podcast as a result of a search.
      if (imageUrl == null || imageUrl.isEmpty || refresh) {
        imageUrl = loadedPodcast.image;
        thumbImageUrl = loadedPodcast.image;
      }

      for (final p in loadedPodcast.persons) {
        persons.add(
          Person(
            name: p.name,
            role: p.role ?? '',
            group: p.group ?? '',
            image: p.image,
            link: p.link,
          ),
        );
      }

      var pc = Podcast(
        guid: loadedPodcast.url,
        url: loadedPodcast.url!,
        link: loadedPodcast.link,
        title: title,
        description: description,
        imageUrl: imageUrl,
        thumbImageUrl: thumbImageUrl,
        copyright: copyright,
        persons: persons,
        episodes: <Episode>[],
      );

      /// We could be following this podcast already. Let's check.
      final follow = await repository.findPodcastByGuid(loadedPodcast.url!);

      if (follow != null) {
        // We are, so swap in the stored ID so we update the saved version later.
        pc.id = follow.id;
      }

      // Usually, episodes are order by reverse publication date - but not always.
      // Enforce that ordering. To prevent unnecessary sorting, we'll sample the
      // first two episodes to see what order they are in.
      if (loadedPodcast.episodes.length > 1) {
        if (loadedPodcast.episodes[0].publicationDate!.millisecondsSinceEpoch <
            loadedPodcast.episodes[1].publicationDate!.millisecondsSinceEpoch) {
          loadedPodcast.episodes.sort(
            (e1, e2) => e2.publicationDate!.compareTo(e1.publicationDate!),
          );
        }
      }

      // Loop through all episodes in the feed and check to see if we already have that episode
      // stored. If we don't, it's a new episode so add it; if we do update our copy in case it's changed.
      for (final episode in loadedPodcast.episodes) {
        final existingEpisode =
            existingEpisodes.firstWhereOrNull((ep) => ep!.guid == episode.guid);
        final author = episode.author?.replaceAll('\n', '').trim() ?? '';
        final title = _format(episode.title);
        final description = _format(episode.description);
        final content = episode.content;

        final episodeImage =
            episode.imageUrl == null || episode.imageUrl!.isEmpty
                ? pc.imageUrl
                : episode.imageUrl;
        final episodeThumbImage =
            episode.imageUrl == null || episode.imageUrl!.isEmpty
                ? pc.thumbImageUrl
                : episode.imageUrl;
        final duration = episode.duration?.inSeconds ?? 0;

        final episodePersons = <Person>[];

        if (episode.persons.isNotEmpty) {
          for (final p in episode.persons) {
            episodePersons.add(
              Person(
                name: p.name,
                role: p.role!,
                group: p.group!,
                image: p.image,
                link: p.link,
              ),
            );
          }
        } else if (persons.isNotEmpty) {
          episodePersons.addAll(persons);
        }

        if (existingEpisode == null) {
          pc.newEpisodes = highlightNewEpisodes && pc.id != null;

          pc.episodes.add(
            Episode(
              highlight: pc.newEpisodes,
              pguid: pc.guid,
              guid: episode.guid,
              podcast: pc.title,
              title: title,
              description: description,
              content: content,
              author: author,
              season: episode.season ?? 0,
              episode: episode.episode ?? 0,
              contentUrl: episode.contentUrl,
              link: episode.link,
              imageUrl: episodeImage,
              thumbImageUrl: episodeThumbImage,
              duration: duration,
              publicationDate: episode.publicationDate,
              chaptersUrl: episode.chapters?.url,
              persons: episodePersons,
              chapters: <Chapter>[],
            ),
          );
        } else {
          /// Check if the ancillary episode data has changed.
          if (!listEquals(existingEpisode.persons, episodePersons)) {
            pc.updatedEpisodes = true;
          }

          existingEpisode.title = title;
          existingEpisode.description = description;
          existingEpisode.content = content;
          existingEpisode.author = author;
          existingEpisode.season = episode.season ?? 0;
          existingEpisode.episode = episode.episode ?? 0;
          existingEpisode.contentUrl = episode.contentUrl;
          existingEpisode.link = episode.link;
          existingEpisode.imageUrl = episodeImage;
          existingEpisode.thumbImageUrl = episodeThumbImage;
          existingEpisode.publicationDate = episode.publicationDate;
          existingEpisode.chaptersUrl = episode.chapters?.url;
          existingEpisode.persons = episodePersons;

          // If the source duration is 0 do not update any saved, calculated duration.
          if (duration > 0) {
            existingEpisode.duration = duration;
          }

          pc.episodes.add(existingEpisode);

          // Clear this episode from our existing list
          existingEpisodes.remove(existingEpisode);
        }
      }

      // Add any downloaded episodes that are no longer in the feed - they
      // may have expired but we still want them.
      final expired = <Episode>[];

      for (final episode in existingEpisodes) {
        final feedEpisode = loadedPodcast.episodes
            .firstWhereOrNull((ep) => ep.guid == episode!.guid);

        if (feedEpisode == null && episode!.downloaded) {
          pc.episodes.add(episode);
        } else {
          expired.add(episode!);
        }
      }

      // If we are subscribed to this podcast and are simply refreshing we need to save the updated subscription.
      // A non-null ID indicates this podcast is subscribed too. We also need to delete any expired episodes.
      if (podcast.id != null && refresh) {
        await repository.deleteEpisodes(expired);

        pc = await repository.savePodcast(pc);
      }

      return pc;
    } else {
      return await loadPodcastById(id: podcast.id ?? 0);
    }
  }

  @override
  Future<Podcast?> loadPodcastById({required int id}) {
    return repository.findPodcastById(id);
  }

  @override
  Future<List<Chapter>> loadChaptersByUrl({required String url}) async {
    final c = await _loadChaptersByUrl(url);
    final chapters = <Chapter>[];

    if (c != null) {
      for (final chapter in c.chapters) {
        chapters.add(
          Chapter(
            title: chapter.title,
            url: chapter.url,
            imageUrl: chapter.imageUrl,
            startTime: chapter.startTime,
            endTime: chapter.endTime,
            toc: chapter.toc,
          ),
        );
      }
    }

    return chapters;
  }

  @override
  Future<List<Episode>> loadDownloads() async {
    return repository.findDownloads();
  }

  @override
  Future<List<Episode>> loadEpisodes() async {
    return repository.findAllEpisodes();
  }

  @override
  Future<bool> deleteDownload(Episode episode) async {
    // If this episode is currently downloading, cancel the download first.
    if (episode.downloadPercentage! < 100) {
      await FlutterDownloader.cancel(taskId: episode.downloadTaskId!);
    }

    episode.downloadTaskId = null;
    episode.downloadPercentage = 0;
    episode.position = 0;
    episode.downloadState = DownloadState.none;

    if (settingsService.markDeletedEpisodesAsPlayed) {
      episode.played = true;
    }

    await repository.saveEpisode(episode);

    if (await hasStoragePermission()) {
      final f = File.fromUri(Uri.file(await resolvePath(episode)));

      log.fine('Deleting file ${f.path}');

      if (await f.exists()) {
        await f.delete().whenComplete(() => true);
      }
    }

    return false;
  }

  @override
  Future<void> toggleEpisodePlayed(Episode episode) async {
    episode.played = !episode.played;
    episode.position = 0;

    await repository.saveEpisode(episode);
    return;
  }

  @override
  Future<List<Podcast>> subscriptions() {
    return repository.subscriptions();
  }

  @override
  Future<void> unsubscribe(Podcast podcast) async {
    if (await hasStoragePermission()) {
      final filename =
          join(await getStorageDirectory(), safeFile(podcast.title));

      final d = Directory.fromUri(Uri.file(filename));

      if (await d.exists()) {
        await d.delete(recursive: true);
      }
    }

    return repository.deletePodcast(podcast);
  }

  @override
  Future<Podcast> subscribe(Podcast podcast) async {
    // We may already have episodes download for this podcast before the user
    // hit subscribe.
    final savedEpisodes =
        await repository.findEpisodesByPodcastGuid(podcast.guid!);

    for (var episode in podcast.episodes) {
      episode = savedEpisodes.firstWhere(
        (ep) => ep!.guid == episode.guid,
        orElse: () => episode,
      )!;

      episode.pguid = podcast.guid;
    }

    return repository.savePodcast(podcast);
  }

  @override
  Future<Podcast> save(Podcast podcast) async {
    return repository.savePodcast(podcast);
  }

  @override
  Future<Episode> saveEpisode(Episode episode) async {
    return repository.saveEpisode(episode);
  }

  @override
  Future<void> saveQueue(List<Episode> episodes) async {
    await repository.saveQueue(episodes);
  }

  @override
  Future<List<Episode>> loadQueue() async {
    return await repository.loadQueue();
  }

  /// Remove HTML padding from the content. The padding may look fine within
  /// the context of a browser, but can look out of place on a mobile screen.
  String _format(String? input) {
    return input
            ?.trim()
            .replaceAll(descriptionRegExp2, '')
            .replaceAll(descriptionRegExp1, '</p>') ??
        '';
  }

  Future<podcast_search.Chapters?> _loadChaptersByUrl(String url) {
    return compute<_FeedComputer, podcast_search.Chapters?>(
      _loadChaptersByUrlCompute,
      _FeedComputer(api: api, url: url),
    );
  }

  static Future<podcast_search.Chapters?> _loadChaptersByUrlCompute(
    _FeedComputer c,
  ) async {
    podcast_search.Chapters? result;

    try {
      result = await c.api.loadChapters(c.url);
    } catch (e) {
      final log = Logger('MobilePodcastService');

      log.fine('Failed to download chapters');
      log.fine(e);
    }

    return result;
  }

  /// Loading and parsing a podcast feed can take several seconds. Larger feeds
  /// can end up blocking the UI thread. We perform our feed load in a
  /// separate isolate so that the UI can continue to present a loading
  /// indicator whilst the data is fetched without locking the UI.
  Future<podcast_search.Podcast> _loadPodcastFeed({required String url}) {
    return compute<_FeedComputer, podcast_search.Podcast>(
      _loadPodcastFeedCompute,
      _FeedComputer(api: api, url: url),
    );
  }

  /// We have to separate the process of calling compute as you cannot use
  /// named parameters with compute. The podcast feed load API uses named
  /// parameters so we need to change it to a single, positional parameter.
  static Future<podcast_search.Podcast> _loadPodcastFeedCompute(
    _FeedComputer c,
  ) {
    return c.api.loadFeed(c.url);
  }

  /// The service providers expect the genre to be passed in English. This function takes
  /// the selected genre and returns the English version.
  String _decodeGenre(String? genre) {
    var decodedGenre = '';

    if (genre != null) {
      final index = _intlCategories.indexOf(genre);

      if (index >= 0) {
        decodedGenre = _categories[index];

        if (decodedGenre == '<All>') {
          decodedGenre = '';
        }
      }
    }

    return decodedGenre;
  }

  @override
  Stream<Podcast> get podcastListener => repository.podcastListener;

  @override
  Stream<EpisodeState> get episodeListener => repository.episodeListener;
}

/// A simple cache to reduce the number of network calls when loading podcast
/// feeds. We can cache up to [maxItems] items with each item having an
/// expiration time of [expiration]. The cache works as a FIFO queue, so if we
/// attempt to store a new item in the cache and it is full we remove the
/// first (and therefore oldest) item from the cache. Cache misses are returned
/// as null.
class _PodcastCache {
  _PodcastCache({required this.maxItems, required this.expiration})
      : _queue = Queue<_CacheItem>();
  final int maxItems;
  final Duration expiration;
  final Queue<_CacheItem?> _queue;

  podcast_search.Podcast? item(String key) {
    final hit = _queue.firstWhereOrNull(
      (_CacheItem? i) => i!.podcast.url == key,
    );
    podcast_search.Podcast? p;

    if (hit != null) {
      final now = DateTime.now();

      if (now.difference(hit.dateAdded) <= expiration) {
        return p = hit.podcast;
      } else {
        _queue.remove(hit);
      }
    }

    return p;
  }

  void store(podcast_search.Podcast podcast) {
    if (_queue.length == maxItems) {
      _queue.removeFirst();
    }

    _queue.addLast(_CacheItem(podcast));
  }
}

/// A simple class that stores an instance of a Podcast and the
/// date and time it was added. This can be used by the cache to
/// keep a small and up-to-date list of searched for Podcasts.
class _CacheItem {
  _CacheItem(this.podcast) : dateAdded = DateTime.now();
  final podcast_search.Podcast podcast;
  final DateTime dateAdded;
}

class _FeedComputer {
  _FeedComputer({required this.api, required this.url});
  final PodcastApi api;

  final String url;
}

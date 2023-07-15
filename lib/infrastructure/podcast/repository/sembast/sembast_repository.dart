// Copyright Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/bloc/episode_state.dart';
import 'package:decibel/domain/core/extensions.dart';
import 'package:decibel/domain/podcast/episode.dart';
import 'package:decibel/domain/podcast/podcast.dart';
import 'package:decibel/domain/podcast/queue.dart';
import 'package:decibel/infrastructure/podcast/repository/repository.dart';
import 'package:decibel/infrastructure/podcast/repository/sembast/sembast_database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sembast/sembast.dart';

/// An implementation of [Repository] that is backed by
/// [Sembast](https://github.com/tekartik/sembast.dart/tree/master/sembast)
class SembastRepository extends Repository {
  SembastRepository({
    bool cleanup = true,
    String databaseName = 'anytime.db',
  }) {
    _databaseService =
        DatabaseService(databaseName, version: 2, upgraderCallback: dbUpgrader);

    if (cleanup) {
      _cleanupEpisodes().then((value) {
        log.fine('Orphan episodes cleanup complete');
      });
    }
  }
  final log = Logger('SembastRepository');

  final _podcastSubject = BehaviorSubject<Podcast>();
  final _episodeSubject = BehaviorSubject<EpisodeState>();

  final _podcastStore = intMapStoreFactory.store('podcast');
  final _episodeStore = intMapStoreFactory.store('episode');
  final _queueStore = intMapStoreFactory.store('queue');

  final _queueGuids = <String>[];

  late DatabaseService _databaseService;

  Future<Database> get _db async => _databaseService.database;

  /// Saves the [Podcast] instance and associated [Episode]s. Podcasts are
  /// only stored when we subscribe to them, so at the point we store a
  /// new podcast we store the current [DateTime] to mark the
  /// subscription date.
  @override
  Future<Podcast> savePodcast(Podcast podcast) async {
    log.fine('Saving podcast (${podcast.id}) ${podcast.url}');

    final finder = podcast.id == null
        ? Finder(filter: Filter.equals('guid', podcast.guid))
        : Finder(filter: Filter.byKey(podcast.id));
    final snapshot = await _podcastStore.findFirst(await _db, finder: finder);

    podcast.lastUpdated = DateTime.now();

    if (snapshot == null) {
      podcast.subscribedDate = DateTime.now();
      podcast.id = await _podcastStore.add(await _db, podcast.toMap());
    } else {
      await _podcastStore.update(await _db, podcast.toMap(), finder: finder);
    }

    await _saveEpisodes(podcast.episodes);

    _podcastSubject.add(podcast);

    return podcast;
  }

  @override
  Future<List<Podcast>> subscriptions() async {
    final finder = Finder(
      sortOrders: [
        SortOrder('title'),
      ],
    );

    final subscriptionSnapshot = await _podcastStore.find(
      await _db,
      finder: finder,
    );

    final subs = subscriptionSnapshot.map((snapshot) {
      final subscription = Podcast.fromMap(snapshot.key, snapshot.value);

      return subscription;
    }).toList();

    return subs;
  }

  @override
  Future<void> deletePodcast(Podcast podcast) async {
    final db = await _db;

    await db.transaction((txn) async {
      final podcastFinder = Finder(filter: Filter.byKey(podcast.id));
      final episodeFinder =
          Finder(filter: Filter.equals('pguid', podcast.guid));

      await _podcastStore.delete(
        txn,
        finder: podcastFinder,
      );

      await _episodeStore.delete(
        txn,
        finder: episodeFinder,
      );
    });
  }

  @override
  Future<Podcast?> findPodcastById(num id) async {
    final finder = Finder(filter: Filter.byKey(id));

    final snapshot = await _podcastStore.findFirst(await _db, finder: finder);

    if (snapshot != null) {
      final p = Podcast.fromMap(snapshot.key, snapshot.value);

      // Now attach all episodes for this podcast
      p.episodes = await findEpisodesByPodcastGuid(p.guid);

      return p;
    }

    return null;
  }

  @override
  Future<Podcast?> findPodcastByGuid(String guid) async {
    final finder = Finder(filter: Filter.equals('guid', guid));

    final snapshot = await _podcastStore.findFirst(await _db, finder: finder);

    if (snapshot != null) {
      final p = Podcast.fromMap(snapshot.key, snapshot.value);

      // Now attach all episodes for this podcast
      p.episodes = await findEpisodesByPodcastGuid(p.guid);

      return p;
    }

    return null;
  }

  @override
  Future<List<Episode>> findAllEpisodes() async {
    final finder = Finder(
      sortOrders: [SortOrder('publicationDate', false)],
    );

    final recordSnapshots = await _episodeStore.find(await _db, finder: finder);

    final results = recordSnapshots.map((snapshot) {
      final episode = Episode.fromMap(snapshot.key, snapshot.value);

      return episode;
    }).toList();

    return results;
  }

  @override
  Future<Episode> findEpisodeById(int id) async {
    final snapshot = await _episodeStore.record(id).get(await _db);

    return await _loadEpisodeSnapshot(id, snapshot!);
  }

  @override
  Future<Episode?> findEpisodeByGuid(String guid) async {
    final finder = Finder(filter: Filter.equals('guid', guid));

    final snapshot = await _episodeStore.findFirst(await _db, finder: finder);

    if (snapshot != null) {
      return await _loadEpisodeSnapshot(snapshot.key, snapshot.value);
    } else {
      return null;
    }
  }

  @override
  Future<List<Episode>> findEpisodesByPodcastGuid(String? pguid) async {
    final finder = Finder(
      filter: Filter.equals('pguid', pguid),
      sortOrders: [SortOrder('publicationDate', false)],
    );

    final recordSnapshots = await _episodeStore.find(await _db, finder: finder);

    final results = recordSnapshots.map((snapshot) async {
      return await _loadEpisodeSnapshot(snapshot.key, snapshot.value);
    }).toList();

    final episodeList = Future.wait(results);

    return episodeList;
  }

  @override
  Future<List<Episode>> findDownloadsByPodcastGuid(String pguid) async {
    final finder = Finder(
      filter: Filter.and([
        Filter.equals('pguid', pguid),
        Filter.equals('downloadPercentage', '100'),
      ]),
      sortOrders: [SortOrder('publicationDate', false)],
    );

    final recordSnapshots = await _episodeStore.find(await _db, finder: finder);

    final results = recordSnapshots.map((snapshot) {
      final episode = Episode.fromMap(snapshot.key, snapshot.value);

      return episode;
    }).toList();

    return results;
  }

  @override
  Future<List<Episode>> findDownloads() async {
    final finder = Finder(
      filter: Filter.equals('downloadPercentage', '100'),
      sortOrders: [SortOrder('publicationDate', false)],
    );

    final recordSnapshots = await _episodeStore.find(await _db, finder: finder);

    final results = recordSnapshots.map((snapshot) {
      final episode = Episode.fromMap(snapshot.key, snapshot.value);

      return episode;
    }).toList();

    return results;
  }

  @override
  Future<void> deleteEpisode(Episode episode) async {
    final finder = Finder(filter: Filter.byKey(episode.id));

    final snapshot = await _episodeStore.findFirst(await _db, finder: finder);

    if (snapshot == null) {
      // Oops!
    } else {
      await _episodeStore.delete(await _db, finder: finder);
      _episodeSubject.add(EpisodeDeleteState(episode));
    }
  }

  @override
  Future<void> deleteEpisodes(List<Episode>? episodes) async {
    final d = await _db;

    if (episodes != null && episodes.isNotEmpty) {
      for (final chunk in episodes.chunk(100)) {
        await d.transaction((txn) async {
          final futures = <Future<int>>[];

          for (final episode in chunk) {
            final finder = Finder(filter: Filter.byKey(episode.id));

            futures.add(_episodeStore.delete(txn, finder: finder));
          }

          if (futures.isNotEmpty) {
            await Future.wait(futures);
          }
        });
      }
    }
  }

  @override
  Future<Episode> saveEpisode(
    Episode episode, [
    bool updateIfSame = false,
  ]) async {
    final e = await _saveEpisode(episode, updateIfSame);

    _episodeSubject.add(EpisodeUpdateState(e));

    return e;
  }

  @override
  Future<List<Episode>> loadQueue() async {
    var episodes = <Episode>[];

    final snapshot = await _queueStore.record(1).getSnapshot(await _db);

    if (snapshot != null) {
      final queue = Queue.fromMap(snapshot.key, snapshot.value);

      if (queue.guids.isNotEmpty) {
        //todo(kzawadi): if queue are not persisted look at this
        final episodeFinder =
            Finder(filter: Filter.inList('guid', queue.guids));

        final recordSnapshots =
            await _episodeStore.find(await _db, finder: episodeFinder);

        episodes = recordSnapshots.map((snapshot) {
          final episode = Episode.fromMap(snapshot.key, snapshot.value);

          return episode;
        }).toList();
      }
    }

    return episodes;
  }

  @override
  Future<void> saveQueue(List<Episode> episodes) async {
    /// Check to see if we have any ad-hoc episodes and save them first
    for (final e in episodes) {
      if (e.pguid == null || e.pguid!.isEmpty) {
        await _saveEpisode(e, false);
      }
    }

    final guids = episodes.map((e) => e.guid).toList();

    /// Only bother saving if the queue has changed
    if (!listEquals(guids, _queueGuids)) {
      final queue = Queue(guids: guids);

      await _queueStore.record(1).put(await _db, queue.toMap());

      _queueGuids.clear();
      _queueGuids.addAll(guids);
    }
  }

  Future<void> _cleanupEpisodes() async {
    final threshold = DateTime.now()
        .subtract(const Duration(days: 32))
        .millisecondsSinceEpoch;

    /// Find all streamed episodes over the threshold.
    final filter = Filter.and([
      Filter.equals('downloadState', 0),
      Filter.lessThan('lastUpdated', threshold),
    ]);

    final orphaned = <Episode>[];
    final pguids = <String>[];
    final episodes =
        await _episodeStore.find(await _db, finder: Finder(filter: filter));

    // First, find all podcasts
    for (final podcast in await _podcastStore.find(await _db)) {
      pguids.add(podcast.value['guid'] as String);
    }

    for (final episode in episodes) {
      final pguid = episode.value['pguid'] as String;
      final podcast = pguids.contains(pguid);

      if (!podcast) {
        orphaned.add(Episode.fromMap(episode.key, episode.value));
      }
    }

    await deleteEpisodes(orphaned);
  }

  /// Saves a list of episodes to the repository. To improve performance we
  /// split the episodes into chunks of 100 and save any that have been updated
  /// in that chunk in a single transaction.
  Future<void> _saveEpisodes(List<Episode> episodes) async {
    final d = await _db;
    final dateStamp = DateTime.now();

    if (episodes.isNotEmpty) {
      for (final chunk in episodes.chunk(100)) {
        await d.transaction((txn) async {
          final futures = <Future<int>>[];

          for (final episode in chunk) {
            episode.lastUpdated = dateStamp;

            if (episode.id == null) {
              futures.add(
                _episodeStore
                    .add(txn, episode.toMap())
                    .then((id) => episode.id = id),
              );
            } else {
              final finder = Finder(filter: Filter.byKey(episode.id));

              final existingEpisode = await findEpisodeById(episode.id!);

              if (existingEpisode != episode) {
                futures.add(
                  _episodeStore.update(txn, episode.toMap(), finder: finder),
                );
              }
            }
          }

          if (futures.isNotEmpty) {
            await Future.wait(futures);
          }
        });
      }
    }
  }

  Future<Episode> _saveEpisode(Episode episode, bool updateIfSame) async {
    final finder = Finder(filter: Filter.byKey(episode.id));

    final snapshot = await _episodeStore.findFirst(await _db, finder: finder);

    if (snapshot == null) {
      episode.lastUpdated = DateTime.now();
      episode.id = await _episodeStore.add(await _db, episode.toMap());
    } else {
      final e = Episode.fromMap(episode.id!, snapshot.value);
      episode.lastUpdated = DateTime.now();

      if (updateIfSame || episode != e) {
        await _episodeStore.update(await _db, episode.toMap(), finder: finder);
      }
    }

    return episode;
  }

  @override
  Future<Episode?> findEpisodeByTaskId(String taskId) async {
    final finder = Finder(filter: Filter.equals('downloadTaskId', taskId));
    final snapshot = await _episodeStore.findFirst(await _db, finder: finder);

    if (snapshot != null) {
      return await _loadEpisodeSnapshot(snapshot.key, snapshot.value);
    } else {
      return null;
    }
  }

  Future<Episode> _loadEpisodeSnapshot(
    int key,
    Map<String, dynamic> snapshot,
  ) async {
    final episode = Episode.fromMap(key, snapshot);

    return episode;
  }

  @override
  Future<void> close() async {
    final d = await _db;

    await d.close();
  }

  Future<void> dbUpgrader(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1) {
      await _upgradeV2(db);
    }
  }

  /// In v1 we allowed http requests, where as now we force to https. As we currently use the
  /// URL as the GUID we need to upgrade any followed podcasts that have a http base to https.
  /// We use the passed [Database] rather than _db to prevent deadlocking, hence the direct
  /// update to data within this routine rather than using the existing find/update methods.
  Future<void> _upgradeV2(Database db) async {
    final data = await _podcastStore.find(db);
    final podcasts = data.map((e) => Podcast.fromMap(e.key, e.value)).toList();

    log.info('Upgrading Sembast store to V2');

    for (final podcast in podcasts) {
      if (podcast.guid!.startsWith('http:')) {
        final idFinder = Finder(filter: Filter.byKey(podcast.id));
        final guid = podcast.guid!.replaceFirst('http:', 'https:');
        final episodeFinder = Finder(
          filter: Filter.equals('pguid', podcast.guid),
        );

        log.fine('Upgrading GUID ${podcast.guid} - to $guid');

        final upgradedPodcast = Podcast(
          id: podcast.id,
          guid: guid,
          url: podcast.url,
          link: podcast.link,
          title: podcast.title,
          description: podcast.description,
          imageUrl: podcast.imageUrl,
          thumbImageUrl: podcast.thumbImageUrl,
          copyright: podcast.copyright,
          persons: podcast.persons,
          lastUpdated: DateTime.now(),
        );

        final episodeData = await _episodeStore.find(db, finder: episodeFinder);
        final episodes =
            episodeData.map((e) => Episode.fromMap(e.key, e.value)).toList();

        // Now upgrade episodes
        for (final e in episodes) {
          e.pguid = guid;
          log.fine(
            'Updating episode guid for ${e.title} from ${e.pguid} to $guid',
          );

          final epf = Finder(filter: Filter.byKey(e.id));
          await _episodeStore.update(db, e.toMap(), finder: epf);
        }

        upgradedPodcast.episodes = episodes;
        await _podcastStore.update(
          db,
          upgradedPodcast.toMap(),
          finder: idFinder,
        );
      }
    }
  }

  @override
  Stream<EpisodeState> get episodeListener => _episodeSubject.stream;

  @override
  Stream<Podcast> get podcastListener => _podcastSubject.stream;
}

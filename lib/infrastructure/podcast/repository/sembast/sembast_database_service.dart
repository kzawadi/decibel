// Copyright 2023 Kelvin Zawadi. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

typedef DatabaseUpgrade = Future<void> Function(Database, int, int);

/// Provides a database instance to other services and handles the opening
/// of the Sembast DB.
class DatabaseService {
  DatabaseService(
    this.databaseName, {
    required this.version,
    this.upgraderCallback,
  });
  Completer<Database>? _databaseCompleter;
  String databaseName;
  int version = 1;
  DatabaseUpgrade? upgraderCallback;

  Future<Database> get database async {
    if (_databaseCompleter == null) {
      _databaseCompleter = Completer();
      await _openDatabase();
    }

    return _databaseCompleter!.future;
  }

  Future<void> _openDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, databaseName);
    final database = await databaseFactoryIo.openDatabase(
      dbPath,
      version: version,
      onVersionChanged: (db, oldVersion, newVersion) async {
        if (upgraderCallback != null) {
          await upgraderCallback!(db, oldVersion, newVersion);
        }
      },
    );

    _databaseCompleter!.complete(database);
  }
}

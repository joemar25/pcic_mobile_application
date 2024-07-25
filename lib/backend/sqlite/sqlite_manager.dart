import 'package:flutter/foundation.dart';

import '/backend/sqlite/init.dart';
import 'queries/read.dart';

import 'package:sqflite/sqflite.dart';
export 'queries/read.dart';
export 'queries/update.dart';

class SQLiteManager {
  SQLiteManager._();

  static SQLiteManager? _instance;
  static SQLiteManager get instance => _instance ??= SQLiteManager._();

  static late Database _database;
  Database get database => _database;

  static Future initialize() async {
    if (kIsWeb) {
      return;
    }
    _database = await initializeDatabaseFromDbFile(
      'db_sync',
      'pcic_offline_db.db',
    );
  }

  /// START READ QUERY CALLS

  Future<List<SelectAllTasksRow>> selectAllTasks() => performSelectAllTasks(
        _database,
      );

  Future<List<SelectAllUsersRow>> selectAllUsers() => performSelectAllUsers(
        _database,
      );

  Future<List<SelectAllSeedsRow>> selectAllSeeds() => performSelectAllSeeds(
        _database,
      );

  Future<List<SelectAllPpirFormsRow>> selectAllPpirForms() =>
      performSelectAllPpirForms(
        _database,
      );

  Future<List<SelectAllMessagesRow>> selectAllMessages() =>
      performSelectAllMessages(
        _database,
      );

  Future<List<SelectAllSyncLogRow>> selectAllSyncLog() =>
      performSelectAllSyncLog(
        _database,
      );

  /// END READ QUERY CALLS

  /// START UPDATE QUERY CALLS

  /// END UPDATE QUERY CALLS
}

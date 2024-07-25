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

  Future<List<SelectTasksRow>> selectTasks() => performSelectTasks(
        _database,
      );

  Future<List<SelectUsersRow>> selectUsers() => performSelectUsers(
        _database,
      );

  Future<List<SelectSeedsRow>> selectSeeds() => performSelectSeeds(
        _database,
      );

  Future<List<SelectPpirFormsRow>> selectPpirForms() => performSelectPpirForms(
        _database,
      );

  Future<List<SelectMessagesRow>> selectMessages() => performSelectMessages(
        _database,
      );

  Future<List<SelectSyncLogsRow>> selectSyncLogs() => performSelectSyncLogs(
        _database,
      );

  Future<List<SelectAttemptsRow>> selectAttempts() => performSelectAttempts(
        _database,
      );

  Future<List<SelectProfileRow>> selectProfile({
    String? email,
  }) =>
      performSelectProfile(
        _database,
        email: email,
      );

  /// END READ QUERY CALLS

  /// START UPDATE QUERY CALLS

  /// END UPDATE QUERY CALLS
}

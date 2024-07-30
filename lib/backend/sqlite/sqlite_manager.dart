import 'package:flutter/foundation.dart';

import '/backend/sqlite/init.dart';
import 'queries/read.dart';
import 'queries/update.dart';

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

  Future updateAttemptStatus({
    String? comments,
    bool? updatedat,
    bool? syncstatus,
    bool? isdirty,
  }) =>
      performUpdateAttemptStatus(
        _database,
        comments: comments,
        updatedat: updatedat,
        syncstatus: syncstatus,
        isdirty: isdirty,
      );

  Future updateSyncStatus({
    String? id,
    bool? syncstatus,
    DateTime? lastsyncedat,
    DateTime? updatedat,
  }) =>
      performUpdateSyncStatus(
        _database,
        id: id,
        syncstatus: syncstatus,
        lastsyncedat: lastsyncedat,
        updatedat: updatedat,
      );

  Future updatePPIRBasicInfo({
    String? ppirfarmername,
    String? ppiraddress,
    String? ppirfarmertype,
    int? ppirmobileno,
    String? ppirgroupname,
    String? ppirgroupaddress,
    DateTime? updatedat,
    String? taskid,
  }) =>
      performUpdatePPIRBasicInfo(
        _database,
        ppirfarmername: ppirfarmername,
        ppiraddress: ppiraddress,
        ppirfarmertype: ppirfarmertype,
        ppirmobileno: ppirmobileno,
        ppirgroupname: ppirgroupname,
        ppirgroupaddress: ppirgroupaddress,
        updatedat: updatedat,
        taskid: taskid,
      );

  Future updatePPIRLocation({
    String? ppirsouth,
    String? ppirnorth,
    String? ppireast,
    String? ppirwest,
    String? ppirfarmloc,
    DateTime? isupdatedat,
    bool? isdirty,
    String? taskid,
  }) =>
      performUpdatePPIRLocation(
        _database,
        ppirsouth: ppirsouth,
        ppirnorth: ppirnorth,
        ppireast: ppireast,
        ppirwest: ppirwest,
        ppirfarmloc: ppirfarmloc,
        isupdatedat: isupdatedat,
        isdirty: isdirty,
        taskid: taskid,
      );

  Future updatePPIRCropInfo({
    String? ppirvariety,
    String? ppirareaaci,
    String? ppirstagecrop,
    String? ppirareaact,
    DateTime? updatedat,
    DateTime? isdirty,
    String? taskid,
  }) =>
      performUpdatePPIRCropInfo(
        _database,
        ppirvariety: ppirvariety,
        ppirareaaci: ppirareaaci,
        ppirstagecrop: ppirstagecrop,
        ppirareaact: ppirareaact,
        updatedat: updatedat,
        isdirty: isdirty,
        taskid: taskid,
      );

  /// END UPDATE QUERY CALLS
}

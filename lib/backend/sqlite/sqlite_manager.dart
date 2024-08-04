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

  Future<List<SELECTTASKSBaseOnStatusRow>> sELECTTASKSBaseOnStatus({
    String? status,
  }) =>
      performSELECTTASKSBaseOnStatus(
        _database,
        status: status,
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

  Future<List<DashboardReadQueryRow>> dashboardReadQuery() =>
      performDashboardReadQuery(
        _database,
      );

  Future<List<GetLastSyncTimestampRow>> getLastSyncTimestamp() =>
      performGetLastSyncTimestamp(
        _database,
      );

  Future<List<GetQueuedChangesRow>> getQueuedChanges() =>
      performGetQueuedChanges(
        _database,
      );

  Future<List<GetModifiedRecordsRow>> getModifiedRecords() =>
      performGetModifiedRecords(
        _database,
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
    String? ppirmobileno,
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
    bool? isdirty,
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

  Future updateTask({
    String? id,
    String? tasknumber,
    String? servicegroup,
    String? servicetypes,
    String? priority,
    String? assignee,
    String? fileid,
    DateTime? dateadded,
    DateTime? dateaccess,
    bool? status,
    String? tasktype,
    int? attemptcount,
    DateTime? updatedat,
    bool? isdeleted,
    bool? syncstatus,
    DateTime? lastsyncedat,
    String? localid,
    bool? isdirty,
    bool? isupdating,
  }) =>
      performUpdateTask(
        _database,
        id: id,
        tasknumber: tasknumber,
        servicegroup: servicegroup,
        servicetypes: servicetypes,
        priority: priority,
        assignee: assignee,
        fileid: fileid,
        dateadded: dateadded,
        dateaccess: dateaccess,
        status: status,
        tasktype: tasktype,
        attemptcount: attemptcount,
        updatedat: updatedat,
        isdeleted: isdeleted,
        syncstatus: syncstatus,
        lastsyncedat: lastsyncedat,
        localid: localid,
        isdirty: isdirty,
        isupdating: isupdating,
      );

  Future updateUsers({
    String? id,
    String? role,
    String? email,
    String? photourl,
    String? inspectorname,
    String? mobilenumber,
    bool? isonline,
    String? authuserid,
    String? createduserid,
    String? createdat,
    String? updatedat,
    String? regionid,
  }) =>
      performUpdateUsers(
        _database,
        id: id,
        role: role,
        email: email,
        photourl: photourl,
        inspectorname: inspectorname,
        mobilenumber: mobilenumber,
        isonline: isonline,
        authuserid: authuserid,
        createduserid: createduserid,
        createdat: createdat,
        updatedat: updatedat,
        regionid: regionid,
      );

  Future updateDashboardQuery({
    String? role,
    String? email,
    String? photourl,
    String? inspectorname,
    String? mobilenumber,
    bool? isonline,
    String? authuserid,
    String? createduserid,
    DateTime? updatedat,
    String? regionid,
  }) =>
      performUpdateDashboardQuery(
        _database,
        role: role,
        email: email,
        photourl: photourl,
        inspectorname: inspectorname,
        mobilenumber: mobilenumber,
        isonline: isonline,
        authuserid: authuserid,
        createduserid: createduserid,
        updatedat: updatedat,
        regionid: regionid,
      );

  Future insertUpdateSyncStatus({
    String? tablename,
    DateTime? lastsynctimestamp,
  }) =>
      performInsertUpdateSyncStatus(
        _database,
        tablename: tablename,
        lastsynctimestamp: lastsynctimestamp,
      );

  Future addToSyncQueue({
    String? tablename,
    String? recordid,
    String? action,
    String? data,
    DateTime? timestamp,
  }) =>
      performAddToSyncQueue(
        _database,
        tablename: tablename,
        recordid: recordid,
        action: action,
        data: data,
        timestamp: timestamp,
      );

  Future removeFromSyncQueue({
    String? id,
  }) =>
      performRemoveFromSyncQueue(
        _database,
        id: id,
      );

  Future updateLastModifiedTimestamp({
    DateTime? lastmodified,
    String? id,
  }) =>
      performUpdateLastModifiedTimestamp(
        _database,
        lastmodified: lastmodified,
        id: id,
      );

  Future bulkInsert({
    String? id,
    String? title,
    String? status,
  }) =>
      performBulkInsert(
        _database,
        id: id,
        title: title,
        status: status,
      );

  Future deleteRecords({
    String? id,
  }) =>
      performDeleteRecords(
        _database,
        id: id,
      );

  /// END UPDATE QUERY CALLS
}

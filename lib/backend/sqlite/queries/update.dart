import 'package:sqflite/sqflite.dart';

/// BEGIN UPDATEATTEMPTSTATUS
Future performUpdateAttemptStatus(
  Database database, {
  String? comments,
  bool? updatedat,
  bool? syncstatus,
  bool? isdirty,
}) {
  const query = '''
UPDATE attempts
SET status = ?, 
    comments = ?, 
    updated_at = ?, 
    sync_status = ?, 
    is_dirty = ?
WHERE id = ?
''';
  return database.rawQuery(query);
}

/// END UPDATEATTEMPTSTATUS

/// BEGIN UPDATESYNCSTATUS
Future performUpdateSyncStatus(
  Database database, {
  String? id,
  bool? syncstatus,
  DateTime? lastsyncedat,
  DateTime? updatedat,
}) {
  const query = '''
UPDATE attempts
SET sync_status = ?,
    last_synced_at = ?,
    is_dirty = false,
    updated_at = ?
WHERE id = ?
''';
  return database.rawQuery(query);
}

/// END UPDATESYNCSTATUS

/// BEGIN UPDATEPPIRBASICINFO
Future performUpdatePPIRBasicInfo(
  Database database, {
  String? ppirfarmername,
  String? ppiraddress,
  String? ppirfarmertype,
  String? ppirmobileno,
  String? ppirgroupname,
  String? ppirgroupaddress,
  DateTime? updatedat,
  String? taskid,
}) {
  const query = '''
UPDATE ppir_forms
SET ppir_farmername = ?,
    ppir_address = ?,
    ppir_farmer_type = ?,
    ppir_mobileno = ?,
    ppir_group_name = ?,
    ppir_group_address = ?,
    updated_at = ?,
    is_dirty = true
WHERE task_id = ?
''';
  return database.rawQuery(query);
}

/// END UPDATEPPIRBASICINFO

/// BEGIN UPDATEPPIRLOCATION
Future performUpdatePPIRLocation(
  Database database, {
  String? ppirsouth,
  String? ppirnorth,
  String? ppireast,
  String? ppirwest,
  String? ppirfarmloc,
  DateTime? isupdatedat,
  bool? isdirty,
  String? taskid,
}) {
  const query = '''
UPDATE ppir_forms
SET ppir_north = ?,
    ppir_south = ?,
    ppir_east = ?,
    ppir_west = ?,
    ppir_farmloc = ?,
    updated_at = ?,
    is_dirty = true
WHERE task_id = ?
''';
  return database.rawQuery(query);
}

/// END UPDATEPPIRLOCATION

/// BEGIN UPDATEPPIRCROPINFO
Future performUpdatePPIRCropInfo(
  Database database, {
  String? ppirvariety,
  String? ppirareaaci,
  String? ppirstagecrop,
  String? ppirareaact,
  DateTime? updatedat,
  bool? isdirty,
  String? taskid,
}) {
  const query = '''
UPDATE ppir_forms
SET ppir_variety = ?,
    ppir_stage_crop = ?,
    ppir_area_aci = ?,
    ppir_area_act = ?,
    updated_at = ?,
    is_dirty = true
WHERE task_id = ?
''';
  return database.rawQuery(query);
}

/// END UPDATEPPIRCROPINFO

/// BEGIN UPDATETASK
Future performUpdateTask(
  Database database, {
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
}) {
  const query = '''
UPDATE tasks
SET 
  task_number = ?,
  service_group = ?,
  service_type = ?,
  priority = ?,
  assignee = ?,
  file_id = ?,
  date_added = ?,
  date_access = ?,
  status = ?,
  task_type = ?,
  attempt_count = ?,
  created_at = ?,
  updated_at = ?,
  is_deleted = ?,
  sync_status = ?,
  last_synced_at = ?,
  local_id = ?,
  is_dirty = ?,
  is_updating = ?
WHERE id = ?
''';
  return database.rawQuery(query);
}

/// END UPDATETASK

/// BEGIN UPDATEUSERS
Future performUpdateUsers(
  Database database, {
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
}) {
  const query = '''
UPDATE users
SET 
  role = ?,
  email = ?,
  photo_url = ?,
  inspector_name = ?,
  mobile_number = ?,
  is_online = ?,
  auth_user_id = ?,
  created_user_id = ?,
  created_at = ?,
  updated_at = ?,
  region_id = ?
WHERE id = ?
''';
  return database.rawQuery(query);
}

/// END UPDATEUSERS

/// BEGIN UPDATE DASHBOARD QUERY
Future performUpdateDashboardQuery(
  Database database, {
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
}) {
  const query = '''
UPDATE users
SET 
  role = ?,
  email = ?,
  photo_url = ?,
  inspector_name = ?,
  mobile_number = ?,
  is_online = ?,
  auth_user_id = ?,
  created_user_id = ?,
  updated_at = ?,
  region_id = ?
WHERE id = ?
''';
  return database.rawQuery(query);
}

/// END UPDATE DASHBOARD QUERY

/// BEGIN INSERTUPDATE SYNC STATUS
Future performInsertUpdateSyncStatus(
  Database database, {
  String? tablename,
  DateTime? lastsynctimestamp,
}) {
  const query = '''
INSERT OR REPLACE INTO sync_status (table_name, last_sync_timestamp)
VALUES (?, ?);
''';
  return database.rawQuery(query);
}

/// END INSERTUPDATE SYNC STATUS

/// BEGIN ADD TO SYNC QUEUE
Future performAddToSyncQueue(
  Database database, {
  String? tablename,
  String? recordid,
  String? action,
  String? data,
  DateTime? timestamp,
}) {
  const query = '''
INSERT INTO sync_queue (table_name, record_id, action, data, timestamp)
VALUES (?, ?, ?, ?, ?);
''';
  return database.rawQuery(query);
}

/// END ADD TO SYNC QUEUE

/// BEGIN REMOVE FROM SYNC QUEUE
Future performRemoveFromSyncQueue(
  Database database, {
  String? id,
}) {
  const query = '''
DELETE FROM sync_queue WHERE id = ?;
''';
  return database.rawQuery(query);
}

/// END REMOVE FROM SYNC QUEUE

/// BEGIN UPDATE LAST MODIFIED TIMESTAMP
Future performUpdateLastModifiedTimestamp(
  Database database, {
  DateTime? lastmodified,
  String? id,
}) {
  const query = '''
UPDATE tasks SET ..., last_modified = ? WHERE id = ?;
''';
  return database.rawQuery(query);
}

/// END UPDATE LAST MODIFIED TIMESTAMP

/// BEGIN TASK INSERT
Future performTaskInsert(
  Database database, {
  String? id,
  String? taskNumber,
  String? serviceGroup,
  String? status,
  String? serviceType,
  String? priority,
  String? assignee,
  String? dateAdded,
  String? dateAccess,
  String? fileId,
}) {
  final query = '''
INSERT OR REPLACE INTO tasks (id, task_number, service_group, status, service_type, priority, assignee, file_id, date_added, date_access)
VALUES ('$id', '$taskNumber', '$serviceGroup', '$status', '$serviceType', '$priority', '$assignee', '$fileId', '$dateAdded', '$dateAccess')
''';
  return database.rawQuery(query);
}

/// END TASK INSERT

/// BEGIN DELETE RECORDS
Future performDeleteRecords(
  Database database, {
  String? id,
}) {
  const query = '''
DELETE FROM tasks WHERE id = ?;
''';
  return database.rawQuery(query);
}

/// END DELETE RECORDS

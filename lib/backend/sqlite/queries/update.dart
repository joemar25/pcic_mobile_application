import 'package:sqflite/sqflite.dart';

/// BEGIN UPDATEATTEMPTSTATUS
Future performUpdateAttemptStatus(
  Database database, {
  String? comments,
  bool? updatedat,
  bool? syncstatus,
  bool? isdirty,
}) {
  final query = '''
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
  final query = '''
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
  int? ppirmobileno,
  String? ppirgroupname,
  String? ppirgroupaddress,
  DateTime? updatedat,
  String? taskid,
}) {
  final query = '''
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
  final query = '''
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
  DateTime? isdirty,
  String? taskid,
}) {
  final query = '''
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
  final query = '''
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
  final query = '''
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
  final query = '''
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

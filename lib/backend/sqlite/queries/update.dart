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
  int? ppirmobileno,
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
  DateTime? isdirty,
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

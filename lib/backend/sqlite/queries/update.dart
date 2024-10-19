import 'package:sqflite/sqflite.dart';

/// BEGIN INSERT OR REPLACE TASK RECORD
Future performInsertOrReplaceTaskRecord(
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

/// END INSERT OR REPLACE TASK RECORD

/// BEGIN INSERT OR REPLACE PPIR FORM RECORD
Future performInsertOrReplacePPIRFormRecord(
  Database database, {
  String? taskId,
  String? ppirAssignmentId,
  String? gpx,
  String? ppirInsuranceId,
  String? ppirFarmerName,
  String? ppirAddress,
  String? ppirFarmerType,
  String? ppirMobileNo,
  String? ppirGroupName,
  String? ppirGroupAddress,
  String? ppirLenderName,
  String? ppirLenderAddress,
  String? ppirCICNo,
  String? ppirFarmLoc,
  String? ppirNorth,
  String? ppirSouth,
  String? ppirEast,
  String? ppirWest,
  String? ppirAtt1,
  String? ppirAtt2,
  String? ppirAtt3,
  String? ppirAtt4,
  String? ppirAreaAci,
  String? ppirAreaAct,
  String? ppirDopdsAci,
  String? ppirDopdsAct,
  String? ppirDoptpAci,
  String? ppirDoptpAct,
  String? ppirSvpAci,
  String? ppirSvpAct,
  String? ppirVariety,
  String? ppirStageCrop,
  String? ppirRemarks,
  String? ppirNameInsured,
  String? ppirNameIUIA,
  String? ppirSigInsured,
  String? ppirSigIUIA,
  String? trackLastCoord,
  String? trackDateTime,
  String? trackTotalArea,
  String? trackTotalDistance,
  String? createdAt,
  String? updatedAt,
  String? syncStatus,
  String? lastSyncedAt,
  String? localId,
  String? isDirty,
  String? capturedArea,
}) {
  final query = '''
INSERT OR REPLACE INTO ppir_forms (
    task_id, ppir_assignmentid, gpx, ppir_insuranceid, ppir_farmername, 
    ppir_address, ppir_farmertype, ppir_mobileno, ppir_groupname, 
    ppir_groupaddress, ppir_lendername, ppir_lenderaddress, ppir_cicno, 
    ppir_farmloc, ppir_north, ppir_south, ppir_east, ppir_west, ppir_att_1, 
    ppir_att_2, ppir_att_3, ppir_att_4, ppir_area_aci, ppir_area_act, 
    ppir_dopds_aci, ppir_dopds_act, ppir_doptp_aci, ppir_doptp_act, 
    ppir_svp_aci, ppir_svp_act, ppir_variety, ppir_stagecrop, ppir_remarks, 
    ppir_name_insured, ppir_name_iuia, ppir_sig_insured, ppir_sig_iuia, 
    track_last_coord, track_date_time, track_total_area, track_total_distance, 
    created_at, updated_at, sync_status, last_synced_at, local_id, is_dirty, captured_area
) VALUES (
    '$taskId', '$ppirAssignmentId', '$gpx', '$ppirInsuranceId', '$ppirFarmerName', 
    '$ppirAddress', '$ppirFarmerType', '$ppirMobileNo', '$ppirGroupName', 
    '$ppirGroupAddress', '$ppirLenderName', '$ppirLenderAddress', '$ppirCICNo', 
    '$ppirFarmLoc', '$ppirNorth', '$ppirSouth', '$ppirEast', '$ppirWest', 
    '$ppirAtt1', '$ppirAtt2', '$ppirAtt3', '$ppirAtt4', '$ppirAreaAci', 
    '$ppirAreaAct', '$ppirDopdsAci', '$ppirDopdsAct', '$ppirDoptpAci', 
    '$ppirDoptpAct', '$ppirSvpAci', '$ppirSvpAct', '$ppirVariety', 
    '$ppirStageCrop', '$ppirRemarks', '$ppirNameInsured', '$ppirNameIUIA', 
    '$ppirSigInsured', '$ppirSigIUIA', '$trackLastCoord', '$trackDateTime', 
    '$trackTotalArea', '$trackTotalDistance', '$createdAt', '$updatedAt', 
    '$syncStatus', '$lastSyncedAt', '$localId', '$isDirty', '$capturedArea'
);
''';
  return database.rawQuery(query);
}

/// END INSERT OR REPLACE PPIR FORM RECORD

/// BEGIN CLEAR GPX DATA IN PPIR FORM BY TASK ID
Future performClearGPXDataInPPIRFormByTaskID(
  Database database, {
  String? taskId,
  bool? isDirty,
}) {
  final query = '''
UPDATE ppir_forms
SET gpx =  ''
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END CLEAR GPX DATA IN PPIR FORM BY TASK ID

/// BEGIN UPDATE PPIR FORM DETAILS AND DIRTY FLAG BY TASK ID
Future performUpdatePPIRFormDetailsAndDirtyFlagByTaskID(
  Database database, {
  String? taskId,
  String? ppirSvpAct,
  String? ppirDopdsAct,
  String? ppirDoptpAct,
  String? ppirRemarks,
  String? ppirNameInsured,
  String? ppirNameIuia,
  String? ppirFarmloc,
  String? ppirAreaAct,
  String? ppirVariety,
  bool? isDirty,
  String? capturedArea,
}) {
  final query = '''
UPDATE ppir_forms
SET 
  ppir_svp_act = '$ppirSvpAct',
  ppir_dopds_act = '$ppirDopdsAct',
  ppir_doptp_act = '$ppirDoptpAct',
  ppir_remarks = '$ppirRemarks',
  ppir_name_insured = '$ppirNameInsured',
  ppir_name_iuia = '$ppirNameIuia',
  ppir_farmloc = '$ppirFarmloc',
  ppir_area_act = '$ppirAreaAct',
  ppir_variety = '$ppirVariety',
  captured_area = '$capturedArea',
  is_dirty = $isDirty
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE PPIR FORM DETAILS AND DIRTY FLAG BY TASK ID

/// BEGIN UPDATE TASK STATUS AND DIRTY FLAG BY ID
Future performUpdateTaskStatusAndDirtyFlagByID(
  Database database, {
  String? taskId,
  String? status,
  bool? isDirty,
}) {
  final query = '''
UPDATE tasks
SET 
  status = '$status',
  is_dirty = '$isDirty'
WHERE id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE TASK STATUS AND DIRTY FLAG BY ID

/// BEGIN UPDATE PPIR FORM DIRTY FLAG BY TASK ID
Future performUpdatePPIRFormDirtyFlagByTaskID(
  Database database, {
  String? taskId,
  bool? isDirty,
}) {
  final query = '''
UPDATE ppir_forms
SET is_dirty = '$isDirty'
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE PPIR FORM DIRTY FLAG BY TASK ID

/// BEGIN UPDATE PPIR FORM GPX DATA BY TASK ID
Future performUpdatePPIRFormGPXDataByTaskID(
  Database database, {
  String? taskId,
  String? gpx,
  bool? isDirty,
}) {
  final query = '''
UPDATE ppir_forms
SET 
  gpx = '$gpx',
  is_dirty = '$isDirty'
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE PPIR FORM GPX DATA BY TASK ID

/// BEGIN UPDATE PPIR FORM TRACKING DATA BY TASK ID
Future performUpdatePPIRFormTrackingDataByTaskID(
  Database database, {
  String? taskId,
  String? trackLastCoord,
  String? trackDateTime,
  String? trackTotalArea,
  String? trackTotalDistance,
  String? gpx,
  bool? isDirty,
}) {
  final query = '''
UPDATE ppir_forms
SET 
  gpx = '$gpx',
  track_last_coord = '$trackLastCoord',
  track_date_time = '$trackDateTime',
  track_total_area = '$trackTotalArea',
  track_total_distance = '$trackTotalDistance',
  is_dirty = '$isDirty'
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE PPIR FORM TRACKING DATA BY TASK ID

/// BEGIN UPDATE PPIR IUAI SIGNATURE BY TASK ID
Future performUpdatePPIRIUAISignatureByTaskID(
  Database database, {
  String? taskId,
  String? signatureBlob,
}) {
  final query = '''
UPDATE ppir_forms
SET  ppir_sig_iuia = '$signatureBlob'
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE PPIR IUAI SIGNATURE BY TASK ID

/// BEGIN UPDATE PPIR INSURED SIGNATURE BY TASK ID
Future performUpdatePPIRInsuredSignatureByTaskID(
  Database database, {
  String? taskId,
  String? signatureBlob,
}) {
  final query = '''
UPDATE ppir_forms
SET  ppir_sig_insured = '$signatureBlob'
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE PPIR INSURED SIGNATURE BY TASK ID

/// BEGIN UPDATE INSPECTOR NAME BY USER ID
Future performUpdateInspectorNameByUserID(
  Database database, {
  String? id,
  String? inspectorName,
}) {
  final query = '''
UPDATE users
SET  inspector_name = '$inspectorName'
WHERE id = '$id';
''';
  return database.rawQuery(query);
}

/// END UPDATE INSPECTOR NAME BY USER ID

/// BEGIN DELETE ALL RECORDS FROM TASKS AND PPIR FORMS
Future performDeleteAllRecordsFromTasksAndPPIRForms(
  Database database,
) {
  const query = '''
DELETE FROM tasks;
DELETE FROM ppir_forms;
''';
  return database.rawQuery(query);
}

/// END DELETE ALL RECORDS FROM TASKS AND PPIR FORMS

/// BEGIN INSERT OR REPLACE USER DATA
Future performInsertOrReplaceUserData(
  Database database, {
  String? id,
  String? role,
  String? email,
  String? photoUrl,
  String? inspectorName,
  String? mobileNumber,
  String? authUserId,
  String? createdAt,
  String? updatedAt,
  String? regionId,
}) {
  final query = '''
INSERT OR REPLACE INTO users (
    id,
    role,
    email,
    photo_url,
    inspector_name,
    mobile_number,
    auth_user_id,
    created_at,
    updated_at,
    region_id
) 
VALUES (
    '$id', 
    '$role', 
    '$email', 
    '$photoUrl', 
    '$inspectorName', 
    '$mobileNumber', 
    '$authUserId', 
    '$createdAt', 
    '$updatedAt', 
    '$regionId'
);

''';
  return database.rawQuery(query);
}

/// END INSERT OR REPLACE USER DATA

/// BEGIN UPDATE PPIR FORM SYNC STATUS AND DIRTY FLAG BY TASK ID
Future performUpdatePPIRFormSyncStatusAndDirtyFlagByTaskID(
  Database database, {
  String? taskId,
  String? syncStatus,
  String? isDirty,
}) {
  final query = '''
UPDATE ppir_forms
SET 
  sync_status = '$syncStatus',
  is_dirty = '$isDirty'
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE PPIR FORM SYNC STATUS AND DIRTY FLAG BY TASK ID

/// BEGIN UPDATE TASK SYNC STATUS AND DIRTY FLAG BY ID
Future performUpdateTaskSyncStatusAndDirtyFlagByID(
  Database database, {
  String? taskId,
  String? syncStatus,
  String? isDirty,
}) {
  final query = '''
UPDATE tasks
SET 
  sync_status = '$syncStatus',
  is_dirty = '$isDirty'
WHERE id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE TASK SYNC STATUS AND DIRTY FLAG BY ID

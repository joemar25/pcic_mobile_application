import '/backend/sqlite/queries/sqlite_row.dart';
import 'package:sqflite/sqflite.dart';

Future<List<T>> _readQuery<T>(
  Database database,
  String query,
  T Function(Map<String, dynamic>) create,
) =>
    database.rawQuery(query).then((r) => r.map((e) => create(e)).toList());

/// BEGIN RETRIEVE ALL USERS BY REGION ID
Future<List<RetrieveAllUsersByRegionIDRow>> performRetrieveAllUsersByRegionID(
  Database database, {
  String? regionId,
}) {
  final query = '''
SELECT * FROM users WHERE region_id='$regionId'
''';
  return _readQuery(database, query, (d) => RetrieveAllUsersByRegionIDRow(d));
}

class RetrieveAllUsersByRegionIDRow extends SqliteRow {
  RetrieveAllUsersByRegionIDRow(super.data);

  String? get id => data['id'] as String?;
  String? get role => data['role'] as String?;
  String? get email => data['email'] as String?;
  String? get photoUrl => data['photo_url'] as String?;
  String? get inspectorName => data['inspector_name'] as String?;
  String? get mobileNumber => data['mobile_number'] as String?;
  bool? get isOnline => data['is_online'] as bool?;
  String? get authUserId => data['auth_user_id'] as String?;
  String? get createdUserId => data['created_user_id'] as String?;
  DateTime? get createdAt => data['created_at'] as DateTime?;
  DateTime? get updatedAt => data['updated_at'] as DateTime?;
  String? get regionId => data['region_id'] as String?;
}

/// END RETRIEVE ALL USERS BY REGION ID

/// BEGIN RETRIEVE ALL PPIR FORMS BY TASK ID
Future<List<RetrieveAllPPIRFormsByTaskIDRow>>
    performRetrieveAllPPIRFormsByTaskID(
  Database database, {
  String? taskId,
}) {
  final query = '''
SELECT * FROM ppir_forms WHERE task_id='$taskId'
''';
  return _readQuery(database, query, (d) => RetrieveAllPPIRFormsByTaskIDRow(d));
}

class RetrieveAllPPIRFormsByTaskIDRow extends SqliteRow {
  RetrieveAllPPIRFormsByTaskIDRow(super.data);

  String? get taskId => data['task_id'] as String?;
  String? get ppirAssignmentid => data['ppir_assignmentid'] as String?;
  String? get ppirInsuranceid => data['ppir_insuranceid'] as String?;
  String? get ppirFarmername => data['ppir_farmername'] as String?;
  String? get ppirAddress => data['ppir_address'] as String?;
  String? get ppirFarmertype => data['ppir_farmertype'] as String?;
  String? get ppirMobileno => data['ppir_mobileno'] as String?;
  String? get ppirGroupname => data['ppir_groupname'] as String?;
  String? get ppirGroupadress => data['ppir_groupadress'] as String?;
  String? get ppirLendername => data['ppir_lendername'] as String?;
  String? get ppirLenderaddress => data['ppir_lenderaddress'] as String?;
  String? get ppirCicno => data['ppir_cicno'] as String?;
  String? get ppirFarmloc => data['ppir_farmloc'] as String?;
  String? get ppirNorth => data['ppir_north'] as String?;
  String? get ppirSouth => data['ppir_south'] as String?;
  String? get ppirEast => data['ppir_east'] as String?;
  String? get ppirWest => data['ppir_west'] as String?;
  String? get ppirAtt1 => data['ppir_att_1'] as String?;
  String? get ppirAtt2 => data['ppir_att_2'] as String?;
  String? get ppirAtt3 => data['ppir_att_3'] as String?;
  String? get ppirAtt4 => data['ppir_att_4'] as String?;
  String? get ppirAreaAci => data['ppir_area_aci'] as String?;
  String? get ppirAreaAct => data['ppir_area_act'] as String?;
  String? get ppirDopdsAci => data['ppir_dopds_aci'] as String?;
  String? get ppirDopdsAct => data['ppir_dopds_act'] as String?;
  String? get ppirDoptpAci => data['ppir_doptp_aci'] as String?;
  String? get ppirDoptpAct => data['ppir_doptp_act'] as String?;
  String? get ppirSvpAci => data['ppir_svp_aci'] as String?;
  String? get ppirSvpAct => data['ppir_svp_act'] as String?;
  String? get ppirVariety => data['ppir_variety'] as String?;
  String? get ppirStagecrop => data['ppir_stagecrop'] as String?;
  String? get ppirRemarks => data['ppir_remarks'] as String?;
  String? get ppirNameInsured => data['ppir_name_insured'] as String?;
  String? get ppirNameIuia => data['ppir_name_iuia'] as String?;
  String? get ppirSigInsured => data['ppir_sig_insured'] as String?;
  String? get trackLastCoord => data['track_last_coord'] as String?;
  String? get trackDateTime => data['track_date_time'] as String?;
  String? get trackTotalArea => data['track_total_area'] as String?;
  String? get trackTotalDistance => data['track_total_distance'] as String?;
  DateTime? get createdAt => data['created_at'] as DateTime?;
  DateTime? get updatedAt => data['updated_at'] as DateTime?;
  String? get lastSyncedAt => data['last_synced_at'] as String?;
  String? get capturedArea => data['captured_area'] as String?;
  bool? get isDirty => data['is_dirty'] as bool?;
  String? get syncStatus => data['sync_status'] as String?;
  String? get ppirSigIuia => data['ppir_sig_iuia'] as String?;
  String? get gpx => data['gpx'] as String?;
}

/// END RETRIEVE ALL PPIR FORMS BY TASK ID

/// BEGIN RETRIEVE ALL MESSAGES
Future<List<RetrieveAllMessagesRow>> performRetrieveAllMessages(
  Database database,
) {
  const query = '''
SELECT * FROM messages
''';
  return _readQuery(database, query, (d) => RetrieveAllMessagesRow(d));
}

class RetrieveAllMessagesRow extends SqliteRow {
  RetrieveAllMessagesRow(super.data);

  String? get id => data['id'] as String?;
  String? get chatId => data['chat_id'] as String?;
  String? get senderName => data['sender_name'] as String?;
  String? get receiverName => data['receiver_name'] as String?;
  String? get content => data['content'] as String?;
  String? get attachmentUrl => data['attachment_url'] as String?;
  DateTime? get timestamp => data['timestamp'] as DateTime?;
  bool? get isRead => data['is_read'] as bool?;
  String? get syncStatus => data['sync_status'] as String?;
  DateTime? get lastSyncedAt => data['last_synced_at'] as DateTime?;
  String? get localId => data['local_id'] as String?;
  bool? get isDirty => data['is_dirty'] as bool?;
}

/// END RETRIEVE ALL MESSAGES

/// BEGIN RETRIEVE ALL SYNC LOGS
Future<List<RetrieveAllSyncLogsRow>> performRetrieveAllSyncLogs(
  Database database,
) {
  const query = '''
SELECT * FROM sync_log
''';
  return _readQuery(database, query, (d) => RetrieveAllSyncLogsRow(d));
}

class RetrieveAllSyncLogsRow extends SqliteRow {
  RetrieveAllSyncLogsRow(super.data);

  String? get id => data['id'] as String?;
  DateTime? get syncStartTime => data['sync_start_time'] as DateTime?;
  DateTime? get syncEndTime => data['sync_end_time'] as DateTime?;
  String? get syncStatus => data['sync_status'] as String?;
  int? get recordsSynced => data['records_synced'] as int?;
  String? get errorMessage => data['error_message'] as String?;
  String? get deviceIdentifier => data['device_identifier'] as String?;
}

/// END RETRIEVE ALL SYNC LOGS

/// BEGIN RETRIEVE ALL ATTEMPTS
Future<List<RetrieveAllAttemptsRow>> performRetrieveAllAttempts(
  Database database,
) {
  const query = '''
SELECT * FROM attempts
''';
  return _readQuery(database, query, (d) => RetrieveAllAttemptsRow(d));
}

class RetrieveAllAttemptsRow extends SqliteRow {
  RetrieveAllAttemptsRow(super.data);

  String? get id => data['id'] as String?;
  String? get taskId => data['task_id'] as String?;
  String? get attemptNumber => data['attempt_number'] as String?;
  DateTime? get attemptDate => data['attempt_date'] as DateTime?;
  String? get status => data['status'] as String?;
  String? get comments => data['comments'] as String?;
  DateTime? get createdAt => data['created_at'] as DateTime?;
  DateTime? get updatedAt => data['updated_at'] as DateTime?;
  DateTime? get syncStatus => data['sync_status'] as DateTime?;
  DateTime? get lastSyncedAt => data['last_synced_at'] as DateTime?;
  String? get localId => data['local_id'] as String?;
  bool? get isDirty => data['is_dirty'] as bool?;
  bool? get isUpdating => data['is_updating'] as bool?;
}

/// END RETRIEVE ALL ATTEMPTS

/// BEGIN RETRIEVE PROFILE
Future<List<RetrieveProfileRow>> performRetrieveProfile(
  Database database, {
  String? email,
}) {
  final query = '''
SELECT * FROM users WHERE email='$email'

''';
  return _readQuery(database, query, (d) => RetrieveProfileRow(d));
}

class RetrieveProfileRow extends SqliteRow {
  RetrieveProfileRow(super.data);

  String? get id => data['id'] as String?;
  String? get role => data['role'] as String?;
  String? get email => data['email'] as String?;
  String? get photoUrl => data['photo_url'] as String?;
  String? get inspectorName => data['inspector_name'] as String?;
  String? get mobileNumber => data['mobile_number'] as String?;
  bool? get isOnline => data['is_online'] as bool?;
  String? get authUserId => data['auth_user_id'] as String?;
  String? get createdUserId => data['created_user_id'] as String?;
  DateTime? get createdAt => data['created_at'] as DateTime?;
  DateTime? get updatedAt => data['updated_at'] as DateTime?;
  String? get regionId => data['region_id'] as String?;
}

/// END RETRIEVE PROFILE

/// BEGIN RETRIEVE AND SORT SYNC QUEUE BY OLDEST TIMESTAMP
Future<List<RetrieveAndSortSyncQueueByOldestTimestampRow>>
    performRetrieveAndSortSyncQueueByOldestTimestamp(
  Database database,
) {
  const query = '''
SELECT * FROM sync_queue ORDER BY timestamp ASC;
''';
  return _readQuery(
      database, query, (d) => RetrieveAndSortSyncQueueByOldestTimestampRow(d));
}

class RetrieveAndSortSyncQueueByOldestTimestampRow extends SqliteRow {
  RetrieveAndSortSyncQueueByOldestTimestampRow(super.data);

  String? get tableName => data['table_name'] as String?;
}

/// END RETRIEVE AND SORT SYNC QUEUE BY OLDEST TIMESTAMP

/// BEGIN RETRIEVE TASKS MODIFIED AFTER A SPECIFIC DATE
Future<List<RetrieveTasksModifiedAfterASpecificDateRow>>
    performRetrieveTasksModifiedAfterASpecificDate(
  Database database,
) {
  const query = '''
SELECT * FROM tasks WHERE last_modified > ?;
''';
  return _readQuery(
      database, query, (d) => RetrieveTasksModifiedAfterASpecificDateRow(d));
}

class RetrieveTasksModifiedAfterASpecificDateRow extends SqliteRow {
  RetrieveTasksModifiedAfterASpecificDateRow(super.data);

  DateTime? get lastModified => data['last_modified'] as DateTime?;
}

/// END RETRIEVE TASKS MODIFIED AFTER A SPECIFIC DATE

/// BEGIN RETRIEVE ALL TASKS ASSIGNED TO A SPECIFIC ASSIGNEE
Future<List<RetrieveAllTasksAssignedToASpecificAssigneeRow>>
    performRetrieveAllTasksAssignedToASpecificAssignee(
  Database database, {
  String? assignee,
}) {
  final query = '''
SELECT * FROM tasks WHERE assignee='$assignee'
''';
  return _readQuery(database, query,
      (d) => RetrieveAllTasksAssignedToASpecificAssigneeRow(d));
}

class RetrieveAllTasksAssignedToASpecificAssigneeRow extends SqliteRow {
  RetrieveAllTasksAssignedToASpecificAssigneeRow(super.data);

  String? get id => data['id'] as String?;
  String? get taskNumber => data['task_number'] as String?;
  String? get serviceGroup => data['service_group'] as String?;
  String? get serviceType => data['service_type'] as String?;
  String? get priority => data['priority'] as String?;
  String? get assignee => data['assignee'] as String?;
  String? get fileId => data['file_id'] as String?;
  DateTime? get dateAdded => data['date_added'] as DateTime?;
  DateTime? get dateAccess => data['date_access'] as DateTime?;
  String? get status => data['status'] as String?;
  String? get taskType => data['task_type'] as String?;
  String? get attemptCount => data['attempt_count'] as String?;
  DateTime? get createdAt => data['created_at'] as DateTime?;
  DateTime? get updatedAt => data['updated_at'] as DateTime?;
  bool? get isDeleted => data['is_deleted'] as bool?;
  String? get syncStatus => data['sync_status'] as String?;
  DateTime? get lastSyncedAt => data['last_synced_at'] as DateTime?;
  String? get localId => data['local_id'] as String?;
  int? get isDirty => data['is_dirty'] as int?;
  bool? get isUpdating => data['is_updating'] as bool?;
}

/// END RETRIEVE ALL TASKS ASSIGNED TO A SPECIFIC ASSIGNEE

/// BEGIN COUNT OF TASKS FOR DISPATCH ASSIGNED TO A SPECIFIC ASSIGNEE
Future<List<CountOfTasksForDispatchAssignedToASpecificAssigneeRow>>
    performCountOfTasksForDispatchAssignedToASpecificAssignee(
  Database database, {
  String? assignee,
}) {
  final query = '''
SELECT COUNT(*) 
FROM tasks 
WHERE status = 'for dispatch' 
AND assignee = '$assignee';
''';
  return _readQuery(database, query,
      (d) => CountOfTasksForDispatchAssignedToASpecificAssigneeRow(d));
}

class CountOfTasksForDispatchAssignedToASpecificAssigneeRow extends SqliteRow {
  CountOfTasksForDispatchAssignedToASpecificAssigneeRow(
      super.data);

  String? get id => data['id'] as String?;
}

/// END COUNT OF TASKS FOR DISPATCH ASSIGNED TO A SPECIFIC ASSIGNEE

/// BEGIN RETRIEVE TASK DETAILS BY TASK ID
Future<List<RetrieveTaskDetailsByTaskIDRow>> performRetrieveTaskDetailsByTaskID(
  Database database, {
  String? taskId,
}) {
  final query = '''
SELECT * FROM tasks WHERE  id = '$taskId'
''';
  return _readQuery(database, query, (d) => RetrieveTaskDetailsByTaskIDRow(d));
}

class RetrieveTaskDetailsByTaskIDRow extends SqliteRow {
  RetrieveTaskDetailsByTaskIDRow(super.data);

  String? get id => data['id'] as String?;
  String? get taskNumber => data['task_number'] as String?;
  String? get serviceGroup => data['service_group'] as String?;
  String? get serviceType => data['service_type'] as String?;
  String? get priority => data['priority'] as String?;
  String? get assignee => data['assignee'] as String?;
  String? get fileId => data['file_id'] as String?;
  DateTime? get dateAdded => data['date_added'] as DateTime?;
  DateTime? get dateAccess => data['date_access'] as DateTime?;
  String? get status => data['status'] as String?;
  String? get taskType => data['task_type'] as String?;
  String? get attemptCount => data['attempt_count'] as String?;
  DateTime? get createdAt => data['created_at'] as DateTime?;
  DateTime? get updatedAt => data['updated_at'] as DateTime?;
  bool? get isDeleted => data['is_deleted'] as bool?;
  String? get syncStatus => data['sync_status'] as String?;
  DateTime? get lastSyncedAt => data['last_synced_at'] as DateTime?;
  String? get localId => data['local_id'] as String?;
  bool? get isDirty => data['is_dirty'] as bool?;
  bool? get isUpdating => data['is_updating'] as bool?;
}

/// END RETRIEVE TASK DETAILS BY TASK ID

/// BEGIN SELECT TASKS AND PPIR BY ASSIGNEE
Future<List<SELECTTASKSAndPPIRByAssigneeRow>>
    performSELECTTASKSAndPPIRByAssignee(
  Database database, {
  String? taskId,
  String? assignee,
}) {
  final query = '''
SELECT 
    COALESCE(CAST(t.id AS TEXT), 'No Value') AS task_id,
    COALESCE(t.task_number, 'No Value') AS task_number,
    COALESCE(t.service_group, 'No Value') AS service_group,
    COALESCE(t.service_type, 'No Value') AS service_type,
    COALESCE(t.priority, 'No Value') AS priority,
    COALESCE(t.assignee, 'No Value') AS assignee,
    COALESCE(t.file_id, 'No Value') AS file_id,
    COALESCE(CAST(t.date_added AS TEXT), '1970-01-01 00:00:00') AS date_added,
    COALESCE(CAST(t.date_access AS TEXT), '1970-01-01 00:00:00') AS date_access,
    COALESCE(t.status, 'No Value') AS status,
    COALESCE(t.task_type, 'No Value') AS task_type,
    COALESCE(t.attempt_count, 0) AS attempt_count,
    COALESCE(CAST(t.created_at AS TEXT), '1970-01-01 00:00:00') AS task_created_at,
    COALESCE(CAST(t.updated_at AS TEXT), '1970-01-01 00:00:00') AS task_updated_at,
    COALESCE(CAST(t.is_deleted AS TEXT), 'No Value') AS is_deleted,
    COALESCE(t.sync_status, 'No Value') AS task_sync_status,
    COALESCE(CAST(t.last_synced_at AS TEXT), '1970-01-01 00:00:00') AS task_last_synced_at,
    COALESCE(t.local_id, 'No Value') AS task_local_id,
    COALESCE(CAST(t.is_dirty AS TEXT), 'No Value') AS task_is_dirty,
    COALESCE(p.ppir_assignmentid, 'No Value') AS ppir_assignmentid,
    COALESCE(p.gpx, 'No Value') AS gpx,
    COALESCE(p.ppir_insuranceid, 'No Value') AS ppir_insuranceid,
    COALESCE(p.ppir_farmername, 'No Value') AS ppir_farmername,
    COALESCE(p.ppir_address, 'No Value') AS ppir_address,
    COALESCE(p.ppir_farmertype, 'No Value') AS ppir_farmertype,
    COALESCE(p.ppir_mobileno, 'No Value') AS ppir_mobileno,
    COALESCE(p.ppir_groupname, 'No Value') AS ppir_groupname,
    COALESCE(p.ppir_groupaddress, 'No Value') AS ppir_groupaddress,
    COALESCE(p.ppir_lendername, 'No Value') AS ppir_lendername,
    COALESCE(p.ppir_lenderaddress, 'No Value') AS ppir_lenderaddress,
    COALESCE(p.ppir_cicno, 'No Value') AS ppir_cicno,
    COALESCE(p.ppir_farmloc, 'No Value') AS ppir_farmloc,
    COALESCE(p.ppir_north, 'No Value') AS ppir_north,
    COALESCE(p.ppir_south, 'No Value') AS ppir_south,
    COALESCE(p.ppir_east, 'No Value') AS ppir_east,
    COALESCE(p.ppir_west, 'No Value') AS ppir_west,
    COALESCE(p.ppir_area_aci, 'No Value') AS ppir_area_aci,
    COALESCE(p.ppir_area_act, 'No Value') AS ppir_area_act,
    COALESCE(p.ppir_dopds_aci, 'No Value') AS ppir_dopds_aci,
    COALESCE(p.ppir_dopds_act, 'No Value') AS ppir_dopds_act,
    COALESCE(p.ppir_doptp_aci, 'No Value') AS ppir_doptp_aci,
    COALESCE(p.ppir_doptp_act, 'No Value') AS ppir_doptp_act,
    COALESCE(p.ppir_svp_aci, 'No Value') AS ppir_svp_aci,
    COALESCE(p.ppir_svp_act, 'rice') AS ppir_svp_act, -- Default from schema
    COALESCE(p.ppir_variety, 'No Value') AS ppir_variety,
    COALESCE(p.ppir_stagecrop, 'No Value') AS ppir_stagecrop,
    COALESCE(p.ppir_remarks, 'No Value') AS ppir_remarks,
    COALESCE(p.ppir_name_insured, 'No Value') AS ppir_name_insured,
    COALESCE(p.ppir_name_iuia, 'No Value') AS ppir_name_iuia,
    COALESCE(p.ppir_sig_insured, 'No Value') AS ppir_sig_insured,
    COALESCE(p.ppir_sig_iuia, 'No Value') AS ppir_sig_iuia,
    COALESCE(p.track_last_coord, 'No Value') AS track_last_coord,
    COALESCE(p.track_date_time, '1970-01-01 00:00:00') AS track_date_time,
    COALESCE(p.track_total_area, 'No Value') AS track_total_area,
    COALESCE(p.track_total_distance, 'No Value') AS track_total_distance,
    COALESCE(p.captured_area, 'No Value') AS captured_area,
    COALESCE(CAST(p.created_at AS TEXT), '1970-01-01 00:00:00') AS ppir_created_at,
    COALESCE(CAST(p.updated_at AS TEXT), '1970-01-01 00:00:00') AS ppir_updated_at,
    COALESCE(p.sync_status, 'No Value') AS ppir_sync_status,
    COALESCE(CAST(p.last_synced_at AS TEXT), '1970-01-01 00:00:00') AS ppir_last_synced_at,
    COALESCE(p.local_id, 'No Value') AS ppir_local_id,
    COALESCE(CAST(p.is_dirty AS TEXT), 'No Value') AS ppir_is_dirty
FROM 
    tasks t
LEFT JOIN 
    ppir_forms p ON t.id = p.task_id
WHERE 
    t.assignee = '$assignee'
    AND t.id = '$taskId';
''';
  return _readQuery(database, query, (d) => SELECTTASKSAndPPIRByAssigneeRow(d));
}

class SELECTTASKSAndPPIRByAssigneeRow extends SqliteRow {
  SELECTTASKSAndPPIRByAssigneeRow(super.data);

  String? get taskId => data['task_id'] as String?;
  String? get taskNumber => data['task_number'] as String?;
  String? get serviceGroup => data['service_group'] as String?;
  String? get serviceType => data['service_type'] as String?;
  String? get priority => data['priority'] as String?;
  String? get assignee => data['assignee'] as String?;
  String? get fileId => data['file_id'] as String?;
  String? get dateAdded => data['date_added'] as String?;
  String? get dateAccess => data['date_access'] as String?;
  String? get status => data['status'] as String?;
  String? get taskType => data['task_type'] as String?;
  String? get attemptCount => data['attempt_count'] as String?;
  String? get taskCreatedAt => data['task_created_at'] as String?;
  String? get taskUpdatedAt => data['task_updated_at'] as String?;
  String? get isDeleted => data['is_deleted'] as String?;
  String? get taskSyncStatus => data['task_sync_status'] as String?;
  String? get taskLastSyncedAt => data['task_last_synced_at'] as String?;
  String? get taskLocalId => data['task_local_id'] as String?;
  String? get taskIsDirty => data['task_is_dirty'] as String?;
  String? get ppirAssignmentid => data['ppir_assignmentid'] as String?;
  String? get gpx => data['gpx'] as String?;
  String? get ppirInsuranceid => data['ppir_insuranceid'] as String?;
  String? get ppirFarmername => data['ppir_farmername'] as String?;
  String? get ppirAddress => data['ppir_address'] as String?;
  String? get ppirFarmertype => data['ppir_farmertype'] as String?;
  String? get ppirMobileno => data['ppir_mobileno'] as String?;
  String? get ppirGroupname => data['ppir_groupname'] as String?;
  String? get ppirGroupaddress => data['ppir_groupaddress'] as String?;
  String? get ppirLendername => data['ppir_lendername'] as String?;
  String? get ppirLenderaddress => data['ppir_lenderaddress'] as String?;
  String? get ppirCicno => data['ppir_cicno'] as String?;
  String? get ppirFarmloc => data['ppir_farmloc'] as String?;
  String? get ppirNorth => data['ppir_north'] as String?;
  String? get ppirSouth => data['ppir_south'] as String?;
  String? get ppirEast => data['ppir_east'] as String?;
  String? get ppirWest => data['ppir_west'] as String?;
  String? get ppirAreaAci => data['ppir_area_aci'] as String?;
  String? get ppirAreaAct => data['ppir_area_act'] as String?;
  String? get ppirDopdsAci => data['ppir_dopds_aci'] as String?;
  String? get ppirDopdsAct => data['ppir_dopds_act'] as String?;
  String? get ppirDoptpAci => data['ppir_doptp_aci'] as String?;
  String? get ppirDoptpAct => data['ppir_doptp_act'] as String?;
  String? get ppirSvpAci => data['ppir_svp_aci'] as String?;
  String? get ppirSvpAct => data['ppir_svp_act'] as String?;
  String? get ppirVariety => data['ppir_variety'] as String?;
  String? get ppirStagecrop => data['ppir_stagecrop'] as String?;
  String? get ppirRemarks => data['ppir_remarks'] as String?;
  String? get ppirNameInsured => data['ppir_name_insured'] as String?;
  String? get ppirNameIuia => data['ppir_name_iuia'] as String?;
  String? get ppirSigInsured => data['ppir_sig_insured'] as String?;
  String? get ppirSigIuia => data['ppir_sig_iuia'] as String?;
  String? get trackLastCoord => data['track_last_coord'] as String?;
  String? get trackDateTime => data['track_date_time'] as String?;
  String? get trackTotalArea => data['track_total_area'] as String?;
  String? get trackTotalDistance => data['track_total_distance'] as String?;
  String? get ppirCreatedAt => data['ppir_created_at'] as String?;
  String? get ppirUpdatedAt => data['ppir_updated_at'] as String?;
  String? get ppirSyncStatus => data['ppir_sync_status'] as String?;
  String? get ppirLastSyncedAt => data['ppir_last_synced_at'] as String?;
  String? get ppirLocalId => data['ppir_local_id'] as String?;
  String? get ppirIsDirty => data['ppir_is_dirty'] as String?;
  String? get capturedArea => data['captured_area'] as String?;
}

/// END SELECT TASKS AND PPIR BY ASSIGNEE

/// BEGIN RETRIEVE ALL RICE SEEDS BY REGION ID
Future<List<RetrieveAllRiceSeedsByRegionIDRow>>
    performRetrieveAllRiceSeedsByRegionID(
  Database database, {
  String? regionId,
}) {
  final query = '''
SELECT * FROM seeds WHERE seed_type = 'rice' AND region_id = '$regionId';
''';
  return _readQuery(
      database, query, (d) => RetrieveAllRiceSeedsByRegionIDRow(d));
}

class RetrieveAllRiceSeedsByRegionIDRow extends SqliteRow {
  RetrieveAllRiceSeedsByRegionIDRow(super.data);

  String? get seed => data['seed'] as String?;
  String? get seedType => data['seed_type'] as String?;
}

/// END RETRIEVE ALL RICE SEEDS BY REGION ID

/// BEGIN RETRIEVE ALL CORN SEEDS BY REGION ID
Future<List<RetrieveAllCornSeedsByRegionIDRow>>
    performRetrieveAllCornSeedsByRegionID(
  Database database, {
  String? regionId,
}) {
  final query = '''
SELECT * FROM seeds WHERE seed_type = 'corn' AND region_id = '$regionId';
''';
  return _readQuery(
      database, query, (d) => RetrieveAllCornSeedsByRegionIDRow(d));
}

class RetrieveAllCornSeedsByRegionIDRow extends SqliteRow {
  RetrieveAllCornSeedsByRegionIDRow(super.data);

  String? get seed => data['seed'] as String?;
  String? get seedType => data['seed_type'] as String?;
}

/// END RETRIEVE ALL CORN SEEDS BY REGION ID

/// BEGIN RETRIEVE PPIR FORMS BY TASK ID
Future<List<RetrievePPIRFormsByTaskIDRow>> performRetrievePPIRFormsByTaskID(
  Database database, {
  String? taskId,
}) {
  final query = '''
SELECT * FROM ppir_forms WHERE task_id='$taskId'
''';
  return _readQuery(database, query, (d) => RetrievePPIRFormsByTaskIDRow(d));
}

class RetrievePPIRFormsByTaskIDRow extends SqliteRow {
  RetrievePPIRFormsByTaskIDRow(super.data);

  String? get taskId => data['task_id'] as String?;
  String? get ppirSigInsured => data['ppir_sig_insured'] as String?;
  String? get ppirSigIuia => data['ppir_sig_iuia'] as String?;
}

/// END RETRIEVE PPIR FORMS BY TASK ID

/// BEGIN RETRIEVE REGION CODE BY REGION ID
Future<List<RetrieveRegionCodeByRegionIDRow>>
    performRetrieveRegionCodeByRegionID(
  Database database, {
  String? id,
}) {
  final query = '''
SELECT region_code FROM regions WHERE id = '$id'
''';
  return _readQuery(database, query, (d) => RetrieveRegionCodeByRegionIDRow(d));
}

class RetrieveRegionCodeByRegionIDRow extends SqliteRow {
  RetrieveRegionCodeByRegionIDRow(super.data);

  String? get regionCode => data['region_code'] as String?;
}

/// END RETRIEVE REGION CODE BY REGION ID

/// BEGIN RETRIEVE GPX DATA FROM PPIR FORMS BY TASK ID
Future<List<RetrieveGPXDataFromPPIRFormsByTaskIDRow>>
    performRetrieveGPXDataFromPPIRFormsByTaskID(
  Database database, {
  String? taskId,
}) {
  final query = '''
SELECT gpx FROM ppir_forms WHERE task_id='$taskId'
''';
  return _readQuery(
      database, query, (d) => RetrieveGPXDataFromPPIRFormsByTaskIDRow(d));
}

class RetrieveGPXDataFromPPIRFormsByTaskIDRow extends SqliteRow {
  RetrieveGPXDataFromPPIRFormsByTaskIDRow(super.data);

  String? get gpx => data['gpx'] as String?;
}

/// END RETRIEVE GPX DATA FROM PPIR FORMS BY TASK ID

/// BEGIN RETRIEVE PPIR IS DIRTY STATUS FOR TASKS ASSIGNED TO A SPECIFIC ASSIGNEE
Future<List<RetrievePPIRIsDirtyStatusForTasksAssignedToASpecificAssigneeRow>>
    performRetrievePPIRIsDirtyStatusForTasksAssignedToASpecificAssignee(
  Database database, {
  String? assignee,
}) {
  final query = '''
SELECT 
    CAST(p.is_dirty AS TEXT) AS ppir_is_dirty
FROM 
    ppir_forms p
JOIN 
    tasks t ON t.id = p.task_id
WHERE 
    t.assignee = '$assignee';
''';
  return _readQuery(
      database,
      query,
      (d) =>
          RetrievePPIRIsDirtyStatusForTasksAssignedToASpecificAssigneeRow(d));
}

class RetrievePPIRIsDirtyStatusForTasksAssignedToASpecificAssigneeRow
    extends SqliteRow {
  RetrievePPIRIsDirtyStatusForTasksAssignedToASpecificAssigneeRow(
      super.data);

  String? get ppirIsDirty => data['ppir_is_dirty'] as String?;
}

/// END RETRIEVE PPIR IS DIRTY STATUS FOR TASKS ASSIGNED TO A SPECIFIC ASSIGNEE

/// BEGIN RETRIEVE DETAILED TASK AND PPIR FORM DATA FOR A SPECIFIC ASSIGNEE
Future<List<RetrieveDetailedTaskAndPPIRFormDataForASpecificAssigneeRow>>
    performRetrieveDetailedTaskAndPPIRFormDataForASpecificAssignee(
  Database database, {
  String? assignee,
}) {
  final query = '''
SELECT 
    COALESCE(CAST(t.id AS TEXT), 'No Value') AS task_id,
    COALESCE(t.task_number, 'No Value') AS task_number,
    COALESCE(t.service_group, 'No Value') AS service_group,
    COALESCE(t.service_type, 'No Value') AS service_type,
    COALESCE(t.priority, 'No Value') AS priority,
    COALESCE(t.assignee, 'No Value') AS assignee,
    COALESCE(t.file_id, 'No Value') AS file_id,
    COALESCE(CAST(t.date_added AS TEXT), '1970-01-01 00:00:00') AS date_added,
    COALESCE(CAST(t.date_access AS TEXT), '1970-01-01 00:00:00') AS date_access,
    COALESCE(t.status, 'No Value') AS status,
    COALESCE(t.task_type, 'No Value') AS task_type,
    COALESCE(t.attempt_count, 0) AS attempt_count,
    COALESCE(CAST(t.created_at AS TEXT), '1970-01-01 00:00:00') AS task_created_at,
    COALESCE(CAST(t.updated_at AS TEXT), '1970-01-01 00:00:00') AS task_updated_at,
    COALESCE(CAST(t.is_deleted AS TEXT), 'No Value') AS is_deleted,
    COALESCE(t.sync_status, 'No Value') AS task_sync_status,
    COALESCE(CAST(t.last_synced_at AS TEXT), '1970-01-01 00:00:00') AS task_last_synced_at,
    COALESCE(t.local_id, 'No Value') AS task_local_id,
    COALESCE(CAST(t.is_dirty AS TEXT), 'No Value') AS task_is_dirty,
    COALESCE(p.ppir_assignmentid, 'No Value') AS ppir_assignmentid,
    COALESCE(p.gpx, 'No Value') AS gpx,
    COALESCE(p.ppir_insuranceid, 'No Value') AS ppir_insuranceid,
    COALESCE(p.ppir_farmername, 'No Value') AS ppir_farmername,
    COALESCE(p.ppir_address, 'No Value') AS ppir_address,
    COALESCE(p.ppir_farmertype, 'No Value') AS ppir_farmertype,
    COALESCE(p.ppir_mobileno, 'No Value') AS ppir_mobileno,
    COALESCE(p.ppir_groupname, 'No Value') AS ppir_groupname,
    COALESCE(p.ppir_groupaddress, 'No Value') AS ppir_groupaddress,
    COALESCE(p.ppir_lendername, 'No Value') AS ppir_lendername,
    COALESCE(p.ppir_lenderaddress, 'No Value') AS ppir_lenderaddress,
    COALESCE(p.ppir_cicno, 'No Value') AS ppir_cicno,
    COALESCE(p.ppir_farmloc, 'No Value') AS ppir_farmloc,
    COALESCE(p.ppir_north, 'No Value') AS ppir_north,
    COALESCE(p.ppir_south, 'No Value') AS ppir_south,
    COALESCE(p.ppir_east, 'No Value') AS ppir_east,
    COALESCE(p.ppir_west, 'No Value') AS ppir_west,
    COALESCE(p.ppir_area_aci, 'No Value') AS ppir_area_aci,
    COALESCE(p.ppir_area_act, 'No Value') AS ppir_area_act,
    COALESCE(p.ppir_dopds_aci, 'No Value') AS ppir_dopds_aci,
    COALESCE(p.ppir_dopds_act, 'No Value') AS ppir_dopds_act,
    COALESCE(p.ppir_doptp_aci, 'No Value') AS ppir_doptp_aci,
    COALESCE(p.ppir_doptp_act, 'No Value') AS ppir_doptp_act,
    COALESCE(p.ppir_svp_aci, 'No Value') AS ppir_svp_aci,
    COALESCE(p.ppir_svp_act, 'rice') AS ppir_svp_act,
    COALESCE(p.ppir_variety, 'No Value') AS ppir_variety,
    COALESCE(p.ppir_stagecrop, 'No Value') AS ppir_stagecrop,
    COALESCE(p.ppir_remarks, 'No Value') AS ppir_remarks,
    COALESCE(p.ppir_name_insured, 'No Value') AS ppir_name_insured,
    COALESCE(p.ppir_name_iuia, 'No Value') AS ppir_name_iuia,
    COALESCE(p.ppir_sig_insured, 'No Value') AS ppir_sig_insured,
    COALESCE(p.ppir_sig_iuia, 'No Value') AS ppir_sig_iuia,
    COALESCE(p.track_last_coord, 'No Value') AS track_last_coord,
    COALESCE(p.track_date_time, '1970-01-01 00:00:00') AS track_date_time,
    COALESCE(p.track_total_area, 'No Value') AS track_total_area,
    COALESCE(p.track_total_distance, 'No Value') AS track_total_distance,
    COALESCE(p.captured_area, 'No Value') AS captured_area,
    COALESCE(CAST(p.created_at AS TEXT), '1970-01-01 00:00:00') AS ppir_created_at,
    COALESCE(CAST(p.updated_at AS TEXT), '1970-01-01 00:00:00') AS ppir_updated_at,
    COALESCE(p.sync_status, 'No Value') AS ppir_sync_status,
    COALESCE(CAST(p.last_synced_at AS TEXT), '1970-01-01 00:00:00') AS ppir_last_synced_at,
    COALESCE(p.local_id, 'No Value') AS ppir_local_id,
    COALESCE(CAST(p.is_dirty AS TEXT), 'No Value') AS ppir_is_dirty
FROM 
    tasks t
LEFT JOIN 
    ppir_forms p ON t.id = p.task_id
WHERE 
    t.assignee = '$assignee';
''';
  return _readQuery(database, query,
      (d) => RetrieveDetailedTaskAndPPIRFormDataForASpecificAssigneeRow(d));
}

class RetrieveDetailedTaskAndPPIRFormDataForASpecificAssigneeRow
    extends SqliteRow {
  RetrieveDetailedTaskAndPPIRFormDataForASpecificAssigneeRow(
      super.data);

  String? get taskId => data['task_id'] as String?;
  String? get taskNumber => data['task_number'] as String?;
  String? get serviceGroup => data['service_group'] as String?;
  String? get serviceType => data['service_type'] as String?;
  String? get priority => data['priority'] as String?;
  String? get assignee => data['assignee'] as String?;
  String? get fileId => data['file_id'] as String?;
  String? get dateAdded => data['date_added'] as String?;
  String? get dateAccess => data['date_access'] as String?;
  String? get status => data['status'] as String?;
  String? get taskType => data['task_type'] as String?;
  String? get attemptCount => data['attempt_count'] as String?;
  String? get taskCreatedAt => data['task_created_at'] as String?;
  String? get taskUpdatedAt => data['task_updated_at'] as String?;
  String? get isDeleted => data['is_deleted'] as String?;
  String? get taskSyncStatus => data['task_sync_status'] as String?;
  String? get taskLastSyncedAt => data['task_last_synced_at'] as String?;
  String? get taskLocalId => data['task_local_id'] as String?;
  String? get taskIsDirty => data['task_is_dirty'] as String?;
  String? get ppirAssignmentid => data['ppir_assignmentid'] as String?;
  String? get gpx => data['gpx'] as String?;
  String? get ppirInsuranceid => data['ppir_insuranceid'] as String?;
  String? get ppirFarmername => data['ppir_farmername'] as String?;
  String? get ppirAddress => data['ppir_address'] as String?;
  String? get ppirFarmertype => data['ppir_farmertype'] as String?;
  String? get ppirMobileno => data['ppir_mobileno'] as String?;
  String? get ppirGroupname => data['ppir_groupname'] as String?;
  String? get ppirGroupaddress => data['ppir_groupaddress'] as String?;
  String? get ppirLendername => data['ppir_lendername'] as String?;
  String? get ppirLenderaddress => data['ppir_lenderaddress'] as String?;
  String? get ppirCicno => data['ppir_cicno'] as String?;
  String? get ppirFarmloc => data['ppir_farmloc'] as String?;
  String? get ppirNorth => data['ppir_north'] as String?;
  String? get ppirSouth => data['ppir_south'] as String?;
  String? get ppirEast => data['ppir_east'] as String?;
  String? get ppirWest => data['ppir_west'] as String?;
  String? get ppirAreaAci => data['ppir_area_aci'] as String?;
  String? get ppirAreaAct => data['ppir_area_act'] as String?;
  String? get ppirDopdsAci => data['ppir_dopds_aci'] as String?;
  String? get ppirDopdsAct => data['ppir_dopds_act'] as String?;
  String? get ppirDoptpAci => data['ppir_doptp_aci'] as String?;
  String? get ppirDoptpAct => data['ppir_doptp_act'] as String?;
  String? get ppirSvpAci => data['ppir_svp_aci'] as String?;
  String? get ppirSvpAct => data['ppir_svp_act'] as String?;
  String? get ppirVariety => data['ppir_variety'] as String?;
  String? get ppirStagecrop => data['ppir_stagecrop'] as String?;
  String? get ppirRemarks => data['ppir_remarks'] as String?;
  String? get ppirNameInsured => data['ppir_name_insured'] as String?;
  String? get ppirNameIuia => data['ppir_name_iuia'] as String?;
  String? get ppirSigInsured => data['ppir_sig_insured'] as String?;
  String? get ppirSigIuia => data['ppir_sig_iuia'] as String?;
  String? get trackLastCoord => data['track_last_coord'] as String?;
  String? get trackDateTime => data['track_date_time'] as String?;
  String? get trackTotalArea => data['track_total_area'] as String?;
  String? get trackTotalDistance => data['track_total_distance'] as String?;
  String? get ppirCreatedAt => data['ppir_created_at'] as String?;
  String? get ppirUpdatedAt => data['ppir_updated_at'] as String?;
  String? get ppirSyncStatus => data['ppir_sync_status'] as String?;
  String? get ppirLastSyncedAt => data['ppir_last_synced_at'] as String?;
  String? get ppirLocalId => data['ppir_local_id'] as String?;
  String? get ppirIsDirty => data['ppir_is_dirty'] as String?;
  String? get capturedArea => data['captured_area'] as String?;
}

/// END RETRIEVE DETAILED TASK AND PPIR FORM DATA FOR A SPECIFIC ASSIGNEE

/// BEGIN SELECT PPIR FORMS BY ASSIGNEE AND TASK STATUS
Future<List<SelectPpirFormsByAssigneeAndTaskStatusRow>>
    performSelectPpirFormsByAssigneeAndTaskStatus(
  Database database, {
  String? assignee,
  String? status,
}) {
  final query = '''
SELECT 
    COALESCE(CAST(t.id AS TEXT), 'No Value') AS task_id,
    COALESCE(t.task_number, 'No Value') AS task_number,
    COALESCE(t.service_group, 'No Value') AS service_group,
    COALESCE(t.service_type, 'No Value') AS service_type,
    COALESCE(t.priority, 'No Value') AS priority,
    COALESCE(t.assignee, 'No Value') AS assignee,
    COALESCE(t.file_id, 'No Value') AS file_id,
    COALESCE(CAST(t.date_added AS TEXT), '1970-01-01 00:00:00') AS date_added,
    COALESCE(CAST(t.date_access AS TEXT), '1970-01-01 00:00:00') AS date_access,
    COALESCE(t.status, 'No Value') AS status,
    COALESCE(t.task_type, 'No Value') AS task_type,
    COALESCE(t.attempt_count, 0) AS attempt_count,
    COALESCE(CAST(t.created_at AS TEXT), '1970-01-01 00:00:00') AS task_created_at,
    COALESCE(CAST(t.updated_at AS TEXT), '1970-01-01 00:00:00') AS task_updated_at,
    COALESCE(CAST(t.is_deleted AS TEXT), 'No Value') AS is_deleted,
    COALESCE(t.sync_status, 'No Value') AS task_sync_status,
    COALESCE(CAST(t.last_synced_at AS TEXT), '1970-01-01 00:00:00') AS task_last_synced_at,
    COALESCE(t.local_id, 'No Value') AS task_local_id,
    COALESCE(CAST(t.is_dirty AS TEXT), 'No Value') AS task_is_dirty,
    COALESCE(p.ppir_assignmentid, 'No Value') AS ppir_assignmentid,
    COALESCE(p.gpx, 'No Value') AS gpx,
    COALESCE(p.ppir_insuranceid, 'No Value') AS ppir_insuranceid,
    COALESCE(p.ppir_farmername, 'No Value') AS ppir_farmername,
    COALESCE(p.ppir_address, 'No Value') AS ppir_address,
    COALESCE(p.ppir_farmertype, 'No Value') AS ppir_farmertype,
    COALESCE(p.ppir_mobileno, 'No Value') AS ppir_mobileno,
    COALESCE(p.ppir_groupname, 'No Value') AS ppir_groupname,
    COALESCE(p.ppir_groupaddress, 'No Value') AS ppir_groupaddress,
    COALESCE(p.ppir_lendername, 'No Value') AS ppir_lendername,
    COALESCE(p.ppir_lenderaddress, 'No Value') AS ppir_lenderaddress,
    COALESCE(p.ppir_cicno, 'No Value') AS ppir_cicno,
    COALESCE(p.ppir_farmloc, 'No Value') AS ppir_farmloc,
    COALESCE(p.ppir_north, 'No Value') AS ppir_north,
    COALESCE(p.ppir_south, 'No Value') AS ppir_south,
    COALESCE(p.ppir_east, 'No Value') AS ppir_east,
    COALESCE(p.ppir_west, 'No Value') AS ppir_west,
    COALESCE(p.ppir_area_aci, 'No Value') AS ppir_area_aci,
    COALESCE(p.ppir_area_act, 'No Value') AS ppir_area_act,
    COALESCE(p.ppir_dopds_aci, 'No Value') AS ppir_dopds_aci,
    COALESCE(p.ppir_dopds_act, 'No Value') AS ppir_dopds_act,
    COALESCE(p.ppir_doptp_aci, 'No Value') AS ppir_doptp_aci,
    COALESCE(p.ppir_doptp_act, 'No Value') AS ppir_doptp_act,
    COALESCE(p.ppir_svp_aci, 'No Value') AS ppir_svp_aci,
    COALESCE(p.ppir_svp_act, 'rice') AS ppir_svp_act,
    COALESCE(p.ppir_variety, 'No Value') AS ppir_variety,
    COALESCE(p.ppir_stagecrop, 'No Value') AS ppir_stagecrop,
    COALESCE(p.ppir_remarks, 'No Value') AS ppir_remarks,
    COALESCE(p.ppir_name_insured, 'No Value') AS ppir_name_insured,
    COALESCE(p.ppir_name_iuia, 'No Value') AS ppir_name_iuia,
    COALESCE(p.ppir_sig_insured, 'No Value') AS ppir_sig_insured,
    COALESCE(p.ppir_sig_iuia, 'No Value') AS ppir_sig_iuia,
    COALESCE(p.track_last_coord, 'No Value') AS track_last_coord,
    COALESCE(p.track_date_time, '1970-01-01 00:00:00') AS track_date_time,
    COALESCE(p.track_total_area, 'No Value') AS track_total_area,
    COALESCE(p.track_total_distance, 'No Value') AS track_total_distance,
    COALESCE(CAST(p.created_at AS TEXT), '1970-01-01 00:00:00') AS ppir_created_at,
    COALESCE(CAST(p.updated_at AS TEXT), '1970-01-01 00:00:00') AS ppir_updated_at,
    COALESCE(p.sync_status, 'No Value') AS ppir_sync_status,
    COALESCE(CAST(p.last_synced_at AS TEXT), '1970-01-01 00:00:00') AS ppir_last_synced_at,
    COALESCE(p.local_id, 'No Value') AS ppir_local_id,
    COALESCE(CAST(p.is_dirty AS TEXT), 'No Value') AS ppir_is_dirty
FROM 
    tasks t
LEFT JOIN 
    ppir_forms p ON t.id = p.task_id
WHERE 
    t.assignee = '$assignee'
    AND t.status = '$status';
''';
  return _readQuery(
      database, query, (d) => SelectPpirFormsByAssigneeAndTaskStatusRow(d));
}

class SelectPpirFormsByAssigneeAndTaskStatusRow extends SqliteRow {
  SelectPpirFormsByAssigneeAndTaskStatusRow(super.data);

  String? get taskId => data['task_id'] as String?;
  String? get taskNumber => data['task_number'] as String?;
  String? get serviceGroup => data['service_group'] as String?;
  String? get serviceType => data['service_type'] as String?;
  String? get priority => data['priority'] as String?;
  String? get assignee => data['assignee'] as String?;
  String? get fileId => data['file_id'] as String?;
  String? get dateAdded => data['date_added'] as String?;
  String? get dateAccess => data['date_access'] as String?;
  String? get status => data['status'] as String?;
  String? get taskType => data['task_type'] as String?;
  String? get attemptCount => data['attempt_count'] as String?;
  String? get taskCreatedAt => data['task_created_at'] as String?;
  String? get taskUpdatedAt => data['task_updated_at'] as String?;
  String? get isDeleted => data['is_deleted'] as String?;
  String? get taskSyncStatus => data['task_sync_status'] as String?;
  String? get taskLastSyncedAt => data['task_last_synced_at'] as String?;
  String? get taskLocalId => data['task_local_id'] as String?;
  String? get taskIsDirty => data['task_is_dirty'] as String?;
  String? get ppirAssignmentid => data['ppir_assignmentid'] as String?;
  String? get gpx => data['gpx'] as String?;
  String? get ppirInsuranceid => data['ppir_insuranceid'] as String?;
  String? get ppirFarmername => data['ppir_farmername'] as String?;
  String? get ppirAddress => data['ppir_address'] as String?;
  String? get ppirFarmertype => data['ppir_farmertype'] as String?;
  String? get ppirMobileno => data['ppir_mobileno'] as String?;
  String? get ppirGroupname => data['ppir_groupname'] as String?;
  String? get ppirGroupaddress => data['ppir_groupaddress'] as String?;
  String? get ppirLendername => data['ppir_lendername'] as String?;
  String? get ppirLenderaddress => data['ppir_lenderaddress'] as String?;
  String? get ppirCicno => data['ppir_cicno'] as String?;
  String? get ppirFarmloc => data['ppir_farmloc'] as String?;
  String? get ppirNorth => data['ppir_north'] as String?;
  String? get ppirSouth => data['ppir_south'] as String?;
  String? get ppirEast => data['ppir_east'] as String?;
  String? get ppirWest => data['ppir_west'] as String?;
  String? get ppirAreaAci => data['ppir_area_aci'] as String?;
  String? get ppirAreaAct => data['ppir_area_act'] as String?;
  String? get ppirDopdsAci => data['ppir_dopds_aci'] as String?;
  String? get ppirDopdsAct => data['ppir_dopds_act'] as String?;
  String? get ppirDoptpAci => data['ppir_doptp_aci'] as String?;
  String? get ppirDoptpAct => data['ppir_doptp_act'] as String?;
  String? get ppirSvpAci => data['ppir_svp_aci'] as String?;
  String? get ppirSvpAct => data['ppir_svp_act'] as String?;
  String? get ppirVariety => data['ppir_variety'] as String?;
  String? get ppirStagecrop => data['ppir_stagecrop'] as String?;
  String? get ppirRemarks => data['ppir_remarks'] as String?;
  String? get ppirNameInsured => data['ppir_name_insured'] as String?;
  String? get ppirNameIuia => data['ppir_name_iuia'] as String?;
  String? get ppirSigInsured => data['ppir_sig_insured'] as String?;
  String? get ppirSigIuia => data['ppir_sig_iuia'] as String?;
  String? get trackLastCoord => data['track_last_coord'] as String?;
  String? get trackDateTime => data['track_date_time'] as String?;
  String? get trackTotalArea => data['track_total_area'] as String?;
  String? get trackTotalDistance => data['track_total_distance'] as String?;
  String? get ppirCreatedAt => data['ppir_created_at'] as String?;
  String? get ppirUpdatedAt => data['ppir_updated_at'] as String?;
  String? get ppirSyncStatus => data['ppir_sync_status'] as String?;
  String? get ppirLastSyncedAt => data['ppir_last_synced_at'] as String?;
  String? get ppirLocalId => data['ppir_local_id'] as String?;
  String? get ppirIsDirty => data['ppir_is_dirty'] as String?;
}

/// END SELECT PPIR FORMS BY ASSIGNEE AND TASK STATUS

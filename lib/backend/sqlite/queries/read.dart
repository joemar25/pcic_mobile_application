import '/backend/sqlite/queries/sqlite_row.dart';
import 'package:sqflite/sqflite.dart';

Future<List<T>> _readQuery<T>(
  Database database,
  String query,
  T Function(Map<String, dynamic>) create,
) =>
    database.rawQuery(query).then((r) => r.map((e) => create(e)).toList());

/// BEGIN SELECT TASKS
Future<List<SelectTasksRow>> performSelectTasks(
  Database database,
) {
  const query = '''
SELECT * FROM tasks
''';
  return _readQuery(database, query, (d) => SelectTasksRow(d));
}

class SelectTasksRow extends SqliteRow {
  SelectTasksRow(super.data);

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

/// END SELECT TASKS

/// BEGIN SELECT USERS
Future<List<SelectUsersRow>> performSelectUsers(
  Database database,
) {
  const query = '''
SELECT * FROM users
''';
  return _readQuery(database, query, (d) => SelectUsersRow(d));
}

class SelectUsersRow extends SqliteRow {
  SelectUsersRow(super.data);

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

/// END SELECT USERS

/// BEGIN SELECT SEEDS
Future<List<SelectSeedsRow>> performSelectSeeds(
  Database database,
) {
  const query = '''
SELECT * FROM seeds
''';
  return _readQuery(database, query, (d) => SelectSeedsRow(d));
}

class SelectSeedsRow extends SqliteRow {
  SelectSeedsRow(super.data);

  String? get id => data['id'] as String?;
  String? get seed => data['seed'] as String?;
  String? get seedType => data['seed_type'] as String?;
  String? get syncStatus => data['sync_status'] as String?;
  DateTime? get lastSyncedAt => data['last_synced_at'] as DateTime?;
  String? get localId => data['local_id'] as String?;
  bool? get isDirty => data['is_dirty'] as bool?;
}

/// END SELECT SEEDS

/// BEGIN SELECT PPIR FORMS
Future<List<SelectPpirFormsRow>> performSelectPpirForms(
  Database database,
) {
  const query = '''
SELECT * FROM ppir_forms
''';
  return _readQuery(database, query, (d) => SelectPpirFormsRow(d));
}

class SelectPpirFormsRow extends SqliteRow {
  SelectPpirFormsRow(super.data);

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
  String? get localId => data['local_id'] as String?;
  bool? get isDirty => data['is_dirty'] as bool?;
  String? get syncStatus => data['sync_status'] as String?;
  String? get ppirSigIuia => data['ppir_sig_iuia'] as String?;
}

/// END SELECT PPIR FORMS

/// BEGIN SELECT MESSAGES
Future<List<SelectMessagesRow>> performSelectMessages(
  Database database,
) {
  const query = '''
SELECT * FROM messages
''';
  return _readQuery(database, query, (d) => SelectMessagesRow(d));
}

class SelectMessagesRow extends SqliteRow {
  SelectMessagesRow(super.data);

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

/// END SELECT MESSAGES

/// BEGIN SELECT SYNC LOGS
Future<List<SelectSyncLogsRow>> performSelectSyncLogs(
  Database database,
) {
  const query = '''
SELECT * FROM sync_log
''';
  return _readQuery(database, query, (d) => SelectSyncLogsRow(d));
}

class SelectSyncLogsRow extends SqliteRow {
  SelectSyncLogsRow(super.data);

  String? get id => data['id'] as String?;
  DateTime? get syncStartTime => data['sync_start_time'] as DateTime?;
  DateTime? get syncEndTime => data['sync_end_time'] as DateTime?;
  String? get syncStatus => data['sync_status'] as String?;
  int? get recordsSynced => data['records_synced'] as int?;
  String? get errorMessage => data['error_message'] as String?;
  String? get deviceIdentifier => data['device_identifier'] as String?;
}

/// END SELECT SYNC LOGS

/// BEGIN SELECT ATTEMPTS
Future<List<SelectAttemptsRow>> performSelectAttempts(
  Database database,
) {
  const query = '''
SELECT * FROM attempts
''';
  return _readQuery(database, query, (d) => SelectAttemptsRow(d));
}

class SelectAttemptsRow extends SqliteRow {
  SelectAttemptsRow(super.data);

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

/// END SELECT ATTEMPTS

/// BEGIN SELECT PROFILE
Future<List<SelectProfileRow>> performSelectProfile(
  Database database, {
  String? email,
}) {
  final query = '''
SELECT * FROM users WHERE email = '$email'
--SELECT * FROM users WHERE email = ?

''';
  return _readQuery(database, query, (d) => SelectProfileRow(d));
}

class SelectProfileRow extends SqliteRow {
  SelectProfileRow(super.data);

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

/// END SELECT PROFILE

/// BEGIN DASHBOARD READ QUERY
Future<List<DashboardReadQueryRow>> performDashboardReadQuery(
  Database database,
) {
  const query = '''
SELECT * FROM users WHERE id = ?
''';
  return _readQuery(database, query, (d) => DashboardReadQueryRow(d));
}

class DashboardReadQueryRow extends SqliteRow {
  DashboardReadQueryRow(super.data);

  String? get role => data['role'] as String?;
  String? get email => data['email'] as String?;
  String? get photoUrl => data['photo_url'] as String?;
  String? get inspectorName => data['inspector_name'] as String?;
  String? get mobileNumber => data['mobile_number'] as String?;
  bool? get isOnline => data['is_online'] as bool?;
  String? get authUserId => data['auth_user_id'] as String?;
  String? get createdUserId => data['created_user_id'] as String?;
  DateTime? get createdAt => data['created_at'] as DateTime?;
  DateTime? get deletedAt => data['deleted_at'] as DateTime?;
  String? get regionId => data['region_id'] as String?;
}

/// END DASHBOARD READ QUERY

/// BEGIN GET LAST SYNC TIMESTAMP
Future<List<GetLastSyncTimestampRow>> performGetLastSyncTimestamp(
  Database database,
) {
  const query = '''
SELECT last_sync_timestamp FROM sync_status WHERE table_name = ?;
''';
  return _readQuery(database, query, (d) => GetLastSyncTimestampRow(d));
}

class GetLastSyncTimestampRow extends SqliteRow {
  GetLastSyncTimestampRow(super.data);
}

/// END GET LAST SYNC TIMESTAMP

/// BEGIN GET QUEUED CHANGES
Future<List<GetQueuedChangesRow>> performGetQueuedChanges(
  Database database,
) {
  const query = '''
SELECT * FROM sync_queue ORDER BY timestamp ASC;
''';
  return _readQuery(database, query, (d) => GetQueuedChangesRow(d));
}

class GetQueuedChangesRow extends SqliteRow {
  GetQueuedChangesRow(super.data);

  String? get tableName => data['table_name'] as String?;
}

/// END GET QUEUED CHANGES

/// BEGIN GET MODIFIED RECORDS
Future<List<GetModifiedRecordsRow>> performGetModifiedRecords(
  Database database,
) {
  const query = '''
SELECT * FROM tasks WHERE last_modified > ?;
''';
  return _readQuery(database, query, (d) => GetModifiedRecordsRow(d));
}

class GetModifiedRecordsRow extends SqliteRow {
  GetModifiedRecordsRow(super.data);

  DateTime? get lastModified => data['last_modified'] as DateTime?;
}

/// END GET MODIFIED RECORDS

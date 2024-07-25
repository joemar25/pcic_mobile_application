import '/backend/sqlite/queries/sqlite_row.dart';
import 'package:sqflite/sqflite.dart';

Future<List<T>> _readQuery<T>(
  Database database,
  String query,
  T Function(Map<String, dynamic>) create,
) =>
    database.rawQuery(query).then((r) => r.map((e) => create(e)).toList());

/// BEGIN SELECT ALL TASKS
Future<List<SelectAllTasksRow>> performSelectAllTasks(
  Database database,
) {
  const query = '''
SELECT * FROM tasks
''';
  return _readQuery(database, query, (d) => SelectAllTasksRow(d));
}

class SelectAllTasksRow extends SqliteRow {
  SelectAllTasksRow(super.data);

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

/// END SELECT ALL TASKS

/// BEGIN SELECT ALL USERS
Future<List<SelectAllUsersRow>> performSelectAllUsers(
  Database database,
) {
  const query = '''
SELECT * FROM users
''';
  return _readQuery(database, query, (d) => SelectAllUsersRow(d));
}

class SelectAllUsersRow extends SqliteRow {
  SelectAllUsersRow(super.data);
}

/// END SELECT ALL USERS

/// BEGIN SELECT ALL SEEDS
Future<List<SelectAllSeedsRow>> performSelectAllSeeds(
  Database database,
) {
  const query = '''
SELECT * FROM seeds
''';
  return _readQuery(database, query, (d) => SelectAllSeedsRow(d));
}

class SelectAllSeedsRow extends SqliteRow {
  SelectAllSeedsRow(super.data);
}

/// END SELECT ALL SEEDS

/// BEGIN SELECT ALL PPIR FORMS
Future<List<SelectAllPpirFormsRow>> performSelectAllPpirForms(
  Database database,
) {
  const query = '''
SELECT * ppir_forms
''';
  return _readQuery(database, query, (d) => SelectAllPpirFormsRow(d));
}

class SelectAllPpirFormsRow extends SqliteRow {
  SelectAllPpirFormsRow(super.data);
}

/// END SELECT ALL PPIR FORMS

/// BEGIN SELECT ALL MESSAGES
Future<List<SelectAllMessagesRow>> performSelectAllMessages(
  Database database,
) {
  const query = '''
SELECT * FROM messages
''';
  return _readQuery(database, query, (d) => SelectAllMessagesRow(d));
}

class SelectAllMessagesRow extends SqliteRow {
  SelectAllMessagesRow(super.data);
}

/// END SELECT ALL MESSAGES

/// BEGIN SELECT ALL SYNC LOG
Future<List<SelectAllSyncLogRow>> performSelectAllSyncLog(
  Database database,
) {
  const query = '''
SELECT * FROM sync_log
''';
  return _readQuery(database, query, (d) => SelectAllSyncLogRow(d));
}

class SelectAllSyncLogRow extends SqliteRow {
  SelectAllSyncLogRow(super.data);
}

/// END SELECT ALL SYNC LOG

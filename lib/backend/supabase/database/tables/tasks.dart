import '../database.dart';

class TasksTable extends SupabaseTable<TasksRow> {
  @override
  String get tableName => 'tasks';

  @override
  TasksRow createRow(Map<String, dynamic> data) => TasksRow(data);
}

class TasksRow extends SupabaseDataRow {
  TasksRow(super.data);

  @override
  SupabaseTable get table => TasksTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get taskNumber => getField<String>('task_number')!;
  set taskNumber(String value) => setField<String>('task_number', value);

  String? get serviceGroup => getField<String>('service_group');
  set serviceGroup(String? value) => setField<String>('service_group', value);

  String get serviceType => getField<String>('service_type')!;
  set serviceType(String value) => setField<String>('service_type', value);

  String? get priority => getField<String>('priority');
  set priority(String? value) => setField<String>('priority', value);

  String? get assignee => getField<String>('assignee');
  set assignee(String? value) => setField<String>('assignee', value);

  String? get fileId => getField<String>('file_id');
  set fileId(String? value) => setField<String>('file_id', value);

  DateTime? get dateAdded => getField<DateTime>('date_added');
  set dateAdded(DateTime? value) => setField<DateTime>('date_added', value);

  DateTime? get dateAccess => getField<DateTime>('date_access');
  set dateAccess(DateTime? value) => setField<DateTime>('date_access', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  String? get taskType => getField<String>('task_type');
  set taskType(String? value) => setField<String>('task_type', value);

  int get attemptCount => getField<int>('attempt_count')!;
  set attemptCount(int value) => setField<int>('attempt_count', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get isDeleted => getField<bool>('is_deleted');
  set isDeleted(bool? value) => setField<bool>('is_deleted', value);
}

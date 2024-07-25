import '../database.dart';

class UserLogsTable extends SupabaseTable<UserLogsRow> {
  @override
  String get tableName => 'user_logs';

  @override
  UserLogsRow createRow(Map<String, dynamic> data) => UserLogsRow(data);
}

class UserLogsRow extends SupabaseDataRow {
  UserLogsRow(super.data);

  @override
  SupabaseTable get table => UserLogsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String get activity => getField<String>('activity')!;
  set activity(String value) => setField<String>('activity', value);

  DateTime? get timestamp => getField<DateTime>('timestamp');
  set timestamp(DateTime? value) => setField<DateTime>('timestamp', value);

  String? get syncStatus => getField<String>('sync_status');
  set syncStatus(String? value) => setField<String>('sync_status', value);

  DateTime? get lastSyncedAt => getField<DateTime>('last_synced_at');
  set lastSyncedAt(DateTime? value) =>
      setField<DateTime>('last_synced_at', value);

  int get localId => getField<int>('local_id')!;
  set localId(int value) => setField<int>('local_id', value);

  bool? get isDirty => getField<bool>('is_dirty');
  set isDirty(bool? value) => setField<bool>('is_dirty', value);
}

import '../database.dart';

class SyncLogTable extends SupabaseTable<SyncLogRow> {
  @override
  String get tableName => 'sync_log';

  @override
  SyncLogRow createRow(Map<String, dynamic> data) => SyncLogRow(data);
}

class SyncLogRow extends SupabaseDataRow {
  SyncLogRow(super.data);

  @override
  SupabaseTable get table => SyncLogTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime? get syncStartTime => getField<DateTime>('sync_start_time');
  set syncStartTime(DateTime? value) =>
      setField<DateTime>('sync_start_time', value);

  DateTime? get syncEndTime => getField<DateTime>('sync_end_time');
  set syncEndTime(DateTime? value) =>
      setField<DateTime>('sync_end_time', value);

  String? get syncStatus => getField<String>('sync_status');
  set syncStatus(String? value) => setField<String>('sync_status', value);

  int? get recordsSynced => getField<int>('records_synced');
  set recordsSynced(int? value) => setField<int>('records_synced', value);

  String? get errorMessage => getField<String>('error_message');
  set errorMessage(String? value) => setField<String>('error_message', value);

  String? get deviceIdentifier => getField<String>('device_identifier');
  set deviceIdentifier(String? value) =>
      setField<String>('device_identifier', value);
}

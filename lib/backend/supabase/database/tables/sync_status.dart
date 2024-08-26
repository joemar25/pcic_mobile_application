import '../database.dart';

class SyncStatusTable extends SupabaseTable<SyncStatusRow> {
  @override
  String get tableName => 'sync_status';

  @override
  SyncStatusRow createRow(Map<String, dynamic> data) => SyncStatusRow(data);
}

class SyncStatusRow extends SupabaseDataRow {
  SyncStatusRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SyncStatusTable();

  String get tableNameField => getField<String>('table_name')!;
  set tableNameField(String value) => setField<String>('table_name', value);

  int? get lastSyncTimestamp => getField<int>('last_sync_timestamp');
  set lastSyncTimestamp(int? value) =>
      setField<int>('last_sync_timestamp', value);
}

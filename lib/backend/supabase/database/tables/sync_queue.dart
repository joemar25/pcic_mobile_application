import '../database.dart';

class SyncQueueTable extends SupabaseTable<SyncQueueRow> {
  @override
  String get tableName => 'sync_queue';

  @override
  SyncQueueRow createRow(Map<String, dynamic> data) => SyncQueueRow(data);
}

class SyncQueueRow extends SupabaseDataRow {
  SyncQueueRow(super.data);

  @override
  SupabaseTable get table => SyncQueueTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String? get tableNameField => getField<String>('table_name');
  set tableNameField(String? value) => setField<String>('table_name', value);

  int? get recordId => getField<int>('record_id');
  set recordId(int? value) => setField<int>('record_id', value);

  String? get action => getField<String>('action');
  set action(String? value) => setField<String>('action', value);

  String? get dataField => getField<String>('data');
  set dataField(String? value) => setField<String>('data', value);

  int? get timestamp => getField<int>('timestamp');
  set timestamp(int? value) => setField<int>('timestamp', value);
}

import '../database.dart';

class SeedsTable extends SupabaseTable<SeedsRow> {
  @override
  String get tableName => 'seeds';

  @override
  SeedsRow createRow(Map<String, dynamic> data) => SeedsRow(data);
}

class SeedsRow extends SupabaseDataRow {
  SeedsRow(super.data);

  @override
  SupabaseTable get table => SeedsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get seed => getField<String>('seed')!;
  set seed(String value) => setField<String>('seed', value);

  String get seedType => getField<String>('seed_type')!;
  set seedType(String value) => setField<String>('seed_type', value);
}

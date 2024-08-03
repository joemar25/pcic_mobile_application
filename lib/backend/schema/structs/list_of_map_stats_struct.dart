// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ListOfMapStatsStruct extends BaseStruct {
  ListOfMapStatsStruct({
    List<MapStatsStruct>? listOfMapStats,
  }) : _listOfMapStats = listOfMapStats;

  // "listOfMapStats" field.
  List<MapStatsStruct>? _listOfMapStats;
  List<MapStatsStruct> get listOfMapStats => _listOfMapStats ?? const [];
  set listOfMapStats(List<MapStatsStruct>? val) => _listOfMapStats = val;

  void updateListOfMapStats(Function(List<MapStatsStruct>) updateFn) {
    updateFn(_listOfMapStats ??= []);
  }

  bool hasListOfMapStats() => _listOfMapStats != null;

  static ListOfMapStatsStruct fromMap(Map<String, dynamic> data) =>
      ListOfMapStatsStruct(
        listOfMapStats: getStructList(
          data['listOfMapStats'],
          MapStatsStruct.fromMap,
        ),
      );

  static ListOfMapStatsStruct? maybeFromMap(dynamic data) => data is Map
      ? ListOfMapStatsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'listOfMapStats': _listOfMapStats?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'listOfMapStats': serializeParam(
          _listOfMapStats,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static ListOfMapStatsStruct fromSerializableMap(Map<String, dynamic> data) =>
      ListOfMapStatsStruct(
        listOfMapStats: deserializeStructParam<MapStatsStruct>(
          data['listOfMapStats'],
          ParamType.DataStruct,
          true,
          structBuilder: MapStatsStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'ListOfMapStatsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ListOfMapStatsStruct &&
        listEquality.equals(listOfMapStats, other.listOfMapStats);
  }

  @override
  int get hashCode => const ListEquality().hash([listOfMapStats]);
}

ListOfMapStatsStruct createListOfMapStatsStruct() => ListOfMapStatsStruct();

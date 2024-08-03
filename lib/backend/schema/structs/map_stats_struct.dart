// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MapStatsStruct extends BaseStruct {
  MapStatsStruct({
    String? storeName,
    String? realSize,
    String? numberOfTiles,
  })  : _storeName = storeName,
        _realSize = realSize,
        _numberOfTiles = numberOfTiles;

  // "storeName" field.
  String? _storeName;
  String get storeName => _storeName ?? '';
  set storeName(String? val) => _storeName = val;

  bool hasStoreName() => _storeName != null;

  // "realSize" field.
  String? _realSize;
  String get realSize => _realSize ?? '';
  set realSize(String? val) => _realSize = val;

  bool hasRealSize() => _realSize != null;

  // "numberOfTiles" field.
  String? _numberOfTiles;
  String get numberOfTiles => _numberOfTiles ?? '';
  set numberOfTiles(String? val) => _numberOfTiles = val;

  bool hasNumberOfTiles() => _numberOfTiles != null;

  static MapStatsStruct fromMap(Map<String, dynamic> data) => MapStatsStruct(
        storeName: data['storeName'] as String?,
        realSize: data['realSize'] as String?,
        numberOfTiles: data['numberOfTiles'] as String?,
      );

  static MapStatsStruct? maybeFromMap(dynamic data) =>
      data is Map ? MapStatsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'storeName': _storeName,
        'realSize': _realSize,
        'numberOfTiles': _numberOfTiles,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'storeName': serializeParam(
          _storeName,
          ParamType.String,
        ),
        'realSize': serializeParam(
          _realSize,
          ParamType.String,
        ),
        'numberOfTiles': serializeParam(
          _numberOfTiles,
          ParamType.String,
        ),
      }.withoutNulls;

  static MapStatsStruct fromSerializableMap(Map<String, dynamic> data) =>
      MapStatsStruct(
        storeName: deserializeParam(
          data['storeName'],
          ParamType.String,
          false,
        ),
        realSize: deserializeParam(
          data['realSize'],
          ParamType.String,
          false,
        ),
        numberOfTiles: deserializeParam(
          data['numberOfTiles'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'MapStatsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MapStatsStruct &&
        storeName == other.storeName &&
        realSize == other.realSize &&
        numberOfTiles == other.numberOfTiles;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([storeName, realSize, numberOfTiles]);
}

MapStatsStruct createMapStatsStruct({
  String? storeName,
  String? realSize,
  String? numberOfTiles,
}) =>
    MapStatsStruct(
      storeName: storeName,
      realSize: realSize,
      numberOfTiles: numberOfTiles,
    );

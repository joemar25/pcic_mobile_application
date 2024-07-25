import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    secureStorage = const FlutterSecureStorage();
    await _safeInitAsync(() async {
      _AUTHID = await secureStorage.getString('ff_AUTHID') ?? _AUTHID;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  bool _ONLINE = false;
  bool get ONLINE => _ONLINE;
  set ONLINE(bool value) {
    _ONLINE = value;
  }

  bool _routeStarted = false;
  bool get routeStarted => _routeStarted;
  set routeStarted(bool value) {
    _routeStarted = value;
  }

  String _AUTHID = '';
  String get AUTHID => _AUTHID;
  set AUTHID(String value) {
    _AUTHID = value;
    secureStorage.setString('ff_AUTHID', value);
  }

  void deleteAUTHID() {
    secureStorage.delete(key: 'ff_AUTHID');
  }

  List<String> _LIUDTY = ['id', 'auth_id'];
  List<String> get LIUDTY => _LIUDTY;
  set LIUDTY(List<String> value) {
    _LIUDTY = value;
  }

  void addToLIUDTY(String value) {
    LIUDTY.add(value);
  }

  void removeFromLIUDTY(String value) {
    LIUDTY.remove(value);
  }

  void removeAtIndexFromLIUDTY(int index) {
    LIUDTY.removeAt(index);
  }

  void updateLIUDTYAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    LIUDTY[index] = updateFn(_LIUDTY[index]);
  }

  void insertAtIndexInLIUDTY(int index, String value) {
    LIUDTY.insert(index, value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return const CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: const ListToCsvConverter().convert([value]));
}

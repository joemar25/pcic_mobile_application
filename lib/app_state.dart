import 'package:flutter/material.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  bool _routeStarted = false;
  bool get routeStarted => _routeStarted;
  set routeStarted(bool value) {
    _routeStarted = value;
  }

  bool _DEBUG = false;
  bool get DEBUG => _DEBUG;
  set DEBUG(bool value) {
    _DEBUG = value;
  }

  bool _ONLINE = false;
  bool get ONLINE => _ONLINE;
  set ONLINE(bool value) {
    _ONLINE = value;
  }
}

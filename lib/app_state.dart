import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'backend/api_requests/api_manager.dart';
import 'backend/supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

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

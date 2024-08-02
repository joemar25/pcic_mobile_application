// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:dart_ipify/dart_ipify.dart';

Future getIpAddress() async {
  try {
    final ip = await Ipify.ipv4();
    // FFAppState().ipAddress = ip;
  } catch (e) {
    print('Error getting IP address: $e');
    // FFAppState().ipAddress = 'Unable to retrieve IP';
  }
}

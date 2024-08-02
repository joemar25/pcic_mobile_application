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

Future<void> getIpAddress() async {
  try {
    final ip = await Ipify.ipv4();
    FFAppState().ipAddress = ip;
  } catch (e) {
    print('Error getting IP address: $e');
    // Optionally, you can set a default value or handle the error differently
    FFAppState().ipAddress = 'Unable to retrieve IP';
  }
}

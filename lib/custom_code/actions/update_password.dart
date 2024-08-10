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

import 'dart:convert';

Future<bool> updatePassword(String newPassword) async {
  try {
    final response = await SupaFlow.client.auth.updateUser(
      UserAttributes(password: newPassword),
    );

    if (response.error == null) {
      print('Password updated successfully');
      return true;
    } else {
      print('Update failed: ${response.error.message}');
      return false;
    }
  } catch (e) {
    print('Error updating password: $e');
    return false;
  }
}

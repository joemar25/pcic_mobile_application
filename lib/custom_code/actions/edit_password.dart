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

import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

// Custom function to verify the old password
Future<bool> verifyOldPassword(String oldPassword) async {
  final response = await supabase.Supabase.instance.client
      .rpc('verify_user_password', params: {
    'password': oldPassword,
  }).execute();

  // Return whether the password is correct
  return response.data == true;
}

// Custom action to update the user's password
Future<String> editPassword(String oldPassword, String newPassword) async {
  try {
    // First, verify the old password
    bool isOldPasswordCorrect = await verifyOldPassword(oldPassword);

    if (!isOldPasswordCorrect) {
      return 'Old password is incorrect';
    }

    // If old password is correct, proceed to update the password
    final response = await supabase.Supabase.instance.client
        .rpc('update_user_password', params: {
      'new_password': newPassword,
    }).execute();

    if (response.hasError) {
      return 'Update failed: ${response.error?.message ?? "Unknown error"}';
    } else {
      return 'Password updated successfully';
    }
  } catch (e) {
    return 'Error updating password: $e';
  }
}

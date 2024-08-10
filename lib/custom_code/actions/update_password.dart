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
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

// In lib/flutter_flow/custom_functions.dart
Future<bool> verifyOldPassword(String oldPassword) async {
  // Implement password verification logic here
  // This is a placeholder implementation; replace with actual verification
  final response = await SupaFlow.client.rpc('verify_user_password', params: {
    'password': oldPassword,
  });
  return response == true;
}

// In lib/custom_code/actions/update_password.dart
Future<String> updatePassword(String oldPassword, String newPassword) async {
  bool isOldPasswordCorrect = await verifyOldPassword(oldPassword);

  if (!isOldPasswordCorrect) {
    return 'Old password is incorrect';
  }

  try {
    final user = SupaFlow.client.auth.currentUser;
    if (user == null) {
      return 'User is not authenticated';
    }

    final response = await SupaFlow.client.auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );

    if (response.user != null) {
      return 'Password updated successfully';
    } else {
      return 'Update failed: Unknown error';
    }
  } catch (e) {
    return 'Error updating password: $e';
  }
}

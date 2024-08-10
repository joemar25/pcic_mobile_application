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

// Custom function to verify the old password
Future<bool> verifyOldPassword(String oldPassword) async {
  // Implement password verification logic here
  final response = await supabase.Supabase.instance.client
      .rpc('verify_user_password', params: {
    'password': oldPassword,
  }).execute();

  // Return whether the password is correct
  return response.data == true;
}

// Custom action to update the user's password
Future<String> updatePassword(String oldPassword, String newPassword) async {
  // Verify if the old password is correct
  bool isOldPasswordCorrect = await verifyOldPassword(oldPassword);

  if (!isOldPasswordCorrect) {
    return 'Old password is incorrect';
  }

  try {
    final user = supabase.Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return 'User is not authenticated';
    }

    final response = await supabase.Supabase.instance.client.auth.updateUser(
      supabase.UserAttributes(
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

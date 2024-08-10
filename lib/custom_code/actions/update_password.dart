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

Future<String> updatePassword(String oldPassword, String newPassword) async {
  // Function to verify the old password
  Future<bool> verifyOldPassword(String oldPassword) async {
    try {
      // Call the Supabase RPC function to verify the user's old password
      final response =
          await SupaFlow.client.rpc('verify_user_password', params: {
        'password': oldPassword,
      });
      return response == true;
    } catch (e) {
      print('Error verifying old password: $e');
      return false;
    }
  }

  // Verify the old password
  bool isOldPasswordCorrect = await verifyOldPassword(oldPassword);

  if (!isOldPasswordCorrect) {
    return 'Old password is incorrect';
  }

  try {
    // Check if the user is authenticated
    final user = SupaFlow.client.auth.currentUser;
    if (user == null) {
      return 'User is not authenticated';
    }

    // Attempt to update the user's password
    final response = await SupaFlow.client.auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );

    // Check the response and return an appropriate message
    if (response.user != null) {
      return 'Password updated successfully';
    } else {
      return 'Update failed: Unknown error';
    }
  } catch (e) {
    return 'Error updating password: $e';
  }
}

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

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!

Future<String> editPassword(String oldPassword, String newPassword) async {
  try {
    // First, verify the old password
    bool isOldPasswordCorrect = await verifyPassword(oldPassword);

    if (!isOldPasswordCorrect) {
      return 'Old password is incorrect';
    }

    // If old password is correct, proceed to update the password
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

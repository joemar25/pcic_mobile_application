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

Future<void> editPassword(String oldPassword, String newPassword) async {
  bool isVerified = await verifyPassword(oldPassword);
  if (isVerified) {
    bool isUpdated = await updatePassword(newPassword);
    if (isUpdated) {
      // Show success message
      showSnackBar(context, "Password updated successfully");
    } else {
      // Show error message
      showSnackBar(context, "Failed to update password");
    }
  } else {
    // Show error message
    showSnackBar(context, "Current password is incorrect");
  }
}

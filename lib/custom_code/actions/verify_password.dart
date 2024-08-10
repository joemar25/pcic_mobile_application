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

Future<bool> verifyPassword(String currentPassword) async {
  try {
    final user = SupaFlow.client.auth.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return false;
    }

    // Use Supabase's signIn method to verify the password
    final response = await SupaFlow.client.auth.signInWithPassword(
      email: user.email!,
      password: currentPassword,
    );

    return response.user != null;
  } catch (e) {
    print('Error verifying password: $e');
    return false;
  }
}

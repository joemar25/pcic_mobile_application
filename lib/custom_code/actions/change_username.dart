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

import 'package:supabase/supabase.dart'; // Import necessary package

Future<void> changeUsername(String newUsername) async {
  // Get the current user's ID
  final user = Supabase.instance.client.auth.currentUser;
  final userId = user?.id;

  // Ensure user ID is not null
  if (userId == null) {
    throw Exception('User is not authenticated');
  }

  // Update the user's username in the database
  final response = await Supabase.instance.client
      .from('users')
      .update({'username': newUsername})
      .eq('id', userId)
      .execute();

  // Check if the update was successful
  if (response.error != null) {
    throw response.error!;
  }
}

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

Future<bool> changeUsername(String newUsername) async {
  // Assuming the user is already authenticated
  final response = await SupaFlow.client
      .from('users')
      .update({'inspector_name': newUsername})
      .eq('id', SupaFlow.client.auth.currentUser?.id)
      .execute();

  // Check for errors in the response
  if (response.error != null) {
    print(response.error!.message);
    return false;
  }

  return true;
}

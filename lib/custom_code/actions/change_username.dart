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

import 'package:supabase/supabase.dart'; // Import Supabase here

Future<bool> changeUsername(String newUsername) async {
  // This custom action is for changing the inspector_name using Supabase

  final supabaseClient = SupabaseClient('SUPABASE_URL', 'SUPABASE_ANON_KEY');
  final user = supabaseClient.auth.user();

  if (user != null) {
    final response = await supabaseClient
        .from('users')
        .update({'inspector_name': newUsername})
        .eq('id', user.id)
        .execute();

    if (response.error != null) {
      print(response.error!.message);
      return false;
    }

    return true;
  }

  // Return false if the user is not authenticated
  return false;
}

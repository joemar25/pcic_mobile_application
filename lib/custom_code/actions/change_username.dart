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

import '/backend/supabase/supabase.dart'; // Ensure this path is correct

Future<bool> changeUsername(String newUsername) async {
  // This action is for changing the user's username using Supabase. The placeholder for the username is inspector_name.
  try {
    final supabaseClient =
        Supabase.instance.client; // Accessing Supabase client
    final user = supabaseClient.auth.currentUser;

    if (user != null) {
      final response = await supabaseClient
          .from('users')
          .update({'inspector_name': newUsername})
          .eq('id', user.id)
          .execute();

      if (response.error != null) {
        throw response.error!;
      }
      return true;
    } else {
      throw Exception('User not authenticated');
    }
  } catch (e) {
    print('Error changing username: $e');
    return false;
  }
}

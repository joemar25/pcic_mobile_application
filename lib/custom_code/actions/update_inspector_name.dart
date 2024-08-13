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

Future<void> updateInspectorName(String newName) async {
  final supabase = Supabase.instance.client;
  try {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    final response = await supabase
        .from('users')
        .update({'inspector_name': newName})
        .eq('auth_user_id', user.id)
        .select();

    if (response == null || response.isEmpty) {
      throw Exception('Update failed: No rows affected');
    }

    print('Inspector name updated successfully: $response');
  } catch (error) {
    print('Error updating inspector name: $error');
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!

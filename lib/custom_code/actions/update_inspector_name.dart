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
    // Get the current user's ID
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }

    final response = await supabase
        .from('users')
        .update({'inspector_name': newName}).eq(
            'id', user.id); //changed auth_user_id to id

    // The response might be null if the update was successful
    if (response == null) {
      print('Inspector name updated successfully');
    } else {
      // If there's an error, it will be in the response
      throw Exception('Failed to update inspector name');
    }
  } catch (error) {
    print('Error updating inspector name: $error');
    // You might want to show an error message to the user here
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!

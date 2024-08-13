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
    await supabase
        .from('inspectors') // Replace with your actual table name
        .update({'inspector_name': newName}).eq(
            'id', currentUserId); // Ensure you have the correct user ID

    // Optionally handle success
  } catch (error) {
    // Handle any errors
    print('Error updating inspector name: $error');
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!

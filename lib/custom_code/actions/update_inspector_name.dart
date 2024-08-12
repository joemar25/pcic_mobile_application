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

import 'package:supabase/supabase.dart';

Future<void> updateInspectorName(String userId, String newInspectorName) async {
  final client = SupaFlow.client;

  try {
    final response = await client
        .from('profiles') // Replace 'profiles' with your actual table name
        .update({'inspector_name': newInspectorName})
        .eq('id', userId) // Assuming 'id' is the primary key column
        .execute();

    if (response.error != null) {
      throw Exception(
          'Failed to update inspector name: ${response.error!.message}');
    }

    print('Inspector name updated successfully.');
  } catch (e) {
    print('Error updating inspector name: $e');
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!

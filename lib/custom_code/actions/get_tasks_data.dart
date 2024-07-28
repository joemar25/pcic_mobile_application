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

Future<List<TasksRow>?> getTasksData(String? status) async {
  try {
    final supabase = SupaFlow.client;

    var query = supabase.from('tasks').select().eq('is_deleted', false);

    if (status != null && status.isNotEmpty) {
      query = query.eq('status', status);
    }

    final response = await query;

    // The response is a List<Map<String, dynamic>>
    final List<Map<String, dynamic>> data = response;

    // Use the TasksRow constructor to create TasksRow objects
    return data.map((json) => TasksRow(json)).toList();
  } catch (e) {
    print('Error fetching tasks: $e');
    return null;
  }
}

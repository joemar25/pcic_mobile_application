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

Future<int> isDirtyCount() async {
  // Fetch all ppir forms
  List<SelectPpirFormsRow> ppirList =
      await SQLiteManager.instance.selectPpirForms();

  // Initialize a counter for dirty records
  int dirtyCount = 0;

  // Iterate through the list and count how many are dirty
  for (var ppir in ppirList) {
    var value = ppir.data['is_dirty'];

    // Check if the value is dirty (either 1 or true)
    if (value == 1 || value == true) {
      dirtyCount++;
    }
  }

  return dirtyCount;
}

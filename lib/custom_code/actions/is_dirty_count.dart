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

import '/auth/supabase_auth/auth_util.dart';

Future<String> isDirtyCount() async {
  // Fetch all ppir forms using the COUNTIsDirtyRow type
  List<COUNTIsDirtyRow> ppirList =
      await SQLiteManager.instance.cOUNTIsDirty(assignee: currentUserUid);

  // Initialize a counter for dirty records
  int dirtyCount = 0;

  // Iterate through the list and count how many are dirty
  for (var ppir in ppirList) {
    print('ppir -> ${ppir.data}');
    var value = ppir.data['ppir_is_dirty'];

    if (value == 1 || value == '1' || value == true || value == 'true') {
      dirtyCount++;
    }
  }

  // Return the count as a string
  return dirtyCount.toString();
}

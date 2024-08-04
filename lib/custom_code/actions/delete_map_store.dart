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

import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;

Future<void> deleteMapStore(BuildContext context, String storeName) async {
  bool confirmDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Deletion'),
        content:
            Text('Are you sure you want to delete the map store "$storeName"?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );

  if (confirmDelete == true) {
    try {
      final mgmt = FMTC.FMTCStore(storeName).manage;
      await mgmt.delete();
      print('Deleted store "$storeName".');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully deleted map store "$storeName".')),
      );
    } catch (e) {
      print('Error occurred while trying to delete store "$storeName": $e');

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to delete map store "$storeName". Error: $e')),
      );
    }
  }
}

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

Future fetchMbTiles() async {
  final String bucketName = 'mb-files';
  final String fileName = 'trails.mbtiles';

  try {
    print('Attempting to fetch $fileName from $bucketName bucket...');

    final bytes =
        await SupaFlow.client.storage.from(bucketName).download(fileName);

    if (bytes != null) {
      print('Successfully fetched $fileName. File size: ${bytes.length} bytes');
    } else {
      print('Failed to fetch $fileName. The downloaded data is null.');
    }
  } catch (e) {
    print('Error fetching MBTiles: $e');
  }
}

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
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> fetchProcessAndExportStores() async {
  print('Starting fetchProcessAndExportStores function...');

  try {
    // Step 1: Fetch statistics and store data.
    print('Initializing FMTC stats...');
    final stats =
        FMTC.FMTCRoot.stats; // Ensure you access the correct FMTC instance.
    print('Fetching storesAvailable from FMTC...');

    final storesAvailable = await stats.storesAvailable;
    print('Number of stores available: ${storesAvailable.length}');

    // Step 2: Handle case with no stores.
    if (storesAvailable.isEmpty) {
      print('No stores available. Exiting function.');
      return;
    }

    // Step 3: Process each store and print its name.
    print('Processing available stores...');
    List<MapStatsStruct> updatedList = [];

    for (int i = 0; i < storesAvailable.length; i++) {
      print('Processing store ${i + 1} of ${storesAvailable.length}...');
      final store = storesAvailable[i];
      String rawStoreName =
          store.storeName; // Ensure this matches the store name property.
      print('Raw store name: $rawStoreName');
      updatedList.add(store);
      print('Store ${i + 1} processed and added to the list.');
    }

    print(
        'All stores processed. Total stores in updated list: ${updatedList.length}');

    // Step 4: Export the store data to a specified path.
    print('Retrieving external storage directory...');
    final directory =
        await getExternalStorageDirectory(); // For Android-specific path.
    final exportPath = '${directory?.path}/exported_tiles.fmtc';
    print('Export path determined: $exportPath');

    print('Starting export process...');
    // Ensure you access the export method correctly from the FMTC instance or the specific store.
    await FMTC.instance.export(exportPath);
    print('Tiles exported successfully to: $exportPath');
  } catch (e) {
    print('Error during fetching, processing, or exporting stores: $e');
  }

  print('fetchProcessAndExportStores function completed.');
}

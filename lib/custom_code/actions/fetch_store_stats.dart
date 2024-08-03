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

Future<void> fetchStoreStats() async {
  try {
    final stats = FMTC.FMTCRoot.stats;
    final storesAvailable = await stats.storesAvailable;

    // Fetch and add information for each store
    for (final store in storesAvailable) {
      final storeStats = FMTC.FMTCRoot.stats;
      final storeRealSize = await storeStats.realSize;
      final storeLength = await storeStats.length;

      // Clean the storeName: remove symbols, separate words with spaces, and capitalize
      final cleanedStoreName = store.storeName
          .replaceAll(RegExp(r'[^a-zA-Z0-9\s]'),
              ' ') // Remove symbols and replace with space
          .split(' ')
          .where((part) => part.isNotEmpty) // Remove empty parts
          .map((part) => capitalizeWords(part))
          .join(' ');

      FFAppState().listOfMapDownloads.add(
            MapStatsStruct(
              storeName: cleanedStoreName,
              realSize: storeRealSize.toStringAsFixed(2),
              numberOfTiles: storeLength.toString(),
            ),
          );

      // Print individual store statistics (you can keep or remove these print statements)
      print('\nStore: ${store.storeName}');
      print('Real Size: ${storeRealSize.toStringAsFixed(2)} KiB');
      print('Tiles: $storeLength');
      print(FFAppState().listOfMapDownloads);
    }
  } catch (e) {
    print('Error fetching FMTC stats: $e');
  }
}

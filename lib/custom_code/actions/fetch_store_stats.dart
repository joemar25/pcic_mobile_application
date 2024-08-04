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

    List<MapStatsStruct> updatedList = [];

    for (final store in storesAvailable) {
      String rawStoreName = store.storeName;
      String cleanedStoreName = cleanStoreName(rawStoreName);

      final storeStats = FMTC.FMTCStore(store.storeName).stats;
      String storeSize = (await storeStats.size).toString();
      String storeLength = (await storeStats.length).toString();

      updatedList.add(MapStatsStruct(
          storeName: cleanedStoreName,
          size: 'Size: ${storeSize}',
          length: 'Totol Tiles ${storeLength}',
          rawStoreName: rawStoreName));
    }

    FFAppState().listOfMapDownloads = updatedList;
  } catch (e) {
    print('Error fetching FMTC stats: $e');
  }
}

String cleanStoreName(String rawName) {
  List<String> parts = rawName.split('__');
  parts = parts
      .map((part) => part.split('_').map((word) => word.capitalize()).join(' '))
      .toList();
  return parts.join(', ');
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

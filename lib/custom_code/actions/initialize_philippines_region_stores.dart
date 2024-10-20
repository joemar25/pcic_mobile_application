// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;

Future initializePhilippinesRegionStores() async {
  // Add your function code here!
  final regions = [
    {'name': 'Ilocos Region', 'number': 'Region I'},
    {'name': 'Cagayan Valley', 'number': 'Region II'},
    {'name': 'Central Luzon', 'number': 'Region III'},
    {'name': 'CALABARZON', 'number': 'Region IV-A'},
    {'name': 'MIMAROPA', 'number': 'Region IV-B'},
    {'name': 'Bicol Region', 'number': 'Region V'},
    {'name': 'Western Visayas', 'number': 'Region VI'},
    {'name': 'Central Visayas', 'number': 'Region VII'},
    {'name': 'Eastern Visayas', 'number': 'Region VIII'},
    {'name': 'Zamboanga Peninsula', 'number': 'Region IX'},
    {'name': 'Northern Mindanao', 'number': 'Region X'},
    {'name': 'Davao Region', 'number': 'Region XI'},
    {'name': 'SOCCSKSARGEN', 'number': 'Region XII'},
    {'name': 'Caraga', 'number': 'Region XIII'},
    {'name': 'Cordillera Administrative Region', 'number': 'CAR'},
    {'name': 'National Capital Region', 'number': 'NCR'},
    {
      'name': 'Bangsamoro Autonomous Region in Muslim Mindanao',
      'number': 'BARMM'
    },
  ];

  for (final region in regions) {
    final storeName = '${region['number']}_${region['name']}'
        .replaceAll(' ', '_')
        .toLowerCase();
    final mgmt = FMTC.FMTCStore(storeName).manage;
    try {
      await mgmt.create();
      print(
          'Store created successfully for ${region['name']} (${region['number']})');
    } catch (e) {
      print(
          'Error creating store for ${region['name']} (${region['number']}): $e');
    }
  }
}

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

import 'index.dart'; // Imports other custom actions

import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;

Future<void> initializePhilippinesRegionStores() async {
  // Read GeoJSON file from assets
  String jsonString =
      await rootBundle.loadString('assets/jsons/philippines-with-regions.json');
  Map<String, dynamic> geoJson = json.decode(jsonString);

  Map<String, Map<String, double>> regionBoundingBoxes =
      calculateRegionBoundingBoxes(geoJson);

  for (var entry in regionBoundingBoxes.entries) {
    String region = entry.key;
    Map<String, double> bbox = entry.value;

    String storeName = region.replaceAll(' ', '_').toLowerCase();
    final mgmt = FMTC.FMTCStore(storeName).manage;

    try {
      await mgmt.create();
      print('Store created successfully for $region');

      // Set metadata for the region's bounding box
      await FMTC.FMTCStore(storeName).metadata.setBulk(kvs: {
        'minLat': bbox['minLat'].toString(),
        'maxLat': bbox['maxLat'].toString(),
        'minLon': bbox['minLon'].toString(),
        'maxLon': bbox['maxLon'].toString(),
      });
      print('Bounding box metadata set for $region');
    } catch (e) {
      print('Error processing $region: $e');
    }
  }
}

Map<String, Map<String, double>> calculateRegionBoundingBoxes(
    Map<String, dynamic> geoJson) {
  Map<String, Map<String, double>> regionBoundingBoxes = {};

  for (var feature in geoJson['features']) {
    String provinceName = feature['properties']['name'];
    String region = getRegionForProvince(provinceName);

    if (region.isEmpty) continue;

    if (!regionBoundingBoxes.containsKey(region)) {
      regionBoundingBoxes[region] = {
        'minLat': double.infinity,
        'maxLat': double.negativeInfinity,
        'minLon': double.infinity,
        'maxLon': double.negativeInfinity
      };
    }

    var coordinates = feature['geometry']['coordinates'];
    updateBoundingBox(coordinates, regionBoundingBoxes[region]!);
  }

  return regionBoundingBoxes;
}

void updateBoundingBox(dynamic coordinates, Map<String, double> bbox) {
  if (coordinates is List) {
    if (coordinates.isEmpty) return;
    if (coordinates[0] is num) {
      // We've reached a single coordinate pair
      double lon = coordinates[0].toDouble();
      double lat = coordinates[1].toDouble();
      bbox['minLat'] = min(bbox['minLat']!, lat);
      bbox['maxLat'] = max(bbox['maxLat']!, lat);
      bbox['minLon'] = min(bbox['minLon']!, lon);
      bbox['maxLon'] = max(bbox['maxLon']!, lon);
    } else {
      // We're still in a nested structure, recurse
      for (var coord in coordinates) {
        updateBoundingBox(coord, bbox);
      }
    }
  }
}

String getRegionForProvince(String provinceName) {
  Map<String, List<String>> regionProvinces = {
    'Region I': ['Ilocos Norte', 'Ilocos Sur', 'La Union', 'Pangasinan'],
    'Region II': ['Batanes', 'Cagayan', 'Isabela', 'Nueva Vizcaya', 'Quirino'],
    'Region III': [
      'Aurora',
      'Bataan',
      'Bulacan',
      'Nueva Ecija',
      'Pampanga',
      'Tarlac',
      'Zambales'
    ],
    'Region IV-A': ['Batangas', 'Cavite', 'Laguna', 'Quezon', 'Rizal'],
    'Region IV-B': [
      'Marinduque',
      'Occidental Mindoro',
      'Oriental Mindoro',
      'Palawan',
      'Romblon'
    ],
    'Region V': [
      'Albay',
      'Camarines Norte',
      'Camarines Sur',
      'Catanduanes',
      'Masbate',
      'Sorsogon'
    ],
    'Region VI': [
      'Aklan',
      'Antique',
      'Capiz',
      'Guimaras',
      'Iloilo',
      'Negros Occidental'
    ],
    'Region VII': ['Bohol', 'Cebu', 'Negros Oriental', 'Siquijor'],
    'Region VIII': [
      'Biliran',
      'Eastern Samar',
      'Leyte',
      'Northern Samar',
      'Samar',
      'Southern Leyte'
    ],
    'Region IX': [
      'Zamboanga del Norte',
      'Zamboanga del Sur',
      'Zamboanga Sibugay'
    ],
    'Region X': [
      'Bukidnon',
      'Camiguin',
      'Lanao del Norte',
      'Misamis Occidental',
      'Misamis Oriental'
    ],
    'Region XI': [
      'Davao de Oro',
      'Davao del Norte',
      'Davao del Sur',
      'Davao Oriental'
    ],
    'Region XII': [
      'North Cotabato',
      'Sarangani',
      'South Cotabato',
      'Sultan Kudarat'
    ],
    'Region XIII': [
      'Agusan del Norte',
      'Agusan del Sur',
      'Dinagat Islands',
      'Surigao del Norte',
      'Surigao del Sur'
    ],
    'NCR': ['Metropolitan Manila'],
    'CAR': [
      'Abra',
      'Apayao',
      'Benguet',
      'Ifugao',
      'Kalinga',
      'Mountain Province'
    ],
    'BARMM': ['Basilan', 'Lanao del Sur', 'Maguindanao', 'Sulu', 'Tawi-Tawi']
  };

  for (var entry in regionProvinces.entries) {
    if (entry.value.contains(provinceName)) {
      return entry.key;
    }
  }

  return '';
}

Future<void> initializeRegionStores() async {
  await initializePhilippinesRegionStores();
}

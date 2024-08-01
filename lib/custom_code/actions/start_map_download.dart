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
import 'package:latlong2/latlong.dart' as ll;
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

Future<void> startMapDownload(String accessToken) async {
  final Map<String, LatLngBounds> _regions = {
    'Ilocos Region': LatLngBounds(
        ll.LatLng(15.2833, 119.8333), ll.LatLng(18.5667, 121.1667)),
    'Cagayan Valley': LatLngBounds(
        ll.LatLng(16.0260, 120.5853), ll.LatLng(19.3333, 123.3333)),
    'Central Luzon': LatLngBounds(
        ll.LatLng(14.0000, 119.5000), ll.LatLng(16.8333, 122.0000)),
    'CALABARZON': LatLngBounds(
        ll.LatLng(13.5667, 120.5667), ll.LatLng(15.3333, 122.0000)),
    'MIMAROPA':
        LatLngBounds(ll.LatLng(9.0000, 117.0000), ll.LatLng(13.2500, 121.0000)),
    'Bicol Region': LatLngBounds(
        ll.LatLng(11.5833, 122.0000), ll.LatLng(14.3333, 124.5000)),
    'NCR': LatLngBounds(ll.LatLng(14.3, 120.95), ll.LatLng(14.8667, 121.2)),
    'Cordillera Administrative Region': LatLngBounds(
        ll.LatLng(15.8295, 120.3505), ll.LatLng(18.0058, 122.1340)),
    'Western Visayas': LatLngBounds(
        ll.LatLng(10.1167, 121.0000), ll.LatLng(12.1167, 123.5833)),
    'Central Visayas':
        LatLngBounds(ll.LatLng(9.0000, 122.0000), ll.LatLng(11.3333, 125.0000)),
    'Eastern Visayas':
        LatLngBounds(ll.LatLng(9.5000, 124.0000), ll.LatLng(12.2500, 127.0000)),
    'Zamboanga Peninsula':
        LatLngBounds(ll.LatLng(6.6167, 120.5000), ll.LatLng(8.5000, 123.5000)),
    'Northern Mindanao':
        LatLngBounds(ll.LatLng(7.8333, 123.0000), ll.LatLng(9.3000, 126.0000)),
    'Davao Region':
        LatLngBounds(ll.LatLng(5.2000, 124.0000), ll.LatLng(8.5000, 127.0000)),
    'SOCCSKSARGEN':
        LatLngBounds(ll.LatLng(5.8667, 123.0000), ll.LatLng(7.8333, 126.5000)),
    'Caraga':
        LatLngBounds(ll.LatLng(7.8000, 124.5000), ll.LatLng(10.0000, 126.6000)),
    'BARMM':
        LatLngBounds(ll.LatLng(4.6000, 118.5000), ll.LatLng(8.2000, 125.5000)),
  };

  // Check location permission and services
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled, show an alert dialog
    print('Location services are not enabled');
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, show an alert dialog
      print('Location permissions are denied');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, show an alert dialog
    print('Location permissions are permanently denied');
    return;
  }

  // Get the current position
  Position position = await Geolocator.getCurrentPosition();
  ll.LatLng currentLocation = ll.LatLng(position.latitude, position.longitude);

  // Determine the region based on the position
  LatLngBounds? selectedBounds;
  for (var region in _regions.values) {
    if (region.contains(currentLocation)) {
      selectedBounds = region;
      break;
    }
  }

  // Use the selected region bounds or default to the whole Philippines if not found
  final bounds = selectedBounds ??
      LatLngBounds(
        ll.LatLng(4.6, 116.9),
        ll.LatLng(21.2, 126.6),
      );

  final region = FMTC.RectangleRegion(bounds);
  final downloadableRegion = region.toDownloadable(
    minZoom: 10,
    maxZoom: 22, // Higher zoom level for more detail
    options: TileLayer(
      urlTemplate:
          'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}@2x?access_token=$accessToken',
      additionalOptions: {
        'accessToken': accessToken,
        'id': 'mapbox/satellite-v9',
      },
    ),
  );

  await FMTC.FMTCStore('mapStore')
      .download
      .startForeground(
        region: downloadableRegion,
        parallelThreads: 5,
        maxBufferLength: 200,
        skipExistingTiles: false,
        skipSeaTiles: true,
        maxReportInterval: Duration(seconds: 1),
      )
      .listen((progress) {
    print('Download progress: ${progress.percentageProgress}%');
  });
}

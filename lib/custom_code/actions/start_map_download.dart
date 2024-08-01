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
import 'dart:math';

Future<void> startMapDownload(String accessToken) async {
  bool serviceEnabled;
  LocationPermission permission;
  double lastReportedProgress = 0.0;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('Location services are not enabled');
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print('Location permissions are permanently denied');
    return;
  }

  // Get the current position
  Position position = await Geolocator.getCurrentPosition();
  ll.LatLng currentLocation = ll.LatLng(position.latitude, position.longitude);

  // Create a bounding box around the user's location (approximately 5km in each direction)
  double latDelta = 0.045; // Roughly 5km in latitude
  double lonDelta = 0.045 /
      cos(currentLocation.latitude *
          pi /
          180); // Adjust for longitude based on latitude

  LatLngBounds bounds = LatLngBounds(
    ll.LatLng(currentLocation.latitude - latDelta,
        currentLocation.longitude - lonDelta),
    ll.LatLng(currentLocation.latitude + latDelta,
        currentLocation.longitude + lonDelta),
  );

  final region = FMTC.RectangleRegion(bounds);
  final downloadableRegion = region.toDownloadable(
    minZoom: 10,
    maxZoom: 22, // Adjusted max zoom for faster download
    options: TileLayer(
      urlTemplate:
          'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}@2x?access_token=${accessToken}',
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
        parallelThreads: 10,
        maxBufferLength: 500,
        skipExistingTiles: true,
        skipSeaTiles: true,
        maxReportInterval: Duration(seconds: 1),
      )
      .listen((progress) {
    double currentProgress =
        double.parse(progress.percentageProgress.toStringAsFixed(2));

    // Only update if the progress has changed by at least 1%
    if ((currentProgress - lastReportedProgress).abs() >= 1.0) {
      FFAppState().mapDownloadProgress = currentProgress;
      lastReportedProgress = currentProgress;

      print('Download progress: ${FFAppState().mapDownloadProgress}%');
      print(progress.percentageProgress);

      // Update notification here if you're using one
      // updateNotification(currentProgress);
    }

    if (progress.isComplete) {
      print('Download is complete!');
      FFAppState().mapDownloadProgress = 100.0;

      // Show completion notification or update UI here
      // showCompletionNotification();
    }
  });
}

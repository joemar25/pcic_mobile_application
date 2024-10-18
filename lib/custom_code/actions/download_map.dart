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

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;
import 'package:latlong2/latlong.dart';

Future<void> downloadMap(BuildContext context, String? accessToken) async {
  final String storeName =
      'AlbayRegion'; // Unique name for the Albay region store

  final albayRegion = FMTC.CustomPolygonRegion(
    [
      LatLng(13.376564, 123.533997),
      LatLng(13.42803, 123.589447),
      LatLng(13.5172, 123.550148),
      LatLng(13.52329, 123.6008),
      LatLng(13.47831, 123.676971),
      LatLng(13.32355, 123.745071),
      LatLng(13.28899, 123.814102),
      LatLng(13.23599, 123.831497),
      LatLng(13.26634, 123.842941),
      LatLng(13.23049, 123.869682),
      LatLng(13.22796, 123.774681),
      LatLng(13.1683, 123.754219),
      LatLng(13.11425, 123.785812),
      LatLng(13.06554, 123.752449),
      LatLng(13.04797, 123.802887),
      LatLng(13.13731, 123.864754),
      LatLng(13.14126, 123.905609),
      LatLng(13.1181, 123.939972),
      LatLng(13.04421, 123.908073),
      LatLng(12.98583, 123.768646),
      LatLng(13.02409, 123.733742),
      LatLng(13.01038, 123.628693),
      LatLng(13.03101, 123.573997),
      LatLng(12.98889, 123.480278),
      LatLng(13.04595, 123.406548),
      LatLng(13.00694, 123.31942),
      LatLng(13.05416, 123.29805),
      LatLng(13.05816, 123.280777),
      LatLng(13.14789, 123.288696),
      LatLng(13.19859, 123.327271),
      LatLng(13.26624, 123.275467),
      LatLng(13.36198, 123.434143),
      LatLng(13.376564, 123.533997),
    ],
  );

  try {
    // Create a store for caching Albay region tiles
    await FMTC.FMTCStore(storeName).manage.create();

    // Define the region and set download parameters
    final downloadableRegion = albayRegion.toDownloadable(
      minZoom: 12,
      maxZoom: 20,
      options: TileLayer(
        urlTemplate:
            'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}@2x?access_token=$accessToken',
        additionalOptions: {
          'accessToken': accessToken,
          'id': 'mapbox/satellite-v9',
        },
        userAgentPackageName:
            'com.yourdomain.yourapp', // Replace with your app's package name
      ),
    );

    // Check the number of tiles to download
    final tileCount = await FMTC.FMTCStore(storeName)
        .download
        .check(region: downloadableRegion);

    // Show confirmation dialog
    bool? shouldDownload = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Download'),
          content: Text(
              'Are you sure you want to download $tileCount tiles for the Albay region?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (shouldDownload == true) {
      // Start the download process for Albay region tiles
      await FMTC.FMTCStore(storeName)
          .download
          .startForeground(
            region: downloadableRegion,
            parallelThreads: 15,
            maxBufferLength: 100,
            skipExistingTiles: true,
            skipSeaTiles: true,
            maxReportInterval: Duration(seconds: 1),
            instanceId: DateTime.now().millisecondsSinceEpoch,
          )
          .listen((progress) {
        // Monitor the download progress
        print('Download progress: ${progress.percentageProgress}%');

        if (progress.isComplete) {
          print('Map download completed for Albay region.');
        }
      });
    } else {
      print('Map download cancelled by user.');
    }
  } catch (e) {
    print('Failed to download map: $e');
  }
}

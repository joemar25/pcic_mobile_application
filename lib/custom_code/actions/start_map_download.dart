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

import 'package:p_c_i_c_mobile_app/app_state.dart';

import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;
import 'package:latlong2/latlong.dart' as ll;
import 'package:flutter_map/flutter_map.dart';

Future startMapDownload(String accessToken) async {
  // Add your function code here!

  final bounds = LatLngBounds(
    ll.LatLng(4.6, 116.9),
    ll.LatLng(21.2, 126.6),
  );
  final region = FMTC.RectangleRegion(bounds);
  final downloadableRegion = region.toDownloadable(
    minZoom: 10,
    maxZoom: 22, // Higher zoom level for more detail
    options: TileLayer(
      urlTemplate:
          'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',
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
    int roundedProgress = (progress.percentageProgress * 100).round();
    FFAppState().mapDownloadProgress = roundedProgress.toDouble();
  });
}

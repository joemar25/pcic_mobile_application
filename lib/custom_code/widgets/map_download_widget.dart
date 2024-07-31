// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:flutter_map/flutter_map.dart';

class MapDownloadWidget extends StatefulWidget {
  const MapDownloadWidget({
    super.key,
    this.width,
    this.height,
    required this.accessToken,
  });

  final double? width;
  final double? height;
  final String accessToken;

  @override
  State<MapDownloadWidget> createState() => _MapDownloadWidgetState();
}

class _MapDownloadWidgetState extends State<MapDownloadWidget> {
  Future<void> startDownload() async {
    final bounds = LatLngBounds(
      ll.LatLng(4.6, 116.9),
      ll.LatLng(21.2, 126.6),
    );
    final region = RectangleRegion(bounds);
    final downloadableRegion = region.toDownloadable(
      minZoom: 0,
      maxZoom: 10,
      options: TileLayer(
        urlTemplate:
            'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
        additionalOptions: {
          'accessToken': widget.accessToken,
          'id': 'mapbox/satellite-v9',
        },
      ),
    );

    // Listen to the Stream to handle the result and remove the warning
    await FMTCStore('mapStore')
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
      // Handle progress here if needed, or keep this to acknowledge the stream
      print('Download progress: ${progress}%');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map Download Widget')),
      body: Center(
        child: ElevatedButton(
          onPressed: startDownload,
          child: Text('Start Download'),
        ),
      ),
    );
  }
}

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

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart' as ll;

class OfflineMap extends StatefulWidget {
  const OfflineMap({
    super.key,
    this.width,
    this.height,
    required this.accessToken,
  });

  final double? width;
  final double? height;
  final String accessToken;

  @override
  State<OfflineMap> createState() => _OfflineMapState();
}

class _OfflineMapState extends State<OfflineMap> {
  late FMTCStore mapStore;

  @override
  void initState() {
    super.initState();
    initializeTileCaching();
  }

  void initializeTileCaching() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FMTC.instance('mapStore').manage.create();
    mapStore = FMTC.instance('mapStore');
  }

  void startDownload() async {
    final bounds = LatLngBounds(
      ll.LatLng(4.6, 116.9), // Southwest corner of the Philippines
      ll.LatLng(21.2, 126.6), // Northeast corner of the Philippines
    );
    final region = RectangleRegion(bounds: bounds);
    final downloadableRegion = region.asDownloadable(
      minZoom: 0,
      maxZoom: 10,
    );
    await mapStore.download.startForegroundTask(
      regions: [downloadableRegion],
      progressListener: (progress) {
        print('Download progress: ${progress.progress}%');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Offline Map Bulk Downloading')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter:
              ll.LatLng(12.8797, 121.7740), // Center of the Philippines
          initialZoom: 5.0,
        ),
        layers: [
          TileLayer(
            tileProvider: mapStore.getTileProvider(),
            urlTemplate:
                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: {
              'accessToken': widget.accessToken,
              'id': 'your_mapbox_style_id',
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.download),
        onPressed: startDownload,
      ),
    );
  }
}

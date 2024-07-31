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
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => startMapDownload(widget.accessToken),
      child: Text('Download Map'),
    );
  }
}

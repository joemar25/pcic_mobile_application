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
import 'package:latlong2/latlong.dart' as ll;
import 'package:mbtiles/mbtiles.dart'; // Import the mbtiles library
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p; // To handle paths
import 'dart:io';
import 'package:http/http.dart' as http; // For downloading the file

class MapTest extends StatefulWidget {
  const MapTest({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<MapTest> createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  late MBTiles mbtiles;
  bool isMbtilesLoaded = false;

  @override
  void initState() {
    super.initState();
    _downloadAndLoadMbtiles();
  }

  Future<void> _downloadAndLoadMbtiles() async {
    try {
      final String supabaseFileUrl =
          'https://your-supabase-url/storage/v1/object/public/mb-files/trails.mbtiles';
      final String localFilePath = await _getLocalFilePath('trails.mbtiles');

      // Check if file already exists locally
      if (!File(localFilePath).existsSync()) {
        // Download the MBTiles file from Supabase
        final response = await http.get(Uri.parse(supabaseFileUrl));

        if (response.statusCode != 200) {
          throw Exception('Failed to download MBTiles');
        }

        // Write the downloaded bytes to a local file
        await File(localFilePath).writeAsBytes(response.bodyBytes);
      }

      // Load the local MBTiles database
      mbtiles = await MBTiles.open(localFilePath);
      setState(() {
        isMbtilesLoaded = true; // Trigger a rebuild once the MBTiles are loaded
      });
    } catch (e) {
      print('Error downloading or loading MBTiles: $e');
    }
  }

  Future<String> _getLocalFilePath(String fileName) async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    return p.join(dir, fileName);
  }

  @override
  Widget build(BuildContext context) {
    if (!isMbtilesLoaded) {
      return Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: FlutterMap(
        options: MapOptions(
          center: LatLng(12.8797, 121.7740), // Center on the Philippines
          zoom: 10.0,
          maxZoom: 19.0,
          minZoom: 5.0,
        ),
        layers: [
          TileLayerOptions(
            tileProvider: _MbtilesTileProvider(mbtiles),
            maxZoom: 19,
            minZoom: 5,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mbtiles.close(); // Close the MBTiles database when no longer needed
    super.dispose();
  }
}

class _MbtilesTileProvider extends TileProvider {
  final MBTiles mbtiles;

  _MbtilesTileProvider(this.mbtiles);

  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    final zoom = coords.z.round();
    final x = coords.x.round();
    final y =
        (1 << zoom) - 1 - coords.y.round(); // MBTiles uses TMS y-coordinate

    final tileData = mbtiles.getTile(zoom, x, y);
    if (tileData != null) {
      return MemoryImage(tileData);
    } else {
      return const AssetImage(
          'assets/images/empty_tile.png'); // Placeholder if tile is not found
    }
  }
}

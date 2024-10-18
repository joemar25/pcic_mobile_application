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

import 'package:file_picker/file_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class MbTilesWidget extends StatefulWidget {
  const MbTilesWidget({
    super.key,
    this.width,
    this.height,
    this.accessToken,
  });

  final double? width;
  final double? height;
  final String? accessToken;

  @override
  State<MbTilesWidget> createState() => _MbTilesWidgetState();
}

class _MbTilesWidgetState extends State<MbTilesWidget> {
  Database? _mbtilesDatabase;
  String? _filePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Center(
        child: ElevatedButton(
          onPressed: _chooseAndOpenFile,
          child: Text('Choose and Render MBTiles'),
        ),
      ),
    );
  }

  Future<void> _chooseAndOpenFile() async {
    try {
      print('Opening file picker...');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        _filePath = result.files.single.path!;
        print('File selected: $_filePath');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File selected: $_filePath')),
        );

        // Open the database after selecting the file.
        await _openDatabase();
      } else {
        print('File picking was canceled.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File picking was canceled.')),
        );
      }
    } catch (e) {
      print('Error selecting file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _openDatabase() async {
    if (_filePath == null) return;

    try {
      print('Opening MBTiles database...');
      _mbtilesDatabase = await openDatabase(_filePath!);
      print('Database opened successfully: $_filePath');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('MBTiles database opened successfully!')),
      );

      setState(() {
        _showMapDialog(); // Show the map in a dialog once the database is opened.
      });
    } catch (e) {
      print('Error opening MBTiles database: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening MBTiles: $e')),
      );
    }
  }

  void _showMapDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: _buildMap(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _mbtilesDatabase?.close();
    print('Database closed.');
    super.dispose();
  }

  TileProvider getTileProvider() {
    print('Creating custom TileProvider...');
    return TileProvider.fromMBTiles(_mbtilesDatabase!);
  }

  Widget _buildMap() {
    if (_mbtilesDatabase == null) {
      return Center(child: CircularProgressIndicator());
    }

    return FlutterMap(
      options: MapOptions(
        center:
            LatLng(13.41, 122.56), // Adjust the center to your map's location
        zoom: 5.0,
      ),
      children: [
        TileLayer(
          tileProvider: getTileProvider(),
          minZoom: 18,
          maxZoom: 22,
          urlTemplate:
              'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}@2x?access_token=${widget.accessToken}',
          tileBuilder: (context, tile) {
            print('Rendering tile...');
            return Image.memory(
                tile); // Replace with your custom rendering logic.
          },
        ),
      ],
    );
  }
}

class TileProvider extends TileProvider {
  final Database database;

  TileProvider.fromMBTiles(this.database);

  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    print(
        'Fetching image for coords: Zoom ${coords.z}, X ${coords.x}, Y ${coords.y}');
    final tile =
        _getTileData(coords.z.toInt(), coords.x.toInt(), coords.y.toInt());
    if (tile != null) {
      print('Tile data found, rendering...');
      return MemoryImage(tile);
    } else {
      print('Tile data not found, using placeholder.');
      return NetworkImage(''); // Placeholder URL.
    }
  }

  Uint8List? _getTileData(int zoom, int x, int y) {
    print('Querying tile data for Zoom: $zoom, X: $x, Y: $y');
    List<Map<String, dynamic>> result = await database.query(
      'tiles',
      columns: ['tile_data'],
      where: 'zoom_level = ? AND tile_column = ? AND tile_row = ?',
      whereArgs: [zoom, x, y],
    );

    if (result.isNotEmpty) {
      print('Tile data retrieved successfully.');
      return result.first['tile_data'] as Uint8List;
    }
    print('No tile data found.');
    return null;
  }
}

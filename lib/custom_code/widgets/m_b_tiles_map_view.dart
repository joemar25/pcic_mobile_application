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
import 'package:latlong2/latlong.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class MBTilesMapView extends StatefulWidget {
  const MBTilesMapView({Key? key, this.width, this.height, this.accessToken})
      : super(key: key);

  final double? width;
  final double? height;
  final String? accessToken;

  @override
  State<MBTilesMapView> createState() => _MBTilesMapViewState();
}

class _MBTilesMapViewState extends State<MBTilesMapView> {
  String? selectedFilePath;
  LatLngBounds? mapBounds;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _pickFile,
            child: Text('Select .mbtiles file'),
          ),
          Expanded(
            child: selectedFilePath != null
                ? FlutterMap(
                    options: MapOptions(
                      bounds: mapBounds,
                      boundsOptions:
                          FitBoundsOptions(padding: EdgeInsets.all(8.0)),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'file://${selectedFilePath}/{z}/{x}/{y}.png',
                        tileProvider: MBTilesTileProvider(selectedFilePath!),
                      ),
                    ],
                  )
                : Center(child: Text('No file selected')),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mbtiles'],
    );

    if (result != null) {
      setState(() {
        selectedFilePath = result.files.single.path;
      });
      _loadMBTilesBounds();
    }
  }

  Future<void> _loadMBTilesBounds() async {
    if (selectedFilePath == null) return;

    if (!await File(selectedFilePath!).exists()) {
      print('MBTiles file not found: $selectedFilePath');
      return;
    }

    final db = await openDatabase(selectedFilePath!);

    try {
      final List<Map> metadata = await db.query('metadata');
      final boundsString = metadata
          .firstWhere((row) => row['name'] == 'bounds')['value'] as String;
      final bounds = boundsString.split(',').map(double.parse).toList();

      setState(() {
        mapBounds = LatLngBounds(
          LatLng(bounds[1], bounds[0]),
          LatLng(bounds[3], bounds[2]),
        );
      });
    } catch (e) {
      print('Error loading MBTiles bounds: $e');
    } finally {
      await db.close();
    }
  }
}

class MBTilesTileProvider extends TileProvider {
  final String mbtilesPath;

  MBTilesTileProvider(this.mbtilesPath);

  @override
  Future<Tile> getTile(int x, int y, int z) async {
    final db = await openDatabase(mbtilesPath);
    try {
      final List<Map> result = await db.query(
        'tiles',
        columns: ['tile_data'],
        where: 'zoom_level = ? AND tile_column = ? AND tile_row = ?',
        whereArgs: [z, x, (1 << z) - 1 - y],
      );

      if (result.isNotEmpty) {
        final tileData = result.first['tile_data'] as List<int>;
        return Tile.byteData(x, y, z, Uint8List.fromList(tileData));
      }
    } catch (e) {
      print('Error fetching tile: $e');
    } finally {
      await db.close();
    }

    return Tile.empty(x, y, z);
  }
}

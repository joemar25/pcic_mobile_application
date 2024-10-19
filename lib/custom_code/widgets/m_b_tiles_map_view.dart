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

import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:image/image.dart';

class MBTilesMapView extends StatefulWidget {
  const MBTilesMapView({
    Key? key,
    this.width,
    this.height,
    this.accessToken,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? accessToken;

  @override
  State<MBTilesMapView> createState() => _MBTilesMapViewState();
}

class _MBTilesMapViewState extends State<MBTilesMapView> {
  MapboxMapController? mapController;
  String? selectedFilePath;

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
                ? MapboxMap(
                    accessToken:
                        'YOUR_MAPBOX_ACCESS_TOKEN', // Replace with your token
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(0, 0),
                      zoom: 1,
                    ),
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
      if (mapController != null) {
        _loadMBTiles();
      }
    }
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    if (selectedFilePath != null) {
      _loadMBTiles();
    }
  }

  Future<void> _loadMBTiles() async {
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

      await mapController?.addSource(
          'mbtiles-source', MBTilesSource(selectedFilePath!));

      await mapController?.addLayer(
        'mbtiles-source',
        'mbtiles-layer',
        RasterLayerProperties(),
      );

      await mapController?.fitBounds(
        LatLngBounds(
          southwest: LatLng(bounds[1], bounds[0]),
          northeast: LatLng(bounds[3], bounds[2]),
        ),
      );
    } catch (e) {
      print('Error loading MBTiles: $e');
    } finally {
      await db.close();
    }
  }
}

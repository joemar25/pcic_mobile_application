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

import 'package:mbtiles/mbtiles.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

class MapTest extends StatefulWidget {
  const MapTest({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  State<MapTest> createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  String? _filePath;
  bool _isDownloading = false;
  MbTiles? _mbTiles;
  MbTilesMetadata? _metadata;
  Uint8List? _currentTile;

  @override
  void initState() {
    super.initState();
    _initMbTiles();
  }

  Future<void> _initMbTiles() async {
    final directory = await getApplicationDocumentsDirectory();
    _filePath = '${directory.path}/trails.mbtiles';
    if (await File(_filePath!).exists()) {
      await _loadMbTiles();
    }
  }

  Future<void> downloadMbTiles() async {
    setState(() {
      _isDownloading = true;
    });

    final String bucketName = 'mb-files';
    final String fileName = 'trails.mbtiles';

    try {
      print('Attempting to fetch $fileName from $bucketName bucket...');

      final bytes =
          await SupaFlow.client.storage.from(bucketName).download(fileName);

      if (bytes != null) {
        print(
            'Successfully fetched $fileName. File size: ${bytes.length} bytes');
        await File(_filePath!).writeAsBytes(bytes);
        await _loadMbTiles();
      } else {
        print('Failed to fetch $fileName. The downloaded data is null.');
      }
    } catch (e) {
      print('Error fetching MBTiles: $e');
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  Future<void> _loadMbTiles() async {
    try {
      // Ensure SQLite is initialized
      await SQLiteManager.initialize();

      _mbTiles = MbTiles(mbtilesPath: _filePath!);
      _metadata = await _mbTiles!.getMetadata();
      await _loadTile(0, 0, 0); // Load the first tile as an example
      setState(() {});
      print('MBTiles loaded successfully. Metadata: $_metadata');
    } catch (e) {
      print('Error loading MBTiles: $e');
    }
  }

  Future<void> _loadTile(int z, int x, int y) async {
    try {
      final tileData = await _mbTiles?.getTile(z: z, x: x, y: y);
      if (tileData != null) {
        setState(() {
          _currentTile = tileData;
        });
      }
    } catch (e) {
      print('Error loading tile: $e');
    }
  }

  @override
  void dispose() {
    _mbTiles?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _isDownloading ? null : downloadMbTiles,
            child: _isDownloading
                ? CircularProgressIndicator()
                : Text('Download MBTiles'),
          ),
          Expanded(
            child: _currentTile == null
                ? Center(
                    child: Text('Download and load MBTiles to view the map'))
                : Image.memory(_currentTile!, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}

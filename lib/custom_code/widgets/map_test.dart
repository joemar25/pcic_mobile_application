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
        await saveMbTiles(bytes);
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

  Future<void> saveMbTiles(Uint8List bytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/trails.mbtiles';
      final file = await File(filePath).writeAsBytes(bytes);

      print('MBTiles file saved at: $filePath');
      setState(() {
        _filePath = file.path;
      });
    } catch (e) {
      print('Error saving MBTiles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _isDownloading ? null : downloadMbTiles,
            child: _isDownloading
                ? CircularProgressIndicator()
                : Text('Download MBTiles'),
          ),
          SizedBox(height: 20),
          Text(_filePath == null
              ? 'MBTiles file not downloaded yet'
              : 'MBTiles file saved at: $_filePath'),
        ],
      ),
    );
  }
}

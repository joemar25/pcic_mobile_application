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

import 'package:mbtiles/mbtiles.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future fetchMbTiles() async {
  final String bucketName = 'mb-files';
  final String fileName = 'trails.mbtiles';

  try {
    print('Fetching $fileName from $bucketName bucket...');

    final bytes =
        await SupaFlow.client.storage.from(bucketName).download(fileName);

    if (bytes != null) {
      print('Successfully downloaded $fileName. Size: ${bytes.length} bytes');

      final tempDir = await getTemporaryDirectory();
      final tempFile = File(path.join(tempDir.path, fileName));
      await tempFile.writeAsBytes(bytes);

      final mbTiles = await MbTiles(tempFile.path);

      final metadata = await mbTiles.getMetadata();
      print('\nMetadata:');
      metadata.forEach((key, value) {
        print('  $key: $value');
      });

      final minZoom = int.parse(metadata['minzoom'] ?? '0');
      final maxZoom = int.parse(metadata['maxzoom'] ?? '0');
      print('\nZoom levels: $minZoom to $maxZoom');

      final sampleZoom = minZoom;
      final sampleTile = await mbTiles.getTile(sampleZoom, 0, 0);
      if (sampleTile != null) {
        print('Sample tile at zoom $sampleZoom: ${sampleTile.length} bytes');
      } else {
        print('No sample tile found at zoom $sampleZoom');
      }

      // Try to get a tile count (this might be slow for large files)
      int tileCount = 0;
      for (int z = minZoom; z <= maxZoom; z++) {
        final tiles = await mbTiles.getTilesAtZoom(z);
        tileCount += tiles.length;
      }
      print('\nTotal number of tiles: $tileCount');

      await mbTiles.close();
      await tempFile.delete();
    } else {
      print('Failed to download $fileName');
    }
  } catch (e) {
    print('Error processing MBTiles: $e');
  }
}

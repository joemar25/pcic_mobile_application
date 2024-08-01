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

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:typed_data';

Future saveGpx(
  String? taskId,
  List<LatLng>? routeCoordinates,
) async {
  print('Starting saveGpx function');
  print('taskId: $taskId');
  print('routeCoordinates length: ${routeCoordinates?.length}');

  if (taskId == null || routeCoordinates == null || routeCoordinates.isEmpty) {
    print('Invalid input: taskId or routeCoordinates is null or empty');
    return;
  }

  try {
    // Generate GPX content
    print('Generating GPX content');
    final gpx = _generateGpx(routeCoordinates);
    print('GPX content generated successfully');

    // Convert the GPX string to Uint8List
    print('Converting GPX to Uint8List');
    final Uint8List gpxBytes = Uint8List.fromList(utf8.encode(gpx));
    print('GPX converted to Uint8List successfully');

    // Define the file path in the bucket
    final filePath = '$taskId.gpx';
    print('Supabase file path: $filePath');

    // Upload or update the GPX file in Supabase storage
    print('Uploading GPX to Supabase');
    final response =
        await SupaFlow.client.storage.from('gpx_files').uploadBinary(
              filePath,
              gpxBytes,
              fileOptions: FileOptions(
                contentType: 'application/gpx+xml',
                upsert: true,
              ),
            );

    // Check if the upload was successful
    if (response != null) {
      print('GPX file uploaded/updated successfully to Supabase');

      // Encode GPX content as base64
      final String base64Gpx = base64Encode(gpxBytes);

      // Update the ppir_forms table with the base64 encoded GPX blob
      print('Updating ppir_forms table with base64 encoded GPX blob');
      await SupaFlow.client
          .from('ppir_forms')
          .update({'gpx': base64Gpx}).eq('task_id', taskId);

      print(
          'ppir_forms table updated successfully with base64 encoded GPX blob');
    } else {
      print('Error uploading/updating GPX file to Supabase: Operation failed');
    }

    // Save GPX locally
    print('Saving GPX locally');
    await _saveGpxLocally(taskId, gpx);
    print('GPX saved locally successfully');
  } catch (e) {
    print('Error in saveGpx function: $e');
  }
}

String _generateGpx(List<LatLng> routeCoordinates) {
  print('Starting _generateGpx function');
  final builder = xml.XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('gpx', nest: () {
    builder.attribute('version', '1.1');
    builder.attribute('creator', 'MapangMakabayan');
    builder.attribute('xmlns', 'http://www.topografix.com/GPX/1/1');
    builder.element('trk', nest: () {
      builder.element('name', nest: 'MapangMakabayan Track');
      builder.element('trkseg', nest: () {
        for (final coord in routeCoordinates) {
          builder.element('trkpt', nest: () {
            builder.attribute('lat', coord.latitude.toString());
            builder.attribute('lon', coord.longitude.toString());
          });
        }
      });
    });
  });
  print('GPX content generated');
  return builder.buildDocument().toXmlString(pretty: true);
}

Future<void> _saveGpxLocally(String taskId, String gpxContent) async {
  print('Starting _saveGpxLocally function');
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$taskId.gpx');
    print('Local file path: ${file.path}');

    await file.writeAsString(gpxContent);
    print('GPX file saved locally');
  } catch (e) {
    print('Error saving GPX locally: $e');
  }
}

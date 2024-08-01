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
  if (taskId == null || routeCoordinates == null || routeCoordinates.isEmpty) {
    print('Invalid input: taskId or routeCoordinates is null or empty');
    return;
  }

  try {
    // Generate GPX content
    final gpx = _generateGpx(routeCoordinates);

    // Convert the GPX string to Uint8List
    final Uint8List gpxBytes = Uint8List.fromList(utf8.encode(gpx));

    // Define the file path in the bucket
    final filePath = '$taskId.gpx';

    // Upload or update the GPX file in Supabase storage
    final response =
        await SupaFlow.client.storage.from('gpx_files').uploadBinary(
              filePath,
              gpxBytes,
              fileOptions: FileOptions(
                contentType: 'application/gpx+xml',
                upsert: true, // This will override the file if it exists
              ),
            );

    // Check if the upload was successful
    if (response != null && response.isNotEmpty) {
      print('GPX file uploaded/updated successfully');
      // You can add additional logic here, such as updating the task record with the file URL
    } else {
      print('Error uploading/updating GPX file: Operation failed');
    }
  } catch (e) {
    print('Error saving GPX to Supabase: $e');
  }
}

String _generateGpx(List<LatLng> routeCoordinates) {
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
  return builder.buildDocument().toXmlString(pretty: true);
}

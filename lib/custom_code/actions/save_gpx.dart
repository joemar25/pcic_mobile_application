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
import 'dart:typed_data';
import 'package:xml/xml.dart' as xml;

Future saveGpx(
  String taskId,
  String routeCoordinates,
  String trackLastCoord,
  String trackDateTime,
  String trackTotalArea,
  String trackTotalDistance,
) async {
  print('Starting saveGpx function');
  print('taskId: $taskId');

  if (taskId.isEmpty || routeCoordinates.isEmpty) {
    print('Invalid input: taskId or routeCoordinates is empty');
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

    // Query the tasks table to get service_group and task_number
    print('Querying tasks table for service_group and task_number');
    final taskResponse = await SupaFlow.client
        .from('tasks')
        .select('service_group, task_number, assignee')
        .eq('id', taskId)
        .single()
        .execute();

    if (taskResponse.status != 200 || taskResponse.data == null) {
      throw Exception('Error querying tasks table: ${taskResponse.status}');
    }

    final taskData = taskResponse.data as Map<String, dynamic>;
    final String serviceGroup = taskData['service_group'] ?? '';
    final String taskNumber = taskData['task_number'] ?? '';

    // Get the current user's email
    final currentUser = SupaFlow.client.auth.currentUser;
    final String userEmail = currentUser?.email ?? taskData['assignee'] ?? '';

    if (userEmail.isEmpty) {
      throw Exception('Unable to get user email');
    }

    // Define the file path in the bucket
    final filePath =
        '$serviceGroup/$userEmail/$taskNumber/attachments/geotag.gpx';
    print('Supabase file path: $filePath');

    // Upload or update the GPX file in Supabase storage
    print('Uploading GPX to Supabase');
    final response = await SupaFlow.client.storage.from('for_ftp').uploadBinary(
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

      await SQLiteManager.instance.updatePPIRFormGpx(
        taskId: taskId,
        gpx: base64Gpx,
      );

      // Update the ppir_forms table with the provided values
      print('Updating ppir_forms table with provided values');
      await SupaFlow.client.from('ppir_forms').update({
        'gpx': base64Gpx,
        'track_last_coord': trackLastCoord,
        'track_date_time': trackDateTime,
        'track_total_area': trackTotalArea,
        'track_total_distance': trackTotalDistance,
      }).eq('task_id', taskId);

      print('ppir_forms table updated successfully with provided values');
    } else {
      print('Error uploading/updating GPX file to Supabase: Operation failed');
    }
  } catch (e) {
    print('Error in saveGpx function: $e');
  }
}

String _generateGpx(String routeCoordinates) {
  print('Starting _generateGpx function');
  final builder = xml.XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('gpx', nest: () {
    builder.attribute('version', '1.1');
    builder.attribute('creator', 'PCIC-QUANBY');
    builder.attribute('xmlns', 'http://www.topografix.com/GPX/1/1');
    builder.element('trk', nest: () {
      builder.element('name', nest: 'PCIC-QUANBY Track');
      builder.element('trkseg', nest: () {
        final coordinates = routeCoordinates.split(' ');
        for (final coord in coordinates) {
          final latLon = coord.split(',');
          if (latLon.length == 2) {
            builder.element('trkpt', nest: () {
              builder.attribute('lat', latLon[0]);
              builder.attribute('lon', latLon[1]);
            });
          }
        }
      });
    });
  });
  print('GPX content generated');
  return builder.buildDocument().toXmlString(pretty: true);
}

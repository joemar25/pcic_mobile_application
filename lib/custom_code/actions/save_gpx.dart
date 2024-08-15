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
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:typed_data';
import 'package:intl/intl.dart';

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

      // Calculate the required values
      final String trackLastCoord = _getLastCoordinate(routeCoordinates);
      final String trackDateTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final double trackTotalArea = _calculateTotalArea(routeCoordinates);
      final double trackTotalDistance =
          _calculateTotalDistance(routeCoordinates);

      // Encode GPX content as base64
      final String base64Gpx = base64Encode(gpxBytes);
      FFAppState().gpxBlob = base64Gpx;

      // Update the ppir_forms table with the calculated values
      print('Updating ppir_forms table with calculated values');
      await SupaFlow.client.from('ppir_forms').update({
        'gpx': base64Gpx,
        'track_last_coord': trackLastCoord,
        'track_date_time': trackDateTime,
        'track_total_area': trackTotalArea.toStringAsFixed(4),
        'track_total_distance': trackTotalDistance.toStringAsFixed(4),
      }).eq('task_id', taskId);

      print('ppir_forms table updated successfully with calculated values');
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
    builder.attribute('creator', 'PCIC-QUANBY');
    builder.attribute('xmlns', 'http://www.topografix.com/GPX/1/1');
    builder.element('trk', nest: () {
      builder.element('name', nest: 'PCIC-QUANBY Track');
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
    final file = File('${directory.path}/geotag.gpx');
    print('Local file path: ${file.path}');

    await file.writeAsString(gpxContent);
    print('GPX file saved locally');
  } catch (e) {
    print('Error saving GPX locally: $e');
  }
}

String _getLastCoordinate(List<LatLng> coordinates) {
  if (coordinates.isEmpty) return '';
  final lastCoord = coordinates.last;
  return '${lastCoord.latitude},${lastCoord.longitude}';
}

double _calculateTotalDistance(List<LatLng> coordinates) {
  double totalDistanceMeters = 0;

  for (int i = 0; i < coordinates.length - 1; i++) {
    totalDistanceMeters +=
        _calculateDistance(coordinates[i], coordinates[i + 1]);
  }

  // Convert meters to hectares (1 hectare = 10000 sq meters)
  // We're assuming a 1-meter wide path for this conversion
  return totalDistanceMeters / 10000;
}

double _calculateDistance(LatLng start, LatLng end) {
  const double earthRadius = 6371000; // in meters
  final double lat1 = start.latitude * pi / 180;
  final double lat2 = end.latitude * pi / 180;
  final double lon1 = start.longitude * pi / 180;
  final double lon2 = end.longitude * pi / 180;

  final double dLat = lat2 - lat1;
  final double dLon = lon2 - lon1;

  final double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c;
}

double _calculateTotalArea(List<LatLng> coordinates) {
  if (coordinates.length < 3) return 0;

  double totalArea = 0;

  for (int i = 0; i < coordinates.length; i++) {
    LatLng p1 = coordinates[i];
    LatLng p2 = coordinates[(i + 1) % coordinates.length];

    totalArea += (p2.longitude - p1.longitude) * (p2.latitude + p1.latitude);
  }

  // The result is in square degrees, we need to convert it to square meters
  totalArea = totalArea.abs() * 111319.9 * 111319.9 / 2;

  // Convert square meters to hectares
  return totalArea / 10000;
}

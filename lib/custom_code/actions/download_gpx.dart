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
import 'package:permission_handler/permission_handler.dart';

Future<void> downloadGpx(String? taskId) async {
  print('Starting downloadGpx function');
  print('taskId: $taskId');

  if (taskId == null) {
    print('Invalid input: taskId is null');
    return;
  }

  try {
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

    // Download the GPX file from Supabase storage
    print('Downloading GPX from Supabase');
    final response =
        await SupaFlow.client.storage.from('for_ftp').download(filePath);

    if (response != null) {
      print('GPX file downloaded successfully from Supabase');

      // Get the app's document directory
      final directory = await getApplicationDocumentsDirectory();
      final localPath = '${directory.path}/downloaded_geotag.gpx';

      // Write the downloaded content to a local file
      final File localFile = File(localPath);
      await localFile.writeAsBytes(response);

      print('GPX file saved locally at: $localPath');

      // Check and request storage permission
      if (await Permission.storage.request().isGranted) {
        // Move the file to the Downloads folder
        final downloadDir = Directory('/storage/emulated/0/Download');
        if (!(await downloadDir.exists())) {
          await downloadDir.create(recursive: true);
        }
        final downloadPath = '${downloadDir.path}/geotag_$taskNumber.gpx';
        await localFile.copy(downloadPath);

        print('GPX file moved to Downloads folder: $downloadPath');

        // Show a success message
        ScaffoldMessenger.of(FFAppState().navigatorKey.currentContext!)
            .showSnackBar(
          SnackBar(
            content:
                Text('GPX file downloaded successfully to Downloads folder'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        print('Storage permission denied');
        ScaffoldMessenger.of(FFAppState().navigatorKey.currentContext!)
            .showSnackBar(
          SnackBar(
            content: Text('Storage permission required to save the file'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      print('Error downloading GPX file from Supabase: Operation failed');
      throw Exception('Failed to download GPX file from Supabase');
    }
  } catch (e) {
    print('Error in downloadGpx function: $e');
    ScaffoldMessenger.of(FFAppState().navigatorKey.currentContext!)
        .showSnackBar(
      SnackBar(
        content: Text('Error downloading GPX file: $e'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

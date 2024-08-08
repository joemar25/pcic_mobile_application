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

import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
      final attachmentsDir = Directory('${directory.path}/attachments');
      if (!(await attachmentsDir.exists())) {
        await attachmentsDir.create(recursive: true);
      }
      final localPath = '${attachmentsDir.path}/geotag_$taskNumber.gpx';

      // Write the downloaded content to a local file
      final File localFile = File(localPath);
      await localFile.writeAsBytes(response);

      print('GPX file saved locally at: $localPath');
    } else {
      print('Error downloading GPX file from Supabase: Operation failed');
      throw Exception('Failed to download GPX file from Supabase');
    }
  } catch (e) {
    print('Error in downloadGpx function: $e');
  }
}

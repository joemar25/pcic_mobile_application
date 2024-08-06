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

import 'index.dart'; // Imports other custom actions

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

Future<String> saveTaskXml(String? generatedTaskXml, String? taskId) async {
  print('Starting saveTaskXml function');
  if (generatedTaskXml == null || generatedTaskXml.isEmpty || taskId == null) {
    return 'Error: Invalid input';
  }

  try {
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
    final String userEmail =
        SupaFlow.client.auth.currentUser?.email ?? taskData['assignee'] ?? '';

    if (userEmail.isEmpty) {
      throw Exception('Unable to get user email');
    }

    final String fileName = 'Task.xml';
    final String filePath = '$serviceGroup/$userEmail/$taskNumber/$fileName';

    // Delete existing XML file from Supabase storage
    try {
      await SupaFlow.client.storage.from('for_ftp').remove([filePath]);
      print('Existing XML file deleted from Supabase storage');
    } catch (e) {
      print('No existing XML file in Supabase storage or error deleting: $e');
    }

    final Uint8List xmlBytes =
        Uint8List.fromList(utf8.encode(generatedTaskXml));

    // Upload the new XML file to Supabase storage
    final response = await SupaFlow.client.storage.from('for_ftp').uploadBinary(
          filePath,
          xmlBytes,
          fileOptions: FileOptions(
            contentType: 'application/xml',
            upsert:
                false, // Changed to false as we're explicitly deleting first
          ),
        );

    if (response == null) {
      throw Exception('Error uploading XML file to Supabase');
    }

    // Save XML locally (this will overwrite if it exists)
    await _saveXmlLocally(
        serviceGroup, userEmail, taskNumber, fileName, generatedTaskXml);

    return 'XML saved successfully both in Supabase and locally';
  } catch (e) {
    print('Error in saveTaskXml function: $e');
    return 'Error: $e';
  }
}

Future<void> _saveXmlLocally(String serviceGroup, String userEmail,
    String taskNumber, String fileName, String xmlContent) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final folderPath = '${directory.path}/$serviceGroup/$userEmail/$taskNumber';
    await Directory(folderPath).create(recursive: true);
    final file = File('$folderPath/$fileName');

    // Delete existing local XML file
    if (await file.exists()) {
      await file.delete();
      print('Existing local XML file deleted');
    }

    // Write new XML content
    await file.writeAsString(xmlContent);
    print('New XML file saved locally');
  } catch (e) {
    print('Error saving XML locally: $e');
  }
}

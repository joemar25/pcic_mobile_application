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
import 'dart:typed_data';
import 'package:intl/intl.dart';

Future<String> saveTaskXml(String? genratedTaskXml) async {
  print('Starting saveTaskXml function');

  if (genratedTaskXml == null || genratedTaskXml.isEmpty) {
    print('Invalid input: genratedTaskXml is null or empty');
    return 'Error: Invalid XML input';
  }

  try {
    // Get the current user's email
    final currentUser = SupaFlow.client.auth.currentUser;
    final String userEmail = currentUser?.email ?? '';

    if (userEmail.isEmpty) {
      throw Exception('Unable to get user email');
    }

    // Generate a unique filename using timestamp
    final String timestamp =
        DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    final String fileName = 'task_${timestamp}.xml';

    // Define the file path in the bucket
    final filePath = '$userEmail/attachments/$fileName';
    print('Supabase file path: $filePath');

    // Convert the XML string to Uint8List
    print('Converting XML to Uint8List');
    final Uint8List xmlBytes = Uint8List.fromList(utf8.encode(genratedTaskXml));
    print('XML converted to Uint8List successfully');

    // Upload the XML file to Supabase storage
    print('Uploading XML to Supabase');
    final response = await SupaFlow.client.storage.from('for_ftp').uploadBinary(
          filePath,
          xmlBytes,
          fileOptions: FileOptions(
            contentType: 'application/xml',
            upsert: true,
          ),
        );

    // Check if the upload was successful
    if (response != null) {
      print('XML file uploaded successfully to Supabase');

      // Save XML locally
      print('Saving XML locally');
      await _saveXmlLocally(fileName, genratedTaskXml);
      print('XML saved locally successfully');

      return 'XML saved successfully both in Supabase and locally';
    } else {
      print('Error uploading XML file to Supabase: Operation failed');
      return 'Error: Failed to upload XML to Supabase';
    }
  } catch (e) {
    print('Error in saveTaskXml function: $e');
    return 'Error: $e';
  }
}

Future<void> _saveXmlLocally(String fileName, String xmlContent) async {
  print('Starting _saveXmlLocally function');
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    print('Local file path: ${file.path}');

    await file.writeAsString(xmlContent);
    print('XML file saved locally');
  } catch (e) {
    print('Error saving XML locally: $e');
  }
}

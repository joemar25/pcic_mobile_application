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
import 'package:archive/archive.dart';
import 'package:ftpconnect/ftpconnect.dart';

Future<bool> saveToFTP(String? taskId) async {
  if (taskId == null) return false;

  try {
    // 1. Query task data
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

    // 2. Construct folder path
    final directory = await getApplicationDocumentsDirectory();
    final folderPath = '${directory.path}/$serviceGroup/$userEmail/$taskNumber';

    // 3. Zip the folder
    final zipFile = File('${directory.path}/task_$taskId.zip');
    final zipBytes = await zipFolder(folderPath);
    await zipFile.writeAsBytes(zipBytes);

    // 4. Upload to FTP
    final ftpConnect = FTPConnect('122.55.242.110',
        user: 'k2c_User2', pass: 'K2C@PC!C2024', port: 21);
    await ftpConnect.connect();
    await ftpConnect.uploadFile(zipFile);
    await ftpConnect.disconnect();

    // 5. Clean up: delete the local zip file
    await zipFile.delete();

    return true;
  } catch (e) {
    print('Error in saveToFTP: $e');
    return false;
  }
}

Future<List<int>> zipFolder(String folderPath) async {
  final archive = Archive();
  final directory = Directory(folderPath);

  await for (final file in directory.list(recursive: true)) {
    if (file is File) {
      final relativePath = file.path.substring(folderPath.length + 1);
      final archiveFile = ArchiveFile(
        relativePath,
        file.lengthSync(),
        await file.readAsBytes(),
      );
      archive.addFile(archiveFile);
    }
  }

  return ZipEncoder().encode(archive) ?? [];
}

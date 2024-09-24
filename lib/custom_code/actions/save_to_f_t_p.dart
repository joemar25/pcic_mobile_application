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

import 'package:ftpconnect/ftpconnect.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';

Future<bool> saveToFTP(String? taskId) async {
  if (taskId == null) return false;

  FTPConnect? ftpClient;

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

    // 2. Query insurance ID from ppir_forms
    final ppirResponse = await SupaFlow.client
        .from('ppir_forms')
        .select('ppir_insuranceid')
        .eq('task_id', taskId)
        .single()
        .execute();

    if (ppirResponse.status != 200 || ppirResponse.data == null) {
      throw Exception(
          'Error querying ppir_forms table: ${ppirResponse.status}');
    }

    final String insuranceId = ppirResponse.data['ppir_insuranceid'] ?? '';

    // 3. Find the latest folder for this task and insurance ID
    final String basePath = '$serviceGroup/$userEmail';
    final String folderPrefix = '${taskNumber}_$insuranceId';

    print('Searching for latest folder with basePath: $basePath');
    print('Folder prefix: $folderPrefix');

    final latestFolder = await findLatestFolder(basePath, folderPrefix);

    if (latestFolder == null) {
      print('No matching folder found for the task');
      throw Exception('No matching folder found for the task');
    }

    print('Latest folder found: $latestFolder');

    // 4. Get all files from the latest folder in the Supabase bucket
    final fileList = await listAllFiles(latestFolder);

    // 5. Create a temporary directory to store the .task file
    final tempDir = await getTemporaryDirectory();

    // 6. Download files and create archive
    final archive = Archive();
    for (final filePath in fileList) {
      final fileData =
          await SupaFlow.client.storage.from('for_ftp').download(filePath);

      // Extract the relative path within the taskNumber folder
      final relativePath = filePath.substring(latestFolder.length + 1);

      final archiveFile = ArchiveFile(
        relativePath,
        fileData.length,
        fileData,
      );
      archive.addFile(archiveFile);
    }

    // 7. Create the .task file with the new naming convention
    final taskFile = File('${tempDir.path}/${taskNumber}_${insuranceId}.task');
    final zipBytes = ZipEncoder().encode(archive) ?? [];
    await taskFile.writeAsBytes(zipBytes);

    // 8. Upload to FTP
    ftpClient =
        FTPConnect('122.55.242.110', user: 'k2c_User2', pass: 'K2c#%!pc!c');
    await ftpClient.connect();

    // Ensure the remote directory exists and upload the file
    final remotePath = '/taskarchive/${taskNumber}_${insuranceId}.task';
    await ftpClient.uploadFile(taskFile, sRemoteName: remotePath);

    // 9. Clean up: delete the temporary .task file
    await taskFile.delete();

    return true;
  } catch (e) {
    print('Error in saveToFTP: $e');
    return false;
  } finally {
    // Close the FTP connection in the finally block
    await ftpClient?.disconnect();
  }
}

Future<List<String>> listAllFiles(String path) async {
  List<String> allFiles = [];
  final response =
      await SupaFlow.client.storage.from('for_ftp').list(path: path);

  for (final item in response) {
    if (item.name.contains('.')) {
      // Assuming files have extensions and folders don't
      allFiles.add('$path/${item.name}');
    } else {
      allFiles.addAll(await listAllFiles('$path/${item.name}'));
    }
  }

  return allFiles;
}

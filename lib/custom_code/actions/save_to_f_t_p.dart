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
import 'package:dartssh2/dartssh2.dart';

Future<bool> saveToFTP(String? taskId) async {
  if (taskId == null) return false;

  SSHClient? client;

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

    // 2. Get all files from the Supabase bucket
    final bucketPath = '$serviceGroup/$userEmail/$taskNumber';
    final fileList = await listAllFiles(bucketPath);

    // 3. Create a temporary directory to store the .task file
    final tempDir = await getTemporaryDirectory();

    // 4. Download files and create archive
    final archive = Archive();
    for (final filePath in fileList) {
      final fileData =
          await SupaFlow.client.storage.from('for_ftp').download(filePath);

      // Extract the relative path within the taskNumber folder
      final relativePath = filePath.substring(bucketPath.length + 1);

      final archiveFile = ArchiveFile(
        relativePath,
        fileData.length,
        fileData,
      );
      archive.addFile(archiveFile);
    }

    // 5. Create the .task file
    final taskFile = File('${tempDir.path}/task_$taskId.task');
    final zipBytes = ZipEncoder().encode(archive) ?? [];
    await taskFile.writeAsBytes(zipBytes);

    // 6. Upload to SFTP
    final socket = await SSHSocket.connect('122.55.242.110', 22);
    client = SSHClient(
      socket,
      username: 'k2c_User1',
      onPasswordRequest: () => 'K2C@PC!C2024',
    );

    await client.authenticated;
    final sftp = await client.sftp();

    // Construct the remote path
    final remotePath = '/Work/$bucketPath/task_$taskId.task';

    // Ensure the remote directory exists
    await createRemoteDirectoryIfNotExists(sftp, remotePath);

    // Open the remote file with create and truncate flags
    final remoteFile = await sftp.open(
      remotePath,
      mode: SftpFileOpenMode.create |
          SftpFileOpenMode.truncate |
          SftpFileOpenMode.write,
    );

    // Upload the file
    await remoteFile.write(taskFile.openRead().cast<Uint8List>());
    await remoteFile.close();

    // 7. Clean up: delete the temporary .task file
    await taskFile.delete();

    return true;
  } catch (e) {
    print('Error in saveToFTP: $e');
    return false;
  } finally {
    // Close the client in the finally block
    client?.close();
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

Future<void> createRemoteDirectoryIfNotExists(
    SftpClient sftp, String path) async {
  final dirs = path.split('/').where((dir) => dir.isNotEmpty).toList();
  String currentPath = '';

  for (final dir in dirs.sublist(0, dirs.length - 1)) {
    // Exclude the file name
    currentPath += '/$dir';
    try {
      await sftp.stat(currentPath);
    } catch (e) {
      // Directory doesn't exist, create it
      await sftp.mkdir(currentPath);
    }
  }
}

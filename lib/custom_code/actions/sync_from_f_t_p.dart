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

// Future<bool> syncFromFTP(String? region) async {
//   if (region == null) return false;

//   final regionName = region.replaceAll("PO", "P0");

//   return true;
// }

import '/auth/supabase_auth/auth_util.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:csv/csv.dart';
import 'dart:convert';

Future<bool> syncFromFTP(String? region) async {
  if (region == null) return false;

  final regionCode =
      'P${region.replaceAll(RegExp(r'[Oo]'), '0').padLeft(2, '0').replaceFirst('P', '')}';
  print("regionCode = $regionCode");

  SSHClient? client;

  try {
    // Connect to SFTP
    final socket = await SSHSocket.connect('122.55.242.110', 22);
    client = SSHClient(
      socket,
      username: 'k2c_User1',
      onPasswordRequest: () => 'K2C@PC!C2024',
    );

    await client.authenticated;
    final sftp = await client.sftp();

    // Navigate to the Work directory and list files
    const remotePath = '/Work';
    final List<SftpName> files = await sftp.listdir(remotePath);

    // Filter files
    final List<String> filesToProcess = files
        .where((file) =>
            file.filename.startsWith('$regionCode RICE Region') &&
            file.filename.endsWith('.csv'))
        .map((file) => file.filename)
        .toList();
    print("filesToProcess = $filesToProcess");

    // Get the current user's email
    final String userEmail = currentUserEmail;

    print('User email: $userEmail');

    List<List<dynamic>> allFilteredData = [];

    // Process each file
    for (final filename in filesToProcess) {
      final remoteFile = await sftp.open('$remotePath/$filename');

      print('Processing file: $filename\n\n');

      final String contents = utf8.decode(await remoteFile.readBytes());
      print("contents = $contents\n\n");

      await remoteFile.close();

      // Parse CSV
      List<List<dynamic>> rowsAsListOfValues =
          const CsvToListConverter().convert(contents);

      print("rowsAsListOfValues = $rowsAsListOfValues\n\n");

      // Assuming the header is the first row
      List<String> headers =
          rowsAsListOfValues[0].map((e) => e.toString()).toList();
      int assigneeIndex = headers.indexOf('Assignee');

      print("assigneeIndex = $assigneeIndex\n\n");
      print("assigneeIndex != -1 = ${assigneeIndex != -1}\n\n");
      if (assigneeIndex != -1) {
        print("Headers: $headers");
        print("User email for filtering: $userEmail");

        // Filter rows where Assignee matches userEmail
        List<List<dynamic>> filteredRows = rowsAsListOfValues.where((row) {
          if (row.length <= assigneeIndex) {
            print("Skipping row (too short): $row");
            return false;
          }
          String assigneeValue =
              row[assigneeIndex].toString().trim().toLowerCase();
          String userEmailLower = userEmail.trim().toLowerCase();
          bool matches = assigneeValue == userEmailLower;
          if (matches) {
            print("Matched row: $row");
          } else {
            print(
                "Non-matching row - Assignee: '$assigneeValue', User: '$userEmailLower'");
          }
          return matches;
        }).toList();

        print("Number of filtered rows: ${filteredRows.length}");
        print("First few filtered rows: ${filteredRows.take(5).toList()}\n\n");
        allFilteredData.addAll(filteredRows);
      }
    }

    // Process or save allFilteredData
    if (allFilteredData.isNotEmpty) {
      // Here you can process the filtered data as needed
      // For example, you could save it to a local file or send it to a database
      print('Filtered data: ${allFilteredData.length} rows');
      // TODO: Add your logic to handle the filtered data
    }

    return true;
  } catch (e) {
    print('SFTP Sync Error: $e');
    return false;
  } finally {
    client?.close();
  }
}

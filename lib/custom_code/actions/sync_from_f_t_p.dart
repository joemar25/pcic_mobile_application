// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

/// The function `syncFromFTP` retrieves CSV files from FTP servers, processes the data, and creates
/// tasks and forms based on certain conditions.
///
/// Args:
///   region (String): The `syncFromFTP` function you provided seems to be a Dart function that
/// synchronizes data from FTP servers based on a given region. The function takes a `region` parameter,
/// which is used to filter and process files from FTP servers.
///
/// Returns:
///   The function `syncFromFTP` returns a `Future<bool>`. It returns `true` if the synchronization
/// process is successful, and `false` if there are any errors or if the process fails at any point.
import '/auth/supabase_auth/auth_util.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'dart:io';

Future<bool> syncFromFTP(String? region) async {
  if (region == null) return false;
  debugPrint("region -> $region");

  String numericPart = region
      .replaceAll(RegExp(r'^[POpo]+'), '')
      .replaceAll(RegExp(r'[^\d]+.*$'), '');

  String transformedRegionCode = 'P${numericPart.padLeft(2, '0')}';

  String originalRegionCode = region;
  debugPrint("originalRegionCode -> $originalRegionCode");
  debugPrint("transformedRegionCode -> $transformedRegionCode");

  FTPConnect? ftpClient;
  int newTasksCount = 0;
  int newPPIRFormsCount = 0;

  final ftpServers = [
    {
      'host': '103.82.46.134',
      'user': 'k2c_User1',
      'pass': 'K2c#%!pc!c',
      'port': 21
    },
    {
      'host': '122.55.242.110',
      'user': 'k2c_User1',
      'pass': 'K2c#%!pc!c',
      'port': 21
    },
  ];

  try {
    final userQuery = await UsersTable()
        .queryRows(queryFn: (q) => q.eq('email', currentUserEmail));
    if (userQuery.isEmpty) return false;
    final currentUserId = userQuery.first.id;

    final regionQuery = await RegionsTable()
        .queryRows(queryFn: (q) => q.eq('region_code', originalRegionCode));
    if (regionQuery.isEmpty) return false;
    final regionName = regionQuery.first.regionName + ' PPIR';

    bool connected = false;
    for (var server in ftpServers) {
      try {
        ftpClient = FTPConnect(
          server['host'] as String,
          user: server['user'] as String,
          pass: server['pass'] as String,
          port: server['port'] as int?,
        );
        await ftpClient.connect();
        connected = true;
        break;
      } catch (e) {
        continue;
      }
    }

    if (!connected) return false;

    await ftpClient!.changeDirectory('/Work');

    List<FTPEntry> files = await ftpClient.listDirectoryContent();
    final filesToProcess = files
        .where((file) =>
            file.name.startsWith('$transformedRegionCode RICE Region') &&
            file.name.endsWith('.csv'))
        .map((file) => file.name)
        .toList();

    if (filesToProcess.isEmpty) return false;

    for (final filename in filesToProcess) {
      File tempFile = File('${Directory.systemTemp.path}/$filename');
      bool downloadSuccess = await ftpClient.downloadFile(filename, tempFile);
      if (!downloadSuccess) continue;

      final contents = await tempFile.readAsString();
      List<List<dynamic>> rows =
          const CsvToListConverter().convert(contents, eol: '\n');
      List<String> headers = rows.first.map((e) => e.toString()).toList();
      int assigneeIndex = headers.indexOf('Assignee');

      if (assigneeIndex != -1) {
        List<Map<String, dynamic>> filteredRows = rows
            .skip(1)
            .where((row) =>
                row.length > assigneeIndex &&
                row[assigneeIndex].toString().trim().toLowerCase() ==
                    currentUserEmail.trim().toLowerCase())
            .map((row) => Map.fromIterables(headers, row))
            .toList();

        for (var row in filteredRows) {
          String taskNumber = row['Task Number']?.toString().trim() ??
              'PPIR-${row['ppir_assignmentid']?.toString() ?? ''}';
          var onlineTasks = await TasksTable()
              .queryRows(queryFn: (q) => q.eq('task_number', taskNumber));
          var offlineTasks = await SQLiteManager.instance
              .oFFLINESelectAllTasksByAssignee(assignee: currentUserId);

          bool taskExists = onlineTasks.isNotEmpty ||
              offlineTasks.any((task) => task.taskNumber == taskNumber);
          if (!taskExists) {
            String taskId = const Uuid().v4();

            await TasksTable().insert({
              'id': taskId,
              'task_number': taskNumber,
              'service_group': originalRegionCode,
              'status':
                  row['Task Status']?.toString().toLowerCase() ?? 'pending',
              'service_type': regionName,
              'priority': row['Priority']?.toString() ?? 'medium',
              'assignee': currentUserId,
              'date_added': DateTime.now().toIso8601String(),
              'date_access': DateTime.now().toIso8601String(),
              'task_type': 'ppir',
            });

            await SQLiteManager.instance.insertOfflineTask(
              id: taskId,
              taskNumber: taskNumber,
              serviceGroup: originalRegionCode,
              status: row['Task Status']?.toString().toLowerCase() ?? 'pending',
              serviceType: regionName,
              priority: row['Priority']?.toString() ?? 'medium',
              assignee: currentUserId,
              dateAdded: DateTime.now().toIso8601String(),
              dateAccess: DateTime.now().toIso8601String(),
              fileId: filename,
            );

            await PpirFormsTable().insert({
              'task_id': taskId,
              'ppir_assignmentid': row['ppir_assignmentid']?.toString() ?? '',
              'ppir_insuranceid': row['ppir_insuranceid']?.toString() ?? '',
              'ppir_farmername': row['ppir_farmername']?.toString() ?? '',
              'ppir_address': row['ppir_address']?.toString() ?? '',
              'ppir_farmertype': row['ppir_farmertype']?.toString() ?? '',
              'ppir_mobileno': row['ppir_mobileno']?.toString() ?? '',
              'ppir_groupname': row['ppir_groupname']?.toString() ?? '',
              'ppir_groupaddress': row['ppir_groupaddress']?.toString() ?? '',
              'ppir_lendername': row['ppir_lendername']?.toString() ?? '',
              'ppir_lenderaddress': row['ppir_lenderaddress']?.toString() ?? '',
              'ppir_cicno': row['ppir_cicno']?.toString() ?? '',
              'ppir_farmloc': row['ppir_farmloc']?.toString() ?? '',
              'ppir_north': row['ppir_north']?.toString() ?? '',
              'ppir_south': row['ppir_south']?.toString() ?? '',
              'ppir_east': row['ppir_east']?.toString() ?? '',
              'ppir_west': row['ppir_west']?.toString() ?? '',
              'ppir_area_aci': row['ppir_area_aci']?.toString() ?? '',
              'ppir_area_act': row['ppir_area_act']?.toString() ?? '',
              'ppir_dopds_aci': row['ppir_dopds_aci']?.toString() ?? '',
              'ppir_dopds_act': row['ppir_dopds_act']?.toString() ?? '',
              'ppir_doptp_aci': row['ppir_doptp_aci']?.toString() ?? '',
              'ppir_doptp_act': row['ppir_doptp_act']?.toString() ?? '',
              'ppir_svp_aci': row['ppir_svp_aci']?.toString() ?? '',
              'ppir_variety': row['ppir_variety']?.toString() ?? '',
              'ppir_stagecrop': row['ppir_stagecrop']?.toString() ?? '',
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
              'sync_status': 'synced',
              'is_dirty': 'false',
            });

            newPPIRFormsCount++;
            newTasksCount++;
          }
        }
      }
      await tempFile.delete();
    }

    FFAppState().syncCount += newTasksCount;
    return true;
  } catch (e) {
    return false;
  } finally {
    await ftpClient?.disconnect();
  }
}

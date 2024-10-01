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

import '/auth/supabase_auth/auth_util.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'dart:io';

Future<bool> syncFromFTP(String? region) async {
  print("hello from syncFromFTP");
  if (region == null) {
    print('Error: Region is null');
    return false;
  }

  String transformedRegionCode =
      'PO${region.replaceAll(RegExp(r'[POpo]'), '')}';
  String originalRegionCode = 'P0${region.replaceAll(RegExp(r'[POpo]'), '')}';
  print('Processing region: $transformedRegionCode');
  print('Original region code for file matching: $originalRegionCode');

  FTPConnect? ftpClient;
  int newTasksCount = 0;
  int newPPIRFormsCount = 0;

  // Define FTP server endpoints
  final List<Map<String, dynamic>> ftpServers = [
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
    final userQuery = await UsersTable().queryRows(
      queryFn: (q) => q.eq('email', currentUserEmail),
    );
    if (userQuery.isEmpty) {
      print('Error: Current user not found in the database');
      return false;
    }
    final currentUserId = userQuery.first.id;
    print('Current user ID: $currentUserId');

    final regionQuery = await RegionsTable().queryRows(
      queryFn: (q) => q.eq('region_code', transformedRegionCode),
    );
    if (regionQuery.isEmpty) {
      print('Error: Region not found in the database');
      return false;
    }
    final regionName = regionQuery.first.regionName + ' PPIR';

    // Try connecting to FTP servers
    bool connected = false;
    for (var server in ftpServers) {
      try {
        ftpClient = FTPConnect(server['host'],
            user: server['user'], pass: server['pass'], port: server['port']);
        await ftpClient.connect();
        connected = true;
        print('Connected to FTP server: ${server['host']}');
        break;
      } catch (e) {
        print('Failed to connect to FTP server ${server['host']}: $e');
        continue;
      }
    }

    if (!connected) {
      print('Failed to connect to any FTP server');
      return false;
    }

    const remotePath = '/Work';
    final List<FTPEntry> files = await ftpClient!.listDirectoryContent();

    print('All files in directory:');
    for (var file in files) {
      print(file.name);
    }

    final List<String> filesToProcess = files
        .where((file) =>
            file.name.startsWith('$originalRegionCode RICE Region') &&
            file.name.endsWith('.csv'))
        .map((file) => file.name)
        .toList();

    print('Files to process: ${filesToProcess.join(", ")}');

    if (filesToProcess.isEmpty) {
      print('No matching files found for region $originalRegionCode');
      return false;
    }

    for (final filename in filesToProcess) {
      print('Processing file: $filename');
      File tempFile = File('${Directory.systemTemp.path}/$filename');
      bool downloadSuccess =
          await ftpClient.downloadFile('$remotePath/$filename', tempFile);
      if (!downloadSuccess) {
        print('Failed to download file: $filename');
        continue;
      }
      final String contents = await tempFile.readAsString();

      List<List<dynamic>> rowsAsListOfValues =
          const CsvToListConverter().convert(contents, eol: '\n');
      List<String> headers =
          rowsAsListOfValues.first.map((e) => e.toString()).toList();
      int assigneeIndex = headers.indexOf('Assignee');

      print('CSV Headers: ${headers.join(", ")}');
      print('Assignee index: $assigneeIndex');

      if (assigneeIndex != -1) {
        List<Map<String, dynamic>> filteredRows = rowsAsListOfValues
            .skip(1)
            .where((row) {
              if (row.length <= assigneeIndex) return false;
              String assigneeValue =
                  row[assigneeIndex].toString().trim().toLowerCase();
              return assigneeValue == currentUserEmail.trim().toLowerCase();
            })
            .map((row) => Map.fromIterables(headers, row))
            .toList();

        print('Filtered rows count: ${filteredRows.length}');

        for (var row in filteredRows) {
          String taskNumber = row['Task Number']?.toString().trim() ?? '';
          if (taskNumber.isEmpty) {
            taskNumber = 'PPIR-${row['ppir_assignmentid']?.toString() ?? ''}';
          }

          var onlineTasks = await TasksTable().queryRows(
            queryFn: (q) => q.eq('task_number', taskNumber),
          );

          var offlineTasks =
              await SQLiteManager.instance.oFFLINESelectAllTasksByAssignee(
            assignee: currentUserId,
          );

          bool taskExists = onlineTasks.isNotEmpty ||
              offlineTasks.any((task) => task.taskNumber == taskNumber);

          if (!taskExists) {
            print('Inserting new task: $taskNumber');

            String taskId = const Uuid().v4();

            await TasksTable().insert({
              'id': taskId,
              'task_number': taskNumber,
              'service_group': transformedRegionCode,
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
              serviceGroup: transformedRegionCode,
              status: row['Task Status']?.toString().toLowerCase() ?? 'pending',
              serviceType: regionName,
              priority: row['Priority']?.toString() ?? 'medium',
              assignee: currentUserId,
              dateAdded: DateTime.now().toIso8601String(),
              dateAccess: DateTime.now().toIso8601String(),
              fileId: filename,
            );

            newTasksCount++;

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
              'ppir_variety': row['ppir_variety']?.toString() ?? '',
              'ppir_stagecrop': row['ppir_stagecrop']?.toString() ?? '',
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
              'sync_status': 'synced',
              'is_dirty': false,
            });

            await SQLiteManager.instance.insertOfflinePPIRForm(
              taskId: taskId,
              ppirAssignmentId: row['ppir_assignmentid']?.toString() ?? '',
              ppirInsuranceId: row['ppir_insuranceid']?.toString() ?? '',
              ppirFarmerName: row['ppir_farmername']?.toString() ?? '',
              ppirAddress: row['ppir_address']?.toString() ?? '',
              ppirFarmerType: row['ppir_farmertype']?.toString() ?? '',
              ppirMobileNo: row['ppir_mobileno']?.toString() ?? '',
              ppirGroupName: row['ppir_groupname']?.toString() ?? '',
              ppirGroupAddress: row['ppir_groupaddress']?.toString() ?? '',
              ppirLenderName: row['ppir_lendername']?.toString() ?? '',
              ppirLenderAddress: row['ppir_lenderaddress']?.toString() ?? '',
              ppirCICNo: row['ppir_cicno']?.toString() ?? '',
              ppirFarmLoc: row['ppir_farmloc']?.toString() ?? '',
              ppirNorth: row['ppir_north']?.toString() ?? '',
              ppirSouth: row['ppir_south']?.toString() ?? '',
              ppirEast: row['ppir_east']?.toString() ?? '',
              ppirWest: row['ppir_west']?.toString() ?? '',
              ppirAreaAci: row['ppir_area_aci']?.toString() ?? '',
              ppirAreaAct: row['ppir_area_act']?.toString() ?? '',
              ppirDopdsAci: row['ppir_dopds_aci']?.toString() ?? '',
              ppirDopdsAct: row['ppir_dopds_act']?.toString() ?? '',
              ppirDoptpAci: row['ppir_doptp_aci']?.toString() ?? '',
              ppirDoptpAct: row['ppir_doptp_act']?.toString() ?? '',
              ppirVariety: row['ppir_variety']?.toString() ?? '',
              ppirStageCrop: row['ppir_stagecrop']?.toString() ?? '',
              createdAt: DateTime.now().toIso8601String(),
              updatedAt: DateTime.now().toIso8601String(),
              syncStatus: 'synced',
              lastSyncedAt: DateTime.now().toIso8601String(),
              isDirty: 'false',
            );

            newPPIRFormsCount++;
          }
        }
      }
      await tempFile.delete();
    }
    print(
        'Sync completed: $newTasksCount new tasks, $newPPIRFormsCount new PPIR forms');

    print("Before FFAppState().syncCount -> ${FFAppState().syncCount}");
    FFAppState().syncCount = FFAppState().syncCount + newTasksCount;
    print("After FFAppState().syncCount -> ${FFAppState().syncCount}");

    return true;
  } catch (e) {
    print('Sync Error: $e');
    return false;
  } finally {
    await ftpClient?.disconnect();
  }
}

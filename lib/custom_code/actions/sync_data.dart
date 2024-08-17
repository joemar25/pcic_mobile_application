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
import '/backend/sqlite/queries/read.dart';

Future<String> syncData() async {
  // Fetch online tasks
  List<TasksRow> onlineTasks = await TasksTable().queryRows(
    queryFn: (q) => q.eq('assignee', currentUserUid),
  );

  // Fetch offline tasks
  List<OFFLINESelectAllTasksByAssigneeRow> offlineTasks =
      await SQLiteManager.instance.oFFLINESelectAllTasksByAssignee(
    assignee: currentUserUid,
  );

  int newTasksCount = 0;

  // Compare and insert new tasks
  for (var onlineTask in onlineTasks) {
    bool taskExists =
        offlineTasks.any((offlineTask) => offlineTask.id == onlineTask.id);

    if (!taskExists) {
      await SQLiteManager.instance.insertOfflineTask(
        id: onlineTask.id,
        taskNumber: onlineTask.taskNumber,
        serviceGroup: onlineTask.serviceGroup ?? '',
        status: onlineTask.status,
        serviceType: onlineTask.serviceType,
        priority: onlineTask.priority ?? '',
        assignee: onlineTask.assignee ?? '',
        dateAdded: onlineTask.dateAdded?.toIso8601String() ?? '',
        dateAccess: onlineTask.dateAccess?.toIso8601String() ?? '',
        fileId: onlineTask.fileId ?? '',
      );
      newTasksCount++;

      // Fetch and insert corresponding PPIR form if it exists
      var ppirForms = await PpirFormsTable().queryRows(
        queryFn: (q) => q.eq('task_id', onlineTask.id),
      );

      if (ppirForms.isNotEmpty) {
        var ppir = ppirForms.first;
        await SQLiteManager.instance.insertOfflinePPIRForm(
          taskId: ppir.taskId,
          ppirAssignmentId: ppir.ppirAssignmentid,
          gpx: ppir.gpx ?? '',
          ppirInsuranceId: ppir.ppirInsuranceid ?? '',
          ppirFarmerName: ppir.ppirFarmername ?? '',
          ppirAddress: ppir.ppirAddress ?? '',
          ppirFarmerType: ppir.ppirFarmertype ?? '',
          ppirMobileNo: ppir.ppirMobileno ?? '',
          ppirGroupName: ppir.ppirGroupname ?? '',
          ppirGroupAddress: ppir.ppirGroupaddress ?? '',
          ppirLenderName: ppir.ppirLendername ?? '',
          ppirLenderAddress: ppir.ppirLenderaddress ?? '',
          ppirCICNo: ppir.ppirCicno ?? '',
          ppirFarmLoc: ppir.ppirFarmloc ?? '',
          ppirNorth: ppir.ppirNorth ?? '',
          ppirSouth: ppir.ppirSouth ?? '',
          ppirEast: ppir.ppirEast ?? '',
          ppirWest: ppir.ppirWest ?? '',
          ppirAtt1: ppir.ppirAtt1 ?? '',
          ppirAtt2: ppir.ppirAtt2 ?? '',
          ppirAtt3: ppir.ppirAtt3 ?? '',
          ppirAtt4: ppir.ppirAtt4 ?? '',
          ppirAreaAci: ppir.ppirAreaAci ?? '',
          ppirAreaAct: ppir.ppirAreaAct ?? '',
          ppirDopdsAci: ppir.ppirDopdsAci ?? '',
          ppirDopdsAct: ppir.ppirDopdsAct ?? '',
          ppirDoptpAci: ppir.ppirDoptpAci ?? '',
          ppirDoptpAct: ppir.ppirDoptpAct ?? '',
          ppirSvpAci: ppir.ppirSvpAci ?? '',
          ppirSvpAct: ppir.ppirSvpAct,
          ppirVariety: ppir.ppirVariety ?? '',
          ppirStageCrop: ppir.ppirStagecrop ?? '',
          ppirRemarks: ppir.ppirRemarks ?? '',
          ppirNameInsured: ppir.ppirNameInsured ?? '',
          ppirNameIUIA: ppir.ppirNameIuia ?? '',
          ppirSigInsured: ppir.ppirSigInsured ?? '',
          ppirSigIUIA: ppir.ppirSigIuia ?? '',
          trackLastCoord: ppir.trackLastCoord ?? '',
          trackDateTime: ppir.trackDateTime ?? '',
          trackTotalArea: ppir.trackTotalArea ?? '',
          trackTotalDistance: ppir.trackTotalDistance ?? '',
          createdAt: ppir.createdAt?.toIso8601String() ?? '',
          updatedAt: ppir.updatedAt?.toIso8601String() ?? '',
          syncStatus: ppir.syncStatus ?? 'synced',
          lastSyncedAt: DateTime.now().toIso8601String(),
          localId: ppir.localId ?? '',
          isDirty: ppir.isDirty?.toString() ?? 'false',
        );
      }
    }
  }

  if (newTasksCount > 0) {
    return 'Synced $newTasksCount task(s)';
  } else {
    return 'No new tasks to sync';
  }
}

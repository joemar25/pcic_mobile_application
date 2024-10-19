import 'package:flutter/foundation.dart';

import '/backend/sqlite/init.dart';
import 'queries/read.dart';
import 'queries/update.dart';

import 'package:sqflite/sqflite.dart';
export 'queries/read.dart';
export 'queries/update.dart';

class SQLiteManager {
  SQLiteManager._();

  static SQLiteManager? _instance;
  static SQLiteManager get instance => _instance ??= SQLiteManager._();

  static late Database _database;
  Database get database => _database;

  static Future initialize() async {
    if (kIsWeb) {
      return;
    }
    _database = await initializeDatabaseFromDbFile(
      'db_sync',
      'offline_db.db',
    );
  }

  /// START READ QUERY CALLS

  Future<List<RetrieveAllUsersByRegionIDRow>> retrieveAllUsersByRegionID({
    String? regionId,
  }) =>
      performRetrieveAllUsersByRegionID(
        _database,
        regionId: regionId,
      );

  Future<List<RetrieveAllPPIRFormsByTaskIDRow>> retrieveAllPPIRFormsByTaskID({
    String? taskId,
  }) =>
      performRetrieveAllPPIRFormsByTaskID(
        _database,
        taskId: taskId,
      );

  Future<List<RetrieveAllMessagesRow>> retrieveAllMessages() =>
      performRetrieveAllMessages(
        _database,
      );

  Future<List<RetrieveAllSyncLogsRow>> retrieveAllSyncLogs() =>
      performRetrieveAllSyncLogs(
        _database,
      );

  Future<List<RetrieveAllAttemptsRow>> retrieveAllAttempts() =>
      performRetrieveAllAttempts(
        _database,
      );

  Future<List<RetrieveProfileRow>> retrieveProfile({
    String? email,
  }) =>
      performRetrieveProfile(
        _database,
        email: email,
      );

  Future<List<RetrieveAndSortSyncQueueByOldestTimestampRow>>
      retrieveAndSortSyncQueueByOldestTimestamp() =>
          performRetrieveAndSortSyncQueueByOldestTimestamp(
            _database,
          );

  Future<List<RetrieveTasksModifiedAfterASpecificDateRow>>
      retrieveTasksModifiedAfterASpecificDate() =>
          performRetrieveTasksModifiedAfterASpecificDate(
            _database,
          );

  Future<List<RetrieveAllTasksAssignedToASpecificAssigneeRow>>
      retrieveAllTasksAssignedToASpecificAssignee({
    String? assignee,
  }) =>
          performRetrieveAllTasksAssignedToASpecificAssignee(
            _database,
            assignee: assignee,
          );

  Future<List<CountOfTasksForDispatchAssignedToASpecificAssigneeRow>>
      countOfTasksForDispatchAssignedToASpecificAssignee({
    String? assignee,
  }) =>
          performCountOfTasksForDispatchAssignedToASpecificAssignee(
            _database,
            assignee: assignee,
          );

  Future<List<RetrieveTaskDetailsByTaskIDRow>> retrieveTaskDetailsByTaskID({
    String? taskId,
  }) =>
      performRetrieveTaskDetailsByTaskID(
        _database,
        taskId: taskId,
      );

  Future<List<SELECTTASKSAndPPIRByAssigneeRow>> sELECTTASKSAndPPIRByAssignee({
    String? taskId,
    String? assignee,
  }) =>
      performSELECTTASKSAndPPIRByAssignee(
        _database,
        taskId: taskId,
        assignee: assignee,
      );

  Future<List<RetrieveAllRiceSeedsByRegionIDRow>>
      retrieveAllRiceSeedsByRegionID({
    String? regionId,
  }) =>
          performRetrieveAllRiceSeedsByRegionID(
            _database,
            regionId: regionId,
          );

  Future<List<RetrieveAllCornSeedsByRegionIDRow>>
      retrieveAllCornSeedsByRegionID({
    String? regionId,
  }) =>
          performRetrieveAllCornSeedsByRegionID(
            _database,
            regionId: regionId,
          );

  Future<List<RetrievePPIRFormsByTaskIDRow>> retrievePPIRFormsByTaskID({
    String? taskId,
  }) =>
      performRetrievePPIRFormsByTaskID(
        _database,
        taskId: taskId,
      );

  Future<List<RetrieveRegionCodeByRegionIDRow>> retrieveRegionCodeByRegionID({
    String? id,
  }) =>
      performRetrieveRegionCodeByRegionID(
        _database,
        id: id,
      );

  Future<List<RetrieveGPXDataFromPPIRFormsByTaskIDRow>>
      retrieveGPXDataFromPPIRFormsByTaskID({
    String? taskId,
  }) =>
          performRetrieveGPXDataFromPPIRFormsByTaskID(
            _database,
            taskId: taskId,
          );

  Future<List<RetrievePPIRIsDirtyStatusForTasksAssignedToASpecificAssigneeRow>>
      retrievePPIRIsDirtyStatusForTasksAssignedToASpecificAssignee({
    String? assignee,
  }) =>
          performRetrievePPIRIsDirtyStatusForTasksAssignedToASpecificAssignee(
            _database,
            assignee: assignee,
          );

  Future<List<RetrieveDetailedTaskAndPPIRFormDataForASpecificAssigneeRow>>
      retrieveDetailedTaskAndPPIRFormDataForASpecificAssignee({
    String? assignee,
  }) =>
          performRetrieveDetailedTaskAndPPIRFormDataForASpecificAssignee(
            _database,
            assignee: assignee,
          );

  Future<List<SelectPpirFormsByAssigneeAndTaskStatusRow>>
      selectPpirFormsByAssigneeAndTaskStatus({
    String? assignee,
    String? status,
  }) =>
          performSelectPpirFormsByAssigneeAndTaskStatus(
            _database,
            assignee: assignee,
            status: status,
          );

  /// END READ QUERY CALLS

  /// START UPDATE QUERY CALLS

  Future insertOrReplaceTaskRecord({
    String? id,
    String? taskNumber,
    String? serviceGroup,
    String? status,
    String? serviceType,
    String? priority,
    String? assignee,
    String? dateAdded,
    String? dateAccess,
    String? fileId,
  }) =>
      performInsertOrReplaceTaskRecord(
        _database,
        id: id,
        taskNumber: taskNumber,
        serviceGroup: serviceGroup,
        status: status,
        serviceType: serviceType,
        priority: priority,
        assignee: assignee,
        dateAdded: dateAdded,
        dateAccess: dateAccess,
        fileId: fileId,
      );

  Future insertOrReplacePPIRFormRecord({
    String? taskId,
    String? ppirAssignmentId,
    String? gpx,
    String? ppirInsuranceId,
    String? ppirFarmerName,
    String? ppirAddress,
    String? ppirFarmerType,
    String? ppirMobileNo,
    String? ppirGroupName,
    String? ppirGroupAddress,
    String? ppirLenderName,
    String? ppirLenderAddress,
    String? ppirCICNo,
    String? ppirFarmLoc,
    String? ppirNorth,
    String? ppirSouth,
    String? ppirEast,
    String? ppirWest,
    String? ppirAtt1,
    String? ppirAtt2,
    String? ppirAtt3,
    String? ppirAtt4,
    String? ppirAreaAci,
    String? ppirAreaAct,
    String? ppirDopdsAci,
    String? ppirDopdsAct,
    String? ppirDoptpAci,
    String? ppirDoptpAct,
    String? ppirSvpAci,
    String? ppirSvpAct,
    String? ppirVariety,
    String? ppirStageCrop,
    String? ppirRemarks,
    String? ppirNameInsured,
    String? ppirNameIUIA,
    String? ppirSigInsured,
    String? ppirSigIUIA,
    String? trackLastCoord,
    String? trackDateTime,
    String? trackTotalArea,
    String? trackTotalDistance,
    String? createdAt,
    String? updatedAt,
    String? syncStatus,
    String? lastSyncedAt,
    String? localId,
    String? isDirty,
    String? capturedArea,
  }) =>
      performInsertOrReplacePPIRFormRecord(
        _database,
        taskId: taskId,
        ppirAssignmentId: ppirAssignmentId,
        gpx: gpx,
        ppirInsuranceId: ppirInsuranceId,
        ppirFarmerName: ppirFarmerName,
        ppirAddress: ppirAddress,
        ppirFarmerType: ppirFarmerType,
        ppirMobileNo: ppirMobileNo,
        ppirGroupName: ppirGroupName,
        ppirGroupAddress: ppirGroupAddress,
        ppirLenderName: ppirLenderName,
        ppirLenderAddress: ppirLenderAddress,
        ppirCICNo: ppirCICNo,
        ppirFarmLoc: ppirFarmLoc,
        ppirNorth: ppirNorth,
        ppirSouth: ppirSouth,
        ppirEast: ppirEast,
        ppirWest: ppirWest,
        ppirAtt1: ppirAtt1,
        ppirAtt2: ppirAtt2,
        ppirAtt3: ppirAtt3,
        ppirAtt4: ppirAtt4,
        ppirAreaAci: ppirAreaAci,
        ppirAreaAct: ppirAreaAct,
        ppirDopdsAci: ppirDopdsAci,
        ppirDopdsAct: ppirDopdsAct,
        ppirDoptpAci: ppirDoptpAci,
        ppirDoptpAct: ppirDoptpAct,
        ppirSvpAci: ppirSvpAci,
        ppirSvpAct: ppirSvpAct,
        ppirVariety: ppirVariety,
        ppirStageCrop: ppirStageCrop,
        ppirRemarks: ppirRemarks,
        ppirNameInsured: ppirNameInsured,
        ppirNameIUIA: ppirNameIUIA,
        ppirSigInsured: ppirSigInsured,
        ppirSigIUIA: ppirSigIUIA,
        trackLastCoord: trackLastCoord,
        trackDateTime: trackDateTime,
        trackTotalArea: trackTotalArea,
        trackTotalDistance: trackTotalDistance,
        createdAt: createdAt,
        updatedAt: updatedAt,
        syncStatus: syncStatus,
        lastSyncedAt: lastSyncedAt,
        localId: localId,
        isDirty: isDirty,
        capturedArea: capturedArea,
      );

  Future clearGPXDataInPPIRFormByTaskID({
    String? taskId,
    bool? isDirty,
  }) =>
      performClearGPXDataInPPIRFormByTaskID(
        _database,
        taskId: taskId,
        isDirty: isDirty,
      );

  Future updatePPIRFormDetailsAndDirtyFlagByTaskID({
    String? taskId,
    String? ppirSvpAct,
    String? ppirDopdsAct,
    String? ppirDoptpAct,
    String? ppirRemarks,
    String? ppirNameInsured,
    String? ppirNameIuia,
    String? ppirFarmloc,
    String? ppirAreaAct,
    String? ppirVariety,
    bool? isDirty,
    String? capturedArea,
  }) =>
      performUpdatePPIRFormDetailsAndDirtyFlagByTaskID(
        _database,
        taskId: taskId,
        ppirSvpAct: ppirSvpAct,
        ppirDopdsAct: ppirDopdsAct,
        ppirDoptpAct: ppirDoptpAct,
        ppirRemarks: ppirRemarks,
        ppirNameInsured: ppirNameInsured,
        ppirNameIuia: ppirNameIuia,
        ppirFarmloc: ppirFarmloc,
        ppirAreaAct: ppirAreaAct,
        ppirVariety: ppirVariety,
        isDirty: isDirty,
        capturedArea: capturedArea,
      );

  Future updateTaskStatusAndDirtyFlagByID({
    String? taskId,
    String? status,
    bool? isDirty,
  }) =>
      performUpdateTaskStatusAndDirtyFlagByID(
        _database,
        taskId: taskId,
        status: status,
        isDirty: isDirty,
      );

  Future updatePPIRFormDirtyFlagByTaskID({
    String? taskId,
    bool? isDirty,
  }) =>
      performUpdatePPIRFormDirtyFlagByTaskID(
        _database,
        taskId: taskId,
        isDirty: isDirty,
      );

  Future updatePPIRFormGPXDataByTaskID({
    String? taskId,
    String? gpx,
    bool? isDirty,
  }) =>
      performUpdatePPIRFormGPXDataByTaskID(
        _database,
        taskId: taskId,
        gpx: gpx,
        isDirty: isDirty,
      );

  Future updatePPIRFormTrackingDataByTaskID({
    String? taskId,
    String? trackLastCoord,
    String? trackDateTime,
    String? trackTotalArea,
    String? trackTotalDistance,
    String? gpx,
    bool? isDirty,
  }) =>
      performUpdatePPIRFormTrackingDataByTaskID(
        _database,
        taskId: taskId,
        trackLastCoord: trackLastCoord,
        trackDateTime: trackDateTime,
        trackTotalArea: trackTotalArea,
        trackTotalDistance: trackTotalDistance,
        gpx: gpx,
        isDirty: isDirty,
      );

  Future updatePPIRIUAISignatureByTaskID({
    String? taskId,
    String? signatureBlob,
  }) =>
      performUpdatePPIRIUAISignatureByTaskID(
        _database,
        taskId: taskId,
        signatureBlob: signatureBlob,
      );

  Future updatePPIRInsuredSignatureByTaskID({
    String? taskId,
    String? signatureBlob,
  }) =>
      performUpdatePPIRInsuredSignatureByTaskID(
        _database,
        taskId: taskId,
        signatureBlob: signatureBlob,
      );

  Future updateInspectorNameByUserID({
    String? id,
    String? inspectorName,
  }) =>
      performUpdateInspectorNameByUserID(
        _database,
        id: id,
        inspectorName: inspectorName,
      );

  Future deleteAllRecordsFromTasksAndPPIRForms() =>
      performDeleteAllRecordsFromTasksAndPPIRForms(
        _database,
      );

  Future insertOrReplaceUserData({
    String? id,
    String? role,
    String? email,
    String? photoUrl,
    String? inspectorName,
    String? mobileNumber,
    String? authUserId,
    String? createdAt,
    String? updatedAt,
    String? regionId,
  }) =>
      performInsertOrReplaceUserData(
        _database,
        id: id,
        role: role,
        email: email,
        photoUrl: photoUrl,
        inspectorName: inspectorName,
        mobileNumber: mobileNumber,
        authUserId: authUserId,
        createdAt: createdAt,
        updatedAt: updatedAt,
        regionId: regionId,
      );

  Future updatePPIRFormSyncStatusAndDirtyFlagByTaskID({
    String? taskId,
    String? syncStatus,
    String? isDirty,
  }) =>
      performUpdatePPIRFormSyncStatusAndDirtyFlagByTaskID(
        _database,
        taskId: taskId,
        syncStatus: syncStatus,
        isDirty: isDirty,
      );

  Future updateTaskSyncStatusAndDirtyFlagByID({
    String? taskId,
    String? syncStatus,
    String? isDirty,
  }) =>
      performUpdateTaskSyncStatusAndDirtyFlagByID(
        _database,
        taskId: taskId,
        syncStatus: syncStatus,
        isDirty: isDirty,
      );

  /// END UPDATE QUERY CALLS
}

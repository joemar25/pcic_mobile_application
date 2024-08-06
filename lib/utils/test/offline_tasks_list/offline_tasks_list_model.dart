import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'offline_tasks_list_widget.dart' show OfflineTasksListWidget;
import 'package:flutter/material.dart';

class OfflineTasksListModel extends FlutterFlowModel<OfflineTasksListWidget> {
  ///  Local state fields for this page.

  String? out;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - SQLite (SELECT TASKS base on status)] action in offlineTasksList widget.
  List<SELECTTASKSBaseOnStatusRow>? offlineOngoingTasks;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

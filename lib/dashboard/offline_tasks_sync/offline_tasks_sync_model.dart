import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'offline_tasks_sync_widget.dart' show OfflineTasksSyncWidget;
import 'package:flutter/material.dart';

class OfflineTasksSyncModel extends FlutterFlowModel<OfflineTasksSyncWidget> {
  ///  Local state fields for this page.

  int? limit = 0;

  int? iteration = 0;

  bool isSync = false;

  bool startSync = false;

  bool isSynced = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in Container widget.
  List<TasksRow>? onlineTasks;
  // Stores action output result for [Backend Call - Query Rows] action in Container widget.
  List<PpirFormsRow>? ppirOutput;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

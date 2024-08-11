import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'offline_tasks_list_widget.dart' show OfflineTasksListWidget;
import 'package:flutter/material.dart';

class OfflineTasksListModel extends FlutterFlowModel<OfflineTasksListWidget> {
  ///  Local state fields for this page.

  int? limit = 0;

  int? iteration = 0;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<TasksRow>? onlineTasks;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

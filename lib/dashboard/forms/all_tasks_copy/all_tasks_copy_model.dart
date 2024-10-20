import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import '/utils/components/tasks_row/tasks_row_widget.dart';
import 'all_tasks_copy_widget.dart' show AllTasksCopyWidget;
import 'package:flutter/material.dart';

class AllTasksCopyModel extends FlutterFlowModel<AllTasksCopyWidget> {
  ///  Local state fields for this page.

  String statusOutput = 'Syncing...';

  bool isSyncDone = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - isDirtyCount] action in allTasksCopy widget.
  String? isDirtyCounterr;
  // Stores action output result for [Custom Action - syncOnlineTaskAndPpirToOffline] action in allTasksCopy widget.
  String? outputMsg;
  // Stores action output result for [Custom Action - syncOnlineTaskAndPpirToOffline] action in Text widget.
  String? message;
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // Model for tasksRow component.
  late TasksRowModel tasksRowModel;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
    tasksRowModel = createModel(context, () => TasksRowModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
    tasksRowModel.dispose();
  }
}

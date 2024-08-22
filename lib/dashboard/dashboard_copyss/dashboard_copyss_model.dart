import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import '/utils/components/tasks/tasks_widget.dart';
import 'dashboard_copyss_widget.dart' show DashboardCopyssWidget;
import 'package:flutter/material.dart';

class DashboardCopyssModel extends FlutterFlowModel<DashboardCopyssWidget> {
  ///  Local state fields for this page.

  String? statusOutput = 'Loading..';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getTheSavedLocalProfile] action in dashboardCopyss widget.
  FFUploadedFile? loadLocalProfile;
  // Stores action output result for [Backend Call - SQLite (OFFLINE select all Tasks by Assignee)] action in dashboardCopyss widget.
  List<OFFLINESelectAllTasksByAssigneeRow>? offlineTasks;
  // Stores action output result for [Backend Call - Query Rows] action in dashboardCopyss widget.
  List<TasksRow>? onlineTasks;
  // Stores action output result for [Custom Action - syncData] action in Text widget.
  String? message;
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels1;
  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels2;
  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels3;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
    tasksModels1 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels2 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels3 = FlutterFlowDynamicModels(() => TasksModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
    tabBarController?.dispose();
    tasksModels1.dispose();
    tasksModels2.dispose();
    tasksModels3.dispose();
  }
}

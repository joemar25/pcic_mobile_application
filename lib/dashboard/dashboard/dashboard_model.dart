import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/sync/sync_widget.dart';
import '/utils/components/tasks/tasks_widget.dart';
import '/utils/connectivity/connectivity_widget.dart';
import 'dashboard_widget.dart' show DashboardWidget;
import 'package:flutter/material.dart';

class DashboardModel extends FlutterFlowModel<DashboardWidget> {
  ///  Local state fields for this page.

  int? fdc = 0;

  int? onc = 0;

  int? cc = 0;

  String inspectorName = 'inspectorName';

  String? userType = 'Agent';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getTheSavedLocalProfile] action in dashboard widget.
  FFUploadedFile? getProfilePic;
  // Stores action output result for [Backend Call - Query Rows] action in dashboard widget.
  List<UsersRow>? onlineSelectUserProfile;
  // Stores action output result for [Backend Call - Query Rows] action in dashboard widget.
  List<TasksRow>? onlineForDispatchTasksData;
  // Stores action output result for [Backend Call - Query Rows] action in dashboard widget.
  List<TasksRow>? onlineOngoingTasksData;
  // Stores action output result for [Backend Call - Query Rows] action in dashboard widget.
  List<TasksRow>? onlineCompletedTasksData;
  // Stores action output result for [Backend Call - SQLite (SELECT PROFILE)] action in dashboard widget.
  List<SelectProfileRow>? offlineSelectUserProfile;
  // Stores action output result for [Backend Call - SQLite (SELECT TASKS base on status)] action in dashboard widget.
  List<SELECTTASKSBaseOnStatusRow>? offlineForDispatchTasksData;
  // Stores action output result for [Backend Call - SQLite (SELECT TASKS base on status)] action in dashboard widget.
  List<SELECTTASKSBaseOnStatusRow>? offlineOngoingTasksData;
  // Stores action output result for [Backend Call - SQLite (SELECT TASKS base on status)] action in dashboard widget.
  List<SELECTTASKSBaseOnStatusRow>? offlineCompletedTasksData;
  // Model for sync component.
  late SyncModel syncModel;
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // State field(s) for TextField widget.
  final textFieldKey = GlobalKey();
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? textFieldSelectedOption;
  String? Function(BuildContext, String?)? textControllerValidator;
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
  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels4;
  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels5;
  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels6;

  @override
  void initState(BuildContext context) {
    syncModel = createModel(context, () => SyncModel());
    connectivityModel = createModel(context, () => ConnectivityModel());
    tasksModels1 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels2 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels3 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels4 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels5 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels6 = FlutterFlowDynamicModels(() => TasksModel());
  }

  @override
  void dispose() {
    syncModel.dispose();
    connectivityModel.dispose();
    textFieldFocusNode?.dispose();

    tabBarController?.dispose();
    tasksModels1.dispose();
    tasksModels2.dispose();
    tasksModels3.dispose();
    tasksModels4.dispose();
    tasksModels5.dispose();
    tasksModels6.dispose();
  }
}

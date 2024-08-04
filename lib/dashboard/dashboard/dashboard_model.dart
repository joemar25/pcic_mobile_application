import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import '/utils/components/tasks/tasks_widget.dart';
import 'dashboard_widget.dart' show DashboardWidget;
import 'package:flutter/material.dart';

class DashboardModel extends FlutterFlowModel<DashboardWidget> {
  ///  Local state fields for this page.

  int? fdc = 0;

  int? onc = 0;

  int? cc = 0;

  String profileUrl =
      'https://newsko.com.ph/wp-content/uploads/2024/06/Mikha.jpg';

  String inspectorName = 'inspectorName';

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - getTheSavedLocalProfile] action in dashboard widget.
  FFUploadedFile? getProfilePic;
  // Stores action output result for [Backend Call - Query Rows] action in dashboard widget.
  List<UsersRow>? currentUserProfile;
  // Stores action output result for [Backend Call - Query Rows] action in dashboard widget.
  List<TasksRow>? forDispatchTasksData;
  // Stores action output result for [Backend Call - Query Rows] action in dashboard widget.
  List<TasksRow>? ongoingTasksData;
  // Stores action output result for [Backend Call - Query Rows] action in dashboard widget.
  List<TasksRow>? completedTasksData;
  // Stores action output result for [Backend Call - SQLite (Get Queued Changes)] action in dashboard widget.
  List<GetQueuedChangesRow>? varname;
  // Stores action output result for [Backend Call - SQLite (SELECT TASKS base on status)] action in dashboard widget.
  List<SELECTTASKSBaseOnStatusRow>? offlineForDispatchTasksData;
  // Stores action output result for [Backend Call - SQLite (SELECT TASKS base on status)] action in dashboard widget.
  List<SELECTTASKSBaseOnStatusRow>? offlineOngoingTasksData;
  // Stores action output result for [Backend Call - SQLite (SELECT TASKS base on status)] action in dashboard widget.
  List<SELECTTASKSBaseOnStatusRow>? offlineCompletedTasksData;
  // Stores action output result for [Backend Call - SQLite (SELECT SYNC LOGS)] action in dashboard widget.
  List<SelectSyncLogsRow>? ddd;
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

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
    tasksModels1 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels2 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels3 = FlutterFlowDynamicModels(() => TasksModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    connectivityModel.dispose();
    textFieldFocusNode?.dispose();

    tabBarController?.dispose();
    tasksModels1.dispose();
    tasksModels2.dispose();
    tasksModels3.dispose();
  }
}

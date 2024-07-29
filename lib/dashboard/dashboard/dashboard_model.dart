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

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Action Block - queryCurrentUserProfile] action in dashboard widget.
  UsersRow? currentUserProfile;
  // Stores action output result for [Backend Call - Query Rows] action in dashboard widget.
  List<TasksRow>? forDispatchTasksData;
  // Stores action output result for [Backend Call - Query Rows] action in dashboard widget.
  List<TasksRow>? ongoingTasksData;
  // Stores action output result for [Backend Call - Query Rows] action in dashboard widget.
  List<TasksRow>? completedTasksData;
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

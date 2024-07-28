import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import '/utils/components/tasks/tasks_widget.dart';
import 'dashboard_widget.dart' show DashboardWidget;
import 'package:flutter/material.dart';

class DashboardModel extends FlutterFlowModel<DashboardWidget> {
  ///  Local state fields for this page.

  int? forDispatchCount = 0;

  int? ongoingCount = 0;

  int? completedCount = 0;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
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

  /// Action blocks.
  Future queryTasksByStatus(BuildContext context) async {
    List<TasksRow>? forDispatchTasksData;
    List<TasksRow>? ongoingTasksData;
    List<TasksRow>? completedTasksData;

    forDispatchTasksData = await TasksTable().queryRows(
      queryFn: (q) => q
          .eq(
            'task_type',
            'for dispatch',
          )
          .order('updated_at'),
    );
    ongoingTasksData = await TasksTable().queryRows(
      queryFn: (q) => q
          .eq(
            'task_type',
            'ongoing',
          )
          .order('updated_at'),
    );
    completedTasksData = await TasksTable().queryRows(
      queryFn: (q) => q
          .eq(
            'task_type',
            'completed',
          )
          .order('updated_at'),
    );
    forDispatchCount = valueOrDefault<int>(
      forDispatchTasksData.length,
      0,
    );
    ongoingCount = valueOrDefault<int>(
      ongoingTasksData.length,
      0,
    );
    completedCount = valueOrDefault<int>(
      completedTasksData.length,
      0,
    );
  }
}

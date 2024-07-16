import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/tasks/tasks_widget.dart';
import 'dashboard_widget.dart' show DashboardWidget;
import 'package:flutter/material.dart';

class DashboardModel extends FlutterFlowModel<DashboardWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  final textFieldKey = GlobalKey();
  FocusNode? textFieldFocusNode;
  TextEditingController? textController1;
  String? textFieldSelectedOption;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for mobileFindTasksInputField widget.
  FocusNode? mobileFindTasksInputFieldFocusNode;
  TextEditingController? mobileFindTasksInputFieldTextController;
  String? Function(BuildContext, String?)?
      mobileFindTasksInputFieldTextControllerValidator;
  // State field(s) for TabBar widget.
  TabController? tabBarController1;
  int get tabBarCurrentIndex1 =>
      tabBarController1 != null ? tabBarController1!.index : 0;

  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels1;
  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels2;
  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels3;
  // State field(s) for TabBar widget.
  TabController? tabBarController2;
  int get tabBarCurrentIndex2 =>
      tabBarController2 != null ? tabBarController2!.index : 0;

  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels4;
  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels5;
  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels6;
  // State field(s) for TabBar widget.
  TabController? tabBarController3;
  int get tabBarCurrentIndex3 =>
      tabBarController3 != null ? tabBarController3!.index : 0;

  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels7;
  // State field(s) for TabBar widget.
  TabController? tabBarController4;
  int get tabBarCurrentIndex4 =>
      tabBarController4 != null ? tabBarController4!.index : 0;

  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels8;
  // State field(s) for TabBar widget.
  TabController? tabBarController5;
  int get tabBarCurrentIndex5 =>
      tabBarController5 != null ? tabBarController5!.index : 0;

  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels9;

  @override
  void initState(BuildContext context) {
    tasksModels1 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels2 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels3 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels4 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels5 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels6 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels7 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels8 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels9 = FlutterFlowDynamicModels(() => TasksModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();

    mobileFindTasksInputFieldFocusNode?.dispose();
    mobileFindTasksInputFieldTextController?.dispose();

    tabBarController1?.dispose();
    tasksModels1.dispose();
    tasksModels2.dispose();
    tasksModels3.dispose();
    tabBarController2?.dispose();
    tasksModels4.dispose();
    tasksModels5.dispose();
    tasksModels6.dispose();
    tabBarController3?.dispose();
    tasksModels7.dispose();
    tabBarController4?.dispose();
    tasksModels8.dispose();
    tabBarController5?.dispose();
    tasksModels9.dispose();
  }
}

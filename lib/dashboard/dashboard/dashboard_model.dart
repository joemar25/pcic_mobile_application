import '/auth/supabase_auth/auth_util.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import '/utils/components/empty_lists/empty_lists_widget.dart';
import '/utils/components/sync/sync_widget.dart';
import '/utils/components/tasks/tasks_widget.dart';
import 'dart:math';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'dashboard_widget.dart' show DashboardWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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

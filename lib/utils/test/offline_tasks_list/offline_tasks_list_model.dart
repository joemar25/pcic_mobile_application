import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/components/empty_lists/empty_lists_widget.dart';
import 'offline_tasks_list_widget.dart' show OfflineTasksListWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OfflineTasksListModel extends FlutterFlowModel<OfflineTasksListWidget> {
  ///  Local state fields for this page.

  String? out;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - SQLite (SELECT TASKS base on status)] action in offlineTasksList widget.
  List<SELECTTASKSBaseOnStatusRow>? offlineOngoingTasks;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

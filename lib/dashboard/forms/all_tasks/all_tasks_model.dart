import '/auth/supabase_auth/auth_util.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import '/utils/components/empty_lists/empty_lists_widget.dart';
import '/utils/components/page_loader/page_loader_widget.dart';
import 'dart:async';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'all_tasks_widget.dart' show AllTasksWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:text_search/text_search.dart';

class AllTasksModel extends FlutterFlowModel<AllTasksWidget> {
  ///  Local state fields for this page.

  String statusOutput = 'Syncing...';

  bool isSyncDone = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - isDirtyCount] action in allTasks widget.
  String? isDirtyCounter;
  // Stores action output result for [Custom Action - syncOnlineTaskAndPpirToOffline] action in allTasks widget.
  String? messagexxxx;
  // Stores action output result for [Custom Action - syncOnlineTaskAndPpirToOffline] action in Text widget.
  String? message;
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  List<String> simpleSearchResults = [];
  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController = FlutterFlowDataTableController<
      SELECTPPIRFormsByAssigneeAndTaskStatusRow>();

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();

    paginatedDataTableController.dispose();
  }
}

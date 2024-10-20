import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import 'all_tasks_original_widget.dart' show AllTasksOriginalWidget;
import 'package:flutter/material.dart';

class AllTasksOriginalModel extends FlutterFlowModel<AllTasksOriginalWidget> {
  ///  Local state fields for this page.

  String statusOutput = 'Syncing...';

  bool isSyncDone = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - isDirtyCount] action in allTasksOriginal widget.
  String? isDirtyCounterr;
  // Stores action output result for [Custom Action - syncOnlineTaskAndPpirToOffline] action in allTasksOriginal widget.
  String? outputMsg;
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

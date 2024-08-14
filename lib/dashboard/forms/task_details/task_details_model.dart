import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import '/utils/components/saving_mode/saving_mode_widget.dart';
import 'task_details_widget.dart' show TaskDetailsWidget;
import 'package:flutter/material.dart';

class TaskDetailsModel extends FlutterFlowModel<TaskDetailsWidget> {
  ///  Local state fields for this page.

  bool? isReFTPClicked = false;

  String statusOutput = 'Up to date';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - SQLite (SELECT PPIR FORMS)] action in taskDetails widget.
  List<SelectPpirFormsRow>? offlinePPIR;
  // Stores action output result for [Backend Call - Update Row(s)] action in Text widget.
  List<PpirFormsRow>? savePPIR;
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // Stores action output result for [Custom Action - saveToFTP] action in reFTP widget.
  bool? isFtpSaved;
  // Model for savingMode component.
  late SavingModeModel savingModeModel;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
    savingModeModel = createModel(context, () => SavingModeModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
    savingModeModel.dispose();
  }
}

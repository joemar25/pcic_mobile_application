import '/flutter_flow/flutter_flow_util.dart';
import '/utils/extra/saving_mode/saving_mode_widget.dart';
import 'task_details_widget.dart' show TaskDetailsWidget;
import 'package:flutter/material.dart';

class TaskDetailsModel extends FlutterFlowModel<TaskDetailsWidget> {
  ///  Local state fields for this page.

  bool? isEditing = true;

  bool? isReFTP = true;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for farm_loc_input widget.
  FocusNode? farmLocInputFocusNode;
  TextEditingController? farmLocInputTextController;
  String? Function(BuildContext, String?)? farmLocInputTextControllerValidator;
  // Stores action output result for [Custom Action - saveToFTP] action in resubmitFtp widget.
  bool? isFtpSaved;
  // Model for savingMode component.
  late SavingModeModel savingModeModel;

  @override
  void initState(BuildContext context) {
    savingModeModel = createModel(context, () => SavingModeModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    farmLocInputFocusNode?.dispose();
    farmLocInputTextController?.dispose();

    savingModeModel.dispose();
  }
}

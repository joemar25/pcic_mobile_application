import '/flutter_flow/flutter_flow_util.dart';
import 'task_details_widget.dart' show TaskDetailsWidget;
import 'package:flutter/material.dart';

class TaskDetailsModel extends FlutterFlowModel<TaskDetailsWidget> {
  ///  Local state fields for this page.

  bool? isEditing = true;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for farm_loc_input widget.
  FocusNode? farmLocInputFocusNode;
  TextEditingController? farmLocInputTextController;
  String? Function(BuildContext, String?)? farmLocInputTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    farmLocInputFocusNode?.dispose();
    farmLocInputTextController?.dispose();
  }
}

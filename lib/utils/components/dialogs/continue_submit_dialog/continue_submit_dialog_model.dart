import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'continue_submit_dialog_widget.dart' show ContinueSubmitDialogWidget;
import 'package:flutter/material.dart';

class ContinueSubmitDialogModel
    extends FlutterFlowModel<ContinueSubmitDialogWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Update Row(s)] action in submitButton widget.
  List<PpirFormsRow>? savePPIRCopy;
  // Stores action output result for [Custom Action - generateTaskXml] action in submitButton widget.
  String? generatedXML;
  // Stores action output result for [Custom Action - saveToFTP] action in submitButton widget.
  bool? isFtpSaved;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

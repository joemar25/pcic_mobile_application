import '/flutter_flow/flutter_flow_util.dart';
import 'other_form_widget.dart' show OtherFormWidget;
import 'package:flutter/material.dart';

class OtherFormModel extends FlutterFlowModel<OtherFormWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

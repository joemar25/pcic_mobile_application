import '/flutter_flow/flutter_flow_util.dart';
import 'success_profile_widget.dart' show SuccessProfileWidget;
import 'package:flutter/material.dart';

class SuccessProfileModel extends FlutterFlowModel<SuccessProfileWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

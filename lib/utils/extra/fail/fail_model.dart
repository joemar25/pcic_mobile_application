import '/flutter_flow/flutter_flow_util.dart';
import 'fail_widget.dart' show FailWidget;
import 'package:flutter/material.dart';

class FailModel extends FlutterFlowModel<FailWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

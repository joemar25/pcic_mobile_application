import '/flutter_flow/flutter_flow_util.dart';
import 'sss_widget.dart' show SssWidget;
import 'package:flutter/material.dart';

class SssModel extends FlutterFlowModel<SssWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

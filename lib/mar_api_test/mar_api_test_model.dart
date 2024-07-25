import '/flutter_flow/flutter_flow_util.dart';
import 'mar_api_test_widget.dart' show MarApiTestWidget;
import 'package:flutter/material.dart';

class MarApiTestModel extends FlutterFlowModel<MarApiTestWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

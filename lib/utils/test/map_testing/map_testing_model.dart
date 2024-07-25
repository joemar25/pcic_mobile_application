import '/flutter_flow/flutter_flow_util.dart';
import 'map_testing_widget.dart' show MapTestingWidget;
import 'package:flutter/material.dart';

class MapTestingModel extends FlutterFlowModel<MapTestingWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

import '/flutter_flow/flutter_flow_util.dart';
import 'geotag_widget.dart' show GeotagWidget;
import 'package:flutter/material.dart';

class GeotagModel extends FlutterFlowModel<GeotagWidget> {
  ///  Local state fields for this page.

  bool isGeotagStart = true;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks.
  Future test(BuildContext context) async {}
}

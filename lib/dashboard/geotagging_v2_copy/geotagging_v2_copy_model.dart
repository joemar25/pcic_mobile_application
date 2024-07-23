import '/flutter_flow/flutter_flow_util.dart';
import 'geotagging_v2_copy_widget.dart' show GeotaggingV2CopyWidget;
import 'package:flutter/material.dart';

class GeotaggingV2CopyModel extends FlutterFlowModel<GeotaggingV2CopyWidget> {
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
}

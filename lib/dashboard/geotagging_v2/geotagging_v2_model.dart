import '/flutter_flow/flutter_flow_util.dart';
import 'geotagging_v2_widget.dart' show GeotaggingV2Widget;
import 'package:flutter/material.dart';

class GeotaggingV2Model extends FlutterFlowModel<GeotaggingV2Widget> {
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

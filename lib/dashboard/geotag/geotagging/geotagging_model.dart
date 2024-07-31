import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'geotagging_widget.dart' show GeotaggingWidget;
import 'package:flutter/material.dart';

class GeotaggingModel extends FlutterFlowModel<GeotaggingWidget> {
  ///  Local state fields for this page.

  bool isGeotagStart = true;

  bool isFinished = true;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - fetchAddressFromCoordinates] action in geotagging widget.
  dynamic getCurrentLocationAddress;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

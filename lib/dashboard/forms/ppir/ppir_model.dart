import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'ppir_widget.dart' show PpirWidget;
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class PpirModel extends FlutterFlowModel<PpirWidget> {
  ///  Local state fields for this page.

  bool isRice = true;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for track_coordinates widget.
  FocusNode? trackCoordinatesFocusNode;
  TextEditingController? trackCoordinatesTextController;
  String? Function(BuildContext, String?)?
      trackCoordinatesTextControllerValidator;
  // State field(s) for track_date_time widget.
  FocusNode? trackDateTimeFocusNode;
  TextEditingController? trackDateTimeTextController;
  String? Function(BuildContext, String?)? trackDateTimeTextControllerValidator;
  // State field(s) for track_total_area widget.
  FocusNode? trackTotalAreaFocusNode;
  TextEditingController? trackTotalAreaTextController;
  String? Function(BuildContext, String?)?
      trackTotalAreaTextControllerValidator;
  // State field(s) for track_farmloc widget.
  FocusNode? trackFarmlocFocusNode;
  TextEditingController? trackFarmlocTextController;
  String? Function(BuildContext, String?)? trackFarmlocTextControllerValidator;
  // State field(s) for varietySelection widget.
  FormFieldController<String>? varietySelectionValueController;
  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  // State field(s) for area_planted_field widget.
  FocusNode? areaPlantedFieldFocusNode;
  TextEditingController? areaPlantedFieldTextController;
  String? Function(BuildContext, String?)?
      areaPlantedFieldTextControllerValidator;
  // State field(s) for area_dop_ds_field widget.
  FocusNode? areaDopDsFieldFocusNode;
  TextEditingController? areaDopDsFieldTextController;
  String? Function(BuildContext, String?)?
      areaDopDsFieldTextControllerValidator;
  // State field(s) for area_dop_ts_field widget.
  FocusNode? areaDopTsFieldFocusNode;
  TextEditingController? areaDopTsFieldTextController;
  String? Function(BuildContext, String?)?
      areaDopTsFieldTextControllerValidator;
  // State field(s) for confirmed_by_name_field widget.
  FocusNode? confirmedByNameFieldFocusNode;
  TextEditingController? confirmedByNameFieldTextController;
  String? Function(BuildContext, String?)?
      confirmedByNameFieldTextControllerValidator;
  // State field(s) for confirmed_by_sig_field widget.
  FocusNode? confirmedBySigFieldFocusNode;
  TextEditingController? confirmedBySigFieldTextController;
  String? Function(BuildContext, String?)?
      confirmedBySigFieldTextControllerValidator;
  // State field(s) for prepared_by_name_field widget.
  FocusNode? preparedByNameFieldFocusNode;
  TextEditingController? preparedByNameFieldTextController;
  String? Function(BuildContext, String?)?
      preparedByNameFieldTextControllerValidator;
  // State field(s) for prepared_by_sig_field widget.
  SignatureController? preparedBySigFieldController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    trackCoordinatesFocusNode?.dispose();
    trackCoordinatesTextController?.dispose();

    trackDateTimeFocusNode?.dispose();
    trackDateTimeTextController?.dispose();

    trackTotalAreaFocusNode?.dispose();
    trackTotalAreaTextController?.dispose();

    trackFarmlocFocusNode?.dispose();
    trackFarmlocTextController?.dispose();

    areaPlantedFieldFocusNode?.dispose();
    areaPlantedFieldTextController?.dispose();

    areaDopDsFieldFocusNode?.dispose();
    areaDopDsFieldTextController?.dispose();

    areaDopTsFieldFocusNode?.dispose();
    areaDopTsFieldTextController?.dispose();

    confirmedByNameFieldFocusNode?.dispose();
    confirmedByNameFieldTextController?.dispose();

    confirmedBySigFieldFocusNode?.dispose();
    confirmedBySigFieldTextController?.dispose();

    preparedByNameFieldFocusNode?.dispose();
    preparedByNameFieldTextController?.dispose();

    preparedBySigFieldController?.dispose();
  }

  /// Additional helper methods.
  String? get varietySelectionValue => varietySelectionValueController?.value;
}

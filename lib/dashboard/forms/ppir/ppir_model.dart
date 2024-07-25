import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'ppir_widget.dart' show PpirWidget;
import 'package:flutter/material.dart';

class PpirModel extends FlutterFlowModel<PpirWidget> {
  ///  Local state fields for this page.

  bool isRice = true;

  String? riceSelectedValue;

  String? cornSelectedValue;

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
  // State field(s) for svp_act_selection widget.
  FormFieldController<String>? svpActSelectionValueController;
  // State field(s) for seed_var_rice_dropdown widget.
  String? seedVarRiceDropdownValue;
  FormFieldController<String>? seedVarRiceDropdownValueController;
  // State field(s) for seed_var_corn_dropdown widget.
  String? seedVarCornDropdownValue;
  FormFieldController<String>? seedVarCornDropdownValueController;
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
  // State field(s) for remarks_field widget.
  FocusNode? remarksFieldFocusNode;
  TextEditingController? remarksFieldTextController;
  String? Function(BuildContext, String?)? remarksFieldTextControllerValidator;
  // State field(s) for prepared_by_name_field widget.
  FocusNode? preparedByNameFieldFocusNode;
  TextEditingController? preparedByNameFieldTextController;
  String? Function(BuildContext, String?)?
      preparedByNameFieldTextControllerValidator;
  // State field(s) for confirmed_by_name_field widget.
  FocusNode? confirmedByNameFieldFocusNode;
  TextEditingController? confirmedByNameFieldTextController;
  String? Function(BuildContext, String?)?
      confirmedByNameFieldTextControllerValidator;
  // Stores action output result for [Backend Call - Update Row(s)] action in submitButton widget.
  List<PpirFormsRow>? updatedPPIR;
  // Stores action output result for [Backend Call - Update Row(s)] action in submitButton widget.
  List<PpirFormsRow>? riceVariety;
  // Stores action output result for [Backend Call - Update Row(s)] action in submitButton widget.
  List<PpirFormsRow>? cornVariety;

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

    remarksFieldFocusNode?.dispose();
    remarksFieldTextController?.dispose();

    preparedByNameFieldFocusNode?.dispose();
    preparedByNameFieldTextController?.dispose();

    confirmedByNameFieldFocusNode?.dispose();
    confirmedByNameFieldTextController?.dispose();
  }

  /// Additional helper methods.
  String? get svpActSelectionValue => svpActSelectionValueController?.value;
}

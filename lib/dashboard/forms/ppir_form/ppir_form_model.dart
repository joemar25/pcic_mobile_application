import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import 'ppir_form_widget.dart' show PpirFormWidget;
import 'package:flutter/material.dart';

class PpirFormModel extends FlutterFlowModel<PpirFormWidget> {
  ///  Local state fields for this page.

  bool isMapDownloaded = false;

  ///  State fields for stateful widgets in this page.

  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // Stores action output result for [Custom Action - generateTaskXml] action in Text widget.
  String? generatedTaskXmlFile;
  // Stores action output result for [Custom Action - getGpxLink] action in repeatGeotagButtonT widget.
  String? gpxLink;
  // State field(s) for ppir_track_coordinates widget.
  FocusNode? ppirTrackCoordinatesFocusNode;
  TextEditingController? ppirTrackCoordinatesTextController;
  String? Function(BuildContext, String?)?
      ppirTrackCoordinatesTextControllerValidator;
  // State field(s) for ppir_track_total_area widget.
  FocusNode? ppirTrackTotalAreaFocusNode1;
  TextEditingController? ppirTrackTotalAreaTextController1;
  String? Function(BuildContext, String?)?
      ppirTrackTotalAreaTextController1Validator;
  // State field(s) for ppir_track_date_time widget.
  FocusNode? ppirTrackDateTimeFocusNode;
  TextEditingController? ppirTrackDateTimeTextController;
  String? Function(BuildContext, String?)?
      ppirTrackDateTimeTextControllerValidator;
  // State field(s) for ppir_track_total_area widget.
  FocusNode? ppirTrackTotalAreaFocusNode2;
  TextEditingController? ppirTrackTotalAreaTextController2;
  String? Function(BuildContext, String?)?
      ppirTrackTotalAreaTextController2Validator;
  // State field(s) for ppir_track_farmloc widget.
  FocusNode? ppirTrackFarmlocFocusNode;
  TextEditingController? ppirTrackFarmlocTextController;
  String? Function(BuildContext, String?)?
      ppirTrackFarmlocTextControllerValidator;
  // State field(s) for ppir_svp_act_selection widget.
  FormFieldController<String>? ppirSvpActSelectionValueController;
  // State field(s) for riceDropdown widget.
  String? riceDropdownValue;
  FormFieldController<String>? riceDropdownValueController;
  // State field(s) for cornDropdown widget.
  String? cornDropdownValue;
  FormFieldController<String>? cornDropdownValueController;
  // State field(s) for ppir_area_act_field widget.
  FocusNode? ppirAreaActFieldFocusNode;
  TextEditingController? ppirAreaActFieldTextController;
  String? Function(BuildContext, String?)?
      ppirAreaActFieldTextControllerValidator;
  // State field(s) for ppir_area_dop_ds_field widget.
  FocusNode? ppirAreaDopDsFieldFocusNode;
  TextEditingController? ppirAreaDopDsFieldTextController;
  String? Function(BuildContext, String?)?
      ppirAreaDopDsFieldTextControllerValidator;
  DateTime? datePicked1;
  // State field(s) for ppir_area_dop_tp_field widget.
  FocusNode? ppirAreaDopTpFieldFocusNode;
  TextEditingController? ppirAreaDopTpFieldTextController;
  String? Function(BuildContext, String?)?
      ppirAreaDopTpFieldTextControllerValidator;
  DateTime? datePicked2;
  // State field(s) for ppir_remarks_field widget.
  FocusNode? ppirRemarksFieldFocusNode;
  TextEditingController? ppirRemarksFieldTextController;
  String? Function(BuildContext, String?)?
      ppirRemarksFieldTextControllerValidator;
  // State field(s) for ppir_prepared_by_name_field widget.
  FocusNode? ppirPreparedByNameFieldFocusNode;
  TextEditingController? ppirPreparedByNameFieldTextController;
  String? Function(BuildContext, String?)?
      ppirPreparedByNameFieldTextControllerValidator;
  // State field(s) for ppir_confirmed_by_name_field widget.
  FocusNode? ppirConfirmedByNameFieldFocusNode;
  TextEditingController? ppirConfirmedByNameFieldTextController;
  String? Function(BuildContext, String?)?
      ppirConfirmedByNameFieldTextControllerValidator;
  // Stores action output result for [Backend Call - Update Row(s)] action in saveButton widget.
  List<PpirFormsRow>? savePPIR;
  // Stores action output result for [Backend Call - Update Row(s)] action in saveButton widget.
  List<TasksRow>? updatedStatus;
  // Stores action output result for [Backend Call - Update Row(s)] action in submitButton widget.
  List<PpirFormsRow>? savePPIRCopy;
  // Stores action output result for [Backend Call - Update Row(s)] action in submitButton widget.
  List<TasksRow>? updatedStatusCopy;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
    ppirTrackCoordinatesFocusNode?.dispose();
    ppirTrackCoordinatesTextController?.dispose();

    ppirTrackTotalAreaFocusNode1?.dispose();
    ppirTrackTotalAreaTextController1?.dispose();

    ppirTrackDateTimeFocusNode?.dispose();
    ppirTrackDateTimeTextController?.dispose();

    ppirTrackTotalAreaFocusNode2?.dispose();
    ppirTrackTotalAreaTextController2?.dispose();

    ppirTrackFarmlocFocusNode?.dispose();
    ppirTrackFarmlocTextController?.dispose();

    ppirAreaActFieldFocusNode?.dispose();
    ppirAreaActFieldTextController?.dispose();

    ppirAreaDopDsFieldFocusNode?.dispose();
    ppirAreaDopDsFieldTextController?.dispose();

    ppirAreaDopTpFieldFocusNode?.dispose();
    ppirAreaDopTpFieldTextController?.dispose();

    ppirRemarksFieldFocusNode?.dispose();
    ppirRemarksFieldTextController?.dispose();

    ppirPreparedByNameFieldFocusNode?.dispose();
    ppirPreparedByNameFieldTextController?.dispose();

    ppirConfirmedByNameFieldFocusNode?.dispose();
    ppirConfirmedByNameFieldTextController?.dispose();
  }

  /// Additional helper methods.
  String? get ppirSvpActSelectionValue =>
      ppirSvpActSelectionValueController?.value;
}

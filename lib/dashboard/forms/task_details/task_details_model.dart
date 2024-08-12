import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/components/page_loader/page_loader_widget.dart';
import '/utils/components/saving_mode/saving_mode_widget.dart';
import '/utils/components/toast/toast_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'task_details_widget.dart' show TaskDetailsWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TaskDetailsModel extends FlutterFlowModel<TaskDetailsWidget> {
  ///  Local state fields for this page.

  bool? isEditing = true;

  bool? isReFTPClicked = true;

  ///  State fields for stateful widgets in this page.

  // State field(s) for farm_loc_input widget.
  FocusNode? farmLocInputFocusNode;
  TextEditingController? farmLocInputTextController;
  String? Function(BuildContext, String?)? farmLocInputTextControllerValidator;
  // Stores action output result for [Custom Action - saveToFTP] action in reFTP widget.
  bool? isFtpSaved;
  // Model for savingMode component.
  late SavingModeModel savingModeModel;

  @override
  void initState(BuildContext context) {
    savingModeModel = createModel(context, () => SavingModeModel());
  }

  @override
  void dispose() {
    farmLocInputFocusNode?.dispose();
    farmLocInputTextController?.dispose();

    savingModeModel.dispose();
  }
}

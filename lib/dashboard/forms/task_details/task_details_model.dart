import '/auth/supabase_auth/auth_util.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import '/utils/components/dialogs/upload_failed_dialog/upload_failed_dialog_widget.dart';
import '/utils/components/page_loader/page_loader_widget.dart';
import '/utils/components/saving_mode/saving_mode_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:styled_divider/styled_divider.dart';
import 'task_details_widget.dart' show TaskDetailsWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TaskDetailsModel extends FlutterFlowModel<TaskDetailsWidget> {
  ///  Local state fields for this page.

  bool? isReFTPClicked = false;

  String statusOutput = 'Up to date';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - updateOnlinePpirFormsFromOfflinePpirForms] action in taskDetails widget.
  String? message;
  // Stores action output result for [Custom Action - updateOnlinePpirFormsFromOfflinePpirForms] action in Text widget.
  String? messageCopy;
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // Stores action output result for [Custom Action - generateTaskXml] action in reFTP widget.
  String? generatedXML;
  // Stores action output result for [Custom Action - saveToFTP] action in reFTP widget.
  bool? isFtpSaved;
  // Model for savingMode component.
  late SavingModeModel savingModeModel;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
    savingModeModel = createModel(context, () => SavingModeModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
    savingModeModel.dispose();
  }
}

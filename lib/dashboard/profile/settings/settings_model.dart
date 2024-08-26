import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import 'settings_widget.dart' show SettingsWidget;
import 'package:flutter/material.dart';

class SettingsModel extends FlutterFlowModel<SettingsWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getTheSavedLocalProfile] action in settings widget.
  FFUploadedFile? getProfilePic;
  // Stores action output result for [Custom Action - isDirtyCount] action in settings widget.
  String? isDirtyCounter;
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // Stores action output result for [Alert Dialog - Custom Dialog] action in Row widget.
  bool? answerKey;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
  }
}

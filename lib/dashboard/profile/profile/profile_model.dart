import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import 'profile_widget.dart' show ProfileWidget;
import 'package:flutter/material.dart';

class ProfileModel extends FlutterFlowModel<ProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getTheSavedLocalProfile] action in profile widget.
  FFUploadedFile? getProfilePic;
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // Stores action output result for [Backend Call - SQLite (OFFLINE select REGION CODE)] action in Row widget.
  List<OFFLINESelectREGIONCODERow>? regionCode;
  // Stores action output result for [Custom Action - syncFromFTP] action in Row widget.
  bool? isSyced;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
  }
}

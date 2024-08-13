import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import 'profile_widget.dart' show ProfileWidget;
import 'package:flutter/material.dart';

class ProfileModel extends FlutterFlowModel<ProfileWidget> {
  ///  Local state fields for this page.

  int? iteration = 0;

  int? limit;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - SQLite (SELECT PROFILE)] action in profile widget.
  List<SelectProfileRow>? offlineSelectUserProfile;
  // Stores action output result for [Backend Call - Query Rows] action in profile widget.
  List<UsersRow>? onlineUserProfile;
  // Stores action output result for [Custom Action - getTheSavedLocalProfile] action in profile widget.
  FFUploadedFile? getProfilePic;
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // Stores action output result for [Custom Action - getTheSavedLocalProfile] action in inspectorNameText widget.
  FFUploadedFile? savedLocalProfile;
  // Stores action output result for [Backend Call - Query Rows] action in Row widget.
  List<TasksRow>? onlineTasks;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
  }
}

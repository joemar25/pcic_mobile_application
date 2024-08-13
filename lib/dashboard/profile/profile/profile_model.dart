import '/auth/supabase_auth/auth_util.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import '/utils/components/signout_dialog/signout_dialog_widget.dart';
import 'dart:math';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'profile_widget.dart' show ProfileWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

import '/auth/supabase_auth/auth_util.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/components/page_loader/page_loader_widget.dart';
import 'dart:math';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'sync_widget.dart' show SyncWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SyncModel extends FlutterFlowModel<SyncWidget> {
  ///  Local state fields for this page.

  int? limit = 0;

  int? iteration = 0;

  bool isSync = false;

  bool startSync = false;

  bool isSynced = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - SQLite (OFFLINE select REGION CODE)] action in Container widget.
  List<OFFLINESelectREGIONCODERow>? regionCode;
  // Stores action output result for [Custom Action - syncFromFTP] action in Container widget.
  bool? isSyced;
  // Stores action output result for [Custom Action - syncOnlineTaskAndPpirToOffline] action in Container widget.
  String? syncMessage;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

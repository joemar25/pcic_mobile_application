import '/auth/supabase_auth/auth_util.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:async';
import 'dart:math';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'tasks_widget.dart' show TasksWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TasksModel extends FlutterFlowModel<TasksWidget> {
  ///  Local state fields for this component.

  String? isDirty = 'false';

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - isDirty] action in tasks widget.
  String? output;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

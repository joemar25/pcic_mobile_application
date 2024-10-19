import '/auth/supabase_auth/auth_util.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/components/dialogs/continue_go_back_dialog/continue_go_back_dialog_widget.dart';
import 'dart:async';
import 'dart:math';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'geotagging_widget.dart' show GeotaggingWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GeotaggingModel extends FlutterFlowModel<GeotaggingWidget> {
  ///  Local state fields for this page.

  bool isGeotagStart = true;

  bool isFinished = true;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - fetchAddressFromCoordinates] action in geotagging widget.
  dynamic? getCurrentLocationAddress;
  // Stores action output result for [Alert Dialog - Custom Dialog] action in back widget.
  bool? confirmBack;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

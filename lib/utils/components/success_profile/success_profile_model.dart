import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import '/custom_code/actions/index.dart' as actions;
import 'success_profile_widget.dart' show SuccessProfileWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SuccessProfileModel extends FlutterFlowModel<SuccessProfileWidget> {
  ///  Local state fields for this page.

  String latestProfileDatas = 'latestProfileDatas.inspector_name';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getTheSavedLocalProfile] action in successProfile widget.
  FFUploadedFile? latestProfileData;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

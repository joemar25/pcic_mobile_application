// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';

Future successToast(
  BuildContext context,
  String title, // title of the notification
  String description, // description text in the notification
  int animationDuration, // duration in seconds
  int toastDuration,
  Future<dynamic> Function()? onClosePressed, // action done on 'close' pressed
  Future<dynamic> Function()?
      onAnimationEnd, // action done on when duration elapses
) async {
// see here that ElegantNotification without any 'dot something' in front
  ElegantNotification(
    title: Text(title),
    description: Text(description),
    animationDuration: Duration(milliseconds: animationDuration),
    toastDuration: Duration(milliseconds: toastDuration),
    icon: Icon(
// you can specify which icon you want, here I am using Material icons Library
      Icons.check_circle_outline,
      color: Colors.green,
    ),
// here you specify the colour of the progress bar, I am using Orange
    progressIndicatorColor: Colors.green,
// these two lines below allow actions to be triggered on close pressed or on end
    onCloseButtonPressed: onClosePressed,
    onProgressFinished: onAnimationEnd,
  ).show(context);
}

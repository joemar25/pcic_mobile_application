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

import 'package:p_c_i_c_mobile_app/custom_code/widgets/map_box.dart';

Future centerMap(BuildContext context) async {
  final mapBoxWidget = context.findAncestorWidgetOfExactType<MapBox>();
  if (mapBoxWidget != null) {
    mapBoxWidget.recenterMap();
  } else {
    print('MapBox widget not found in the widget tree');
  }
}

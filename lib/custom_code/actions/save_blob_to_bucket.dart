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

Future<String> saveBlobToBucket(String? taskId) async {
  // we need to save the gpx, ppir_sig_insured, and ppir_sig_iuia blobs into the supabase bucket for softcopy
  // the gpx will have a random_id.gpx, same as random_id_ppir_sig_iuia.png and random_id_ppir_sig_insured.png
  //  stored inside: final filePath = '$serviceGroup/$userEmail/$taskNumber/attachments/geotag.gpx';
  // Add your function code here!
  return 'success';
}

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

import 'package:flutter_downloader/flutter_downloader.dart';

Future<String> downloadTaskXml(String? genratedTaskXml) async {
  // download the generated task xml
  if (genratedTaskXml == null) {
    return "Error: Generated task XML is null";
  }

  try {
    final taskId = await FlutterDownloader.enqueue(
      url: genratedTaskXml,
      savedDir: '/storage/emulated/0/Download',
      showNotification: true,
      openFileFromNotification: true,
    );
    return "Task XML downloaded successfully with task ID: $taskId";
  } catch (error) {
    return "Error downloading task XML: $error";
  }
}

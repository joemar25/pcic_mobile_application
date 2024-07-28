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

import 'package:xml/xml.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> generateTaskXml(String? taskId) async {
  if (taskId == null) {
    throw Exception('Task ID cannot be null');
  }

  final supabase = Supabase.instance.client;

  final response =
      await supabase.from('ppir_forms').select().eq('task_id', taskId);

  final data = response as List<dynamic>;
  if (data.isEmpty) {
    throw Exception('No matching data found for task ID: $taskId');
  }

  final builder = XmlBuilder();
  builder.processing('xml', 'version="1.0"');
  builder.element('ppir_forms', nest: () {
    for (final row in data) {
      builder.element('ppir_form', nest: () {
        builder.element('task_id', nest: row['task_id'].toString());
      });
    }
  });

  return builder.buildDocument().toXmlString(pretty: true);
}

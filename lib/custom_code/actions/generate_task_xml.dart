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
import 'package:dart_ipify/dart_ipify.dart';

Future<String> generateTaskXml(String? taskId) async {
  if (taskId == null) {
    throw Exception('Task ID cannot be null');
  }

  final response = await Supabase.instance.client
      .rpc('get_tasks_ppir_forms_and_users')
      .eq('task_id', taskId)
      .single()
      .execute();

  if (response.status != 200 || response.data == null) {
    throw Exception('No matching data found for task ID: $taskId');
  }

  final data = response.data as Map<String, dynamic>;

  print("--->");
  print(data);
  print("<---");

  String serviceType = data['service_type']?.toString() ?? '';
  String regionName = serviceType.replaceAll(' PPIR', '');
  String trackLastcoord = data['trackLastcoord']?.toString() ?? '';

  // mar
  final ipv4 = await Ipify.ipv4();
  final coords = trackLastcoord.split(',');
  final latitude = coords.isNotEmpty ? double.tryParse(coords[0]) : null;
  final longitude = coords.length > 1 ? double.tryParse(coords[1]) : null;
  final timestamp = DateTime.now().toIso8601String();
  final date = DateTime.now().toIso8601String().split('T').first;

  Map<String, dynamic> address = {};
  if (latitude != null && longitude != null) {
    address = await fetchAddressFromCoordinates(latitude, longitude);
  }

  final locationJson = jsonEncode({
    "accuracy": null,
    "barangayVillage": address["barangayVillage"],
    "buildingName": address["buildingName"],
    "city": address["city"],
    "country": address["country"],
    "latitude": latitude,
    "longitude": longitude,
    "province": address["province"],
    "street": address["street"],
    "timestamp": DateTime.now().toIso8601String(),
    "unitLotNo": address["unitLotNo"],
    "zipCode": address["zipCode"]
  });

  final builder = XmlBuilder();

  builder.processing('xml', 'version="1.0"');
  builder.element('Task', nest: () {
    builder.element('TaskId', nest: taskId);
    builder.element('RegionName', nest: regionName);
    builder.element('IpAddress', nest: ipv4);
    builder.element('Location', nest: locationJson);
  });

  return builder.buildDocument().toXmlString(pretty: true);
}

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert'; // Import to handle JSON encoding

Future<List<dynamic>?> getCustomMessages(String? chatId) async {
  // Add your function code here!
  if (chatId == null) {
    return null;
  }

  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('messages')
      .select(
          'content, timestamp, is_read, sender_name, users!messages_sender_name_fkey(photo_url)')
      .eq('chat_id', chatId)
      .order('timestamp', ascending: true);

  final data = response.data as List<dynamic>?;
  if (data == null || data.isEmpty) {
    return [];
  }

  return data.map((e) => e as Map<String, dynamic>).toList();
}

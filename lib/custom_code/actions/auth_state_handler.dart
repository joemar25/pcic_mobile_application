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

// NOT WORKING YET!

Future<void> authStateHandler() async {
  // Create a program for handling the authentication state and updating the is_online status.

  // Check if the user is authenticated
  bool isAuthenticated = await checkAuthentication();

  if (isAuthenticated) {
    // Update the is_online status to true
    await updateOnlineStatus(true);
  } else {
    // Update the is_online status to false
    await updateOnlineStatus(false);
  }
}

Future<bool> checkAuthentication() async {
  final user = SupaFlow.client.auth.currentUser;
  return user != null;
}

Future<void> updateOnlineStatus(bool isOnline) async {
  final supabase = SupaFlow.client;
  final userId = supabase.auth.currentUser?.id;

  if (userId != null) {
    final response = await supabase
        .from('users')
        .update({'is_online': isOnline}).eq('id', userId);
    if (response.error != null) {
      print('Error updating user status: ${response.error.message}');
    }
  }
}

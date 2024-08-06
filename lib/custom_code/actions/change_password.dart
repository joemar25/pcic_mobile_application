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

Future<dynamic> changePassword(
  String oldPassword,
  String newPassword,
) async {
  try {
    final response = await Supabase.instance.client.auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );
    if (response.user != null) {
      return {'success': true, 'message': 'Password updated successfully'};
    } else {
      return {'success': false, 'message': 'Failed to update password'};
    }
  } catch (e) {
    return {'success': false, 'message': e.toString()};
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!

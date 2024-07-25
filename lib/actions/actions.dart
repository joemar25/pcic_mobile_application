import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

Future updateUserStatusIfOnline(BuildContext context) async {
  if (FFAppState().ONLINE) {
    await UsersTable().update(
      data: {
        'is_online': true,
      },
      matchingRows: (rows) => rows.eq(
        'auth_user_id',
        currentUserUid,
      ),
    );
  } else {
    await UsersTable().update(
      data: {
        'is_online': false,
      },
      matchingRows: (rows) => rows.eq(
        'auth_user_id',
        currentUserUid,
      ),
    );
  }
}

Future updateLogs(BuildContext context) async {}

Future updatePpirSigIuia(BuildContext context) async {}

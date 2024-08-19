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

// import 'package:connectivity_plus/connectivity_plus.dart';

// import 'dart:async';
// import 'dart:io';

// // for testing only -> https://www.youtube.com/watch?v=HeBmkKREzdw, this vid may fail but i modify it
// // Future connected() async {
// //   return;
// // }

// Future connected() async {
//   StreamSubscription<List<ConnectivityResult>>? subscription;
//   subscription = Connectivity()
//       .onConnectivityChanged
//       .listen((List<ConnectivityResult> result) async {
//     // Got a new connectivity status!

//     bool hasConnection = await checkConnection();

//     //print("Connection: ${hasConnection}");

//     FFAppState().update(() {
//       // in app state, i have ONLINE which is a boolean to be utilized here
//       FFAppState().ONLINE = hasConnection;
//     });
//     FFAppState().notifyListeners();
//   });
// }

// Future<bool> checkConnection() async {
//   bool hasConnection = false;

//   try {
//     final result = await InternetAddress.lookup('google.com');
//     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//       hasConnection = true;
//     } else {
//       hasConnection = false;
//     }
//   } on SocketException catch (_) {
//     hasConnection = false;
//   }

//   return hasConnection;
// }

import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'dart:io';

StreamSubscription<List<ConnectivityResult>>? _subscription;

Future connected() async {
  WidgetsBinding.instance.addObserver(_AppLifecycleObserver());
  _subscription = Connectivity()
      .onConnectivityChanged
      .listen((_) => _checkConnectivityAndUpdateStatus());
  await _checkConnectivityAndUpdateStatus();
}

Future<void> _checkConnectivityAndUpdateStatus() async {
  bool hasConnection = await checkConnection();
  _updateOnlineStatus(hasConnection);
}

Future<bool> checkConnection() async {
  bool hasConnection = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    hasConnection = false;
  }
  return hasConnection;
}

void _updateOnlineStatus(bool isOnline) {
  FFAppState().update(() {
    FFAppState().ONLINE = isOnline;
  });
  FFAppState().notifyListeners();
  updateUserOnlineStatus(isOnline);
}

Future<void> updateUserOnlineStatus(bool isOnline) async {
  await UsersTable().update(
    data: {
      'is_online': isOnline,
    },
    matchingRows: (rows) => rows.eq(
      'id',
      currentUserUid,
    ),
  );
}

class _AppLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // App is in background or closed
      _updateOnlineStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      // App is in foreground
      _checkConnectivityAndUpdateStatus();
    }
  }
}

// Call this function when you want to stop monitoring (if needed)
Future<void> stopConnectivityMonitoring() async {
  await _subscription?.cancel();
  WidgetsBinding.instance.removeObserver(_AppLifecycleObserver());
}

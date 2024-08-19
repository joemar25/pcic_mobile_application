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

import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

RealtimeChannel? _presenceChannel;
StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
bool _isOnline = false;
bool _isInitialized = false;
AppLifecycleListener? _lifecycleListener;
Timer? _periodicCheckTimer;

Future updateUserOnlineStatus() async {
  if (!_isInitialized) {
    await _initializeOnlineStatusTracker();
  }
  await _checkAndUpdateOnlineStatus();
}

Future _initializeOnlineStatusTracker() async {
  final supabase = SupaFlow.client;
  final user = supabase.auth.currentUser;

  if (user == null) {
    print('No authenticated user found');
    return;
  }

  final channelName = 'presence_${user.id}';
  _presenceChannel = supabase.channel(channelName);

  _presenceChannel!.subscribe((status, [_]) async {
    if (status == 'SUBSCRIBED') {
      await _checkAndUpdateOnlineStatus();
    }
  });

  _connectivitySubscription = Connectivity()
      .onConnectivityChanged
      .listen((List<ConnectivityResult> results) async {
    bool wasOnline = _isOnline;
    _isOnline = results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi);

    if (wasOnline && !_isOnline) {
      // Immediate offline update when connection is lost
      await _setOfflineStatus();
    } else if (!wasOnline && _isOnline) {
      // Check and update status when connection is regained
      await _checkAndUpdateOnlineStatus();
    }
  });

  _lifecycleListener = AppLifecycleListener(
    onStateChange: (AppLifecycleState state) {
      if (state == AppLifecycleState.paused ||
          state == AppLifecycleState.detached) {
        _setOfflineStatus();
      } else if (state == AppLifecycleState.resumed) {
        _checkAndUpdateOnlineStatus();
      }
    },
  );

  // Initial check
  _isOnline =
      (await Connectivity().checkConnectivity()) != ConnectivityResult.none;

  // Start periodic check
  _periodicCheckTimer = Timer.periodic(Duration(seconds: 30), (timer) {
    _checkAndUpdateOnlineStatus();
  });

  _isInitialized = true;
}

Future _checkAndUpdateOnlineStatus() async {
  if (_isOnline) {
    bool isConnectionGood = await _checkConnectionQuality();
    if (isConnectionGood) {
      await _updatePresenceStatus();
    } else {
      await _setOfflineStatus();
    }
  } else {
    await _setOfflineStatus();
  }
}

Future<bool> _checkConnectionQuality() async {
  try {
    final response = await http
        .get(Uri.parse('https://www.google.com'))
        .timeout(Duration(seconds: 5));
    return response.statusCode == 200;
  } catch (e) {
    print('Connection quality check failed: $e');
    return false;
  }
}

Future _updatePresenceStatus() async {
  if (_presenceChannel == null) return;

  try {
    final user = SupaFlow.client.auth.currentUser;
    if (user == null) return;

    final now = DateTime.now().toUtc();
    await _presenceChannel!.track({
      'user_id': user.id,
      'online_at': now.toIso8601String(),
    });

    await UsersTable().update(
      data: {
        'is_online': true,
        'last_seen': now.toIso8601String(),
      },
      matchingRows: (rows) => rows.eq(
        'auth_user_id',
        user.id,
      ),
    );
    print("Successfully updated user online status to true");
  } catch (e) {
    print('Failed to update user online status: $e');
  }
}

Future _setOfflineStatus() async {
  try {
    final user = SupaFlow.client.auth.currentUser;
    if (user == null) return;

    final now = DateTime.now().toUtc();
    await UsersTable().update(
      data: {
        'is_online': false,
        'last_seen': now.toIso8601String(),
      },
      matchingRows: (rows) => rows.eq(
        'auth_user_id',
        user.id,
      ),
    );
    print("Successfully updated user online status to false");
  } catch (e) {
    print('Failed to update user offline status: $e');
  }
}

Future disposeOnlineStatusTracker() async {
  await _presenceChannel?.untrack();
  await _presenceChannel?.unsubscribe();
  _presenceChannel = null;

  await _connectivitySubscription?.cancel();
  _connectivitySubscription = null;

  _lifecycleListener?.dispose();
  _lifecycleListener = null;

  _periodicCheckTimer?.cancel();
  _periodicCheckTimer = null;

  _isInitialized = false;
  await _setOfflineStatus();
}

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

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<String> syncOnlineOfflineDb() async {
  // Initialize the SQLiteManager to ensure the database is loaded
  await SQLiteManager.initialize();

  // Get the database instance
  final localDb = SQLiteManager.instance.database;

  // List of expected table names
  final expectedTables = [
    'attempts',
    'chats',
    'file_read',
    'messages',
    'ppir_forms',
    'regions',
    'seeds',
    'sync_log',
    'tasks',
    'user_logs',
    'users'
  ];

  // Get all table names from the local database
  final tables = await localDb.rawQuery(
    'SELECT name FROM sqlite_master WHERE type = ?',
    ['table'],
  );

  // Create a list to store the table names
  final tableNames = <String>[];

  // Loop through the tables and add the names to the list, excluding unwanted tables
  for (final table in tables) {
    final tableName = table['name'] as String;
    if (tableName != 'sqlite_sequence' && tableName != 'android_metadata') {
      tableNames.add(tableName);
    }
  }

  // Check for missing tables
  final missingTables =
      expectedTables.where((table) => !tableNames.contains(table)).toList();

  // Close the local database (if needed)
  // await localDb.close();

  // Return the table names and any missing tables as a string
  if (missingTables.isNotEmpty) {
    return 'Tables found: ${tableNames.join(', ')}. Missing tables: ${missingTables.join(', ')}.';
  } else {
    return 'All expected tables are present: ${tableNames.join(', ')}.';
  }
}

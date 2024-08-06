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

// Additional imports for SQLite
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<String> syncOnlineOfflineDb() async {
  // Get the path to the local database
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'offline_db.db');

  // Open the local database
  final localDb = await openDatabase(path);

  // Get all table names from the local database
  final tables = await localDb.rawQuery(
    'SELECT name FROM sqlite_master WHERE type = ?',
    ['table'],
  );

  // Create a list to store the table names
  final tableNames = <String>[];

  // Loop through the tables and add the names to the list
  for (final table in tables) {
    tableNames.add(table['name'] as String);
  }

  // Close the local database
  await localDb.close();

  // Return the table names as a string
  return tableNames.join(', ');
}

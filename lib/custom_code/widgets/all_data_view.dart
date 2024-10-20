// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class AllDataView extends StatefulWidget {
  const AllDataView({
    super.key,
    this.width,
    this.height,
    this.data,
  });

  final double? width;
  final double? height;
  final List<SELECTPPIRFormsByAssigneeAndTaskStatusRow>? data;

  @override
  State<AllDataView> createState() => _AllDataViewState();
}

class _AllDataViewState extends State<AllDataView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      child: Text('Hello'),
    );
  }
}

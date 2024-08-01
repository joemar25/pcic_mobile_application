import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'tasks_widget.dart' show TasksWidget;
import 'package:flutter/material.dart';

class TasksModel extends FlutterFlowModel<TasksWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Query Rows] action in tasks widget.
  List<PpirFormsRow>? onlinePpirData;
  // Stores action output result for [Backend Call - SQLite (SELECT PPIR FORMS)] action in tasks widget.
  List<SelectPpirFormsRow>? offlinePpirData;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

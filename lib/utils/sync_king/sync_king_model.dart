import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'sync_king_widget.dart' show SyncKingWidget;
import 'package:flutter/material.dart';

class SyncKingModel extends FlutterFlowModel<SyncKingWidget> {
  ///  Local state fields for this page.

  int? limit = 0;

  int? iteration = 0;

  bool isSync = false;

  bool startSync = false;

  bool isSynced = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<TasksRow>? onlineTasks;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<PpirFormsRow>? ppirOutput;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

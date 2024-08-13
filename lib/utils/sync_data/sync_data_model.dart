import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'sync_data_widget.dart' show SyncDataWidget;
import 'package:flutter/material.dart';

class SyncDataModel extends FlutterFlowModel<SyncDataWidget> {
  ///  Local state fields for this page.

  int? iteration = 0;

  int? limit = 0;

  bool isSync = false;

  bool startSync = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in Container widget.
  List<PpirFormsRow>? ppirOutput;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

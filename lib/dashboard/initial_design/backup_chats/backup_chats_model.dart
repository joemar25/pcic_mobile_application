import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import 'backup_chats_widget.dart' show BackupChatsWidget;
import 'package:flutter/material.dart';

class BackupChatsModel extends FlutterFlowModel<BackupChatsWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    connectivityModel.dispose();
  }
}

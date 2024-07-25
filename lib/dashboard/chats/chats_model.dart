import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import 'chats_widget.dart' show ChatsWidget;
import 'package:flutter/material.dart';

class ChatsModel extends FlutterFlowModel<ChatsWidget> {
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

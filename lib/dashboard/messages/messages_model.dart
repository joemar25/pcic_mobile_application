import '/components/connectivity_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'messages_widget.dart' show MessagesWidget;
import 'package:flutter/material.dart';

class MessagesModel extends FlutterFlowModel<MessagesWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

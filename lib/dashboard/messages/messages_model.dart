import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/chat/chat_widget.dart';
import 'messages_widget.dart' show MessagesWidget;
import 'package:flutter/material.dart';

class MessagesModel extends FlutterFlowModel<MessagesWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for chat component.
  late ChatModel chatModel;

  @override
  void initState(BuildContext context) {
    chatModel = createModel(context, () => ChatModel());
  }

  @override
  void dispose() {
    chatModel.dispose();
  }
}

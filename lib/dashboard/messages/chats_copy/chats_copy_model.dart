import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/chat_list_container/chat_list_container_widget.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import 'chats_copy_widget.dart' show ChatsCopyWidget;
import 'package:flutter/material.dart';

class ChatsCopyModel extends FlutterFlowModel<ChatsCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in chatsCopy widget.
  List<ChatsRow>? messageQuery;
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // Models for chatListContainer dynamic component.
  late FlutterFlowDynamicModels<ChatListContainerModel> chatListContainerModels;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
    chatListContainerModels =
        FlutterFlowDynamicModels(() => ChatListContainerModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
    chatListContainerModels.dispose();
  }
}

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/components/chat_list_container/chat_list_container_widget.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import '/utils/components/user_chats/user_chats_widget.dart';
import 'chats_widget.dart' show ChatsWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatsModel extends FlutterFlowModel<ChatsWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in chats widget.
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

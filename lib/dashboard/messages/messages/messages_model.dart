import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import 'messages_widget.dart' show MessagesWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MessagesModel extends FlutterFlowModel<MessagesWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - API (Update Last Seen and Read)] action in messages widget.
  ApiCallResponse? apiResultw5j;
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // State field(s) for inputChat widget.
  FocusNode? inputChatFocusNode;
  TextEditingController? inputChatTextController;
  String? Function(BuildContext, String?)? inputChatTextControllerValidator;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
    inputChatFocusNode?.dispose();
    inputChatTextController?.dispose();
  }
}

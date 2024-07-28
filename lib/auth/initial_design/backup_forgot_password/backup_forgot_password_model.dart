import '/flutter_flow/flutter_flow_util.dart';
import 'backup_forgot_password_widget.dart' show BackupForgotPasswordWidget;
import 'package:flutter/material.dart';

class BackupForgotPasswordModel
    extends FlutterFlowModel<BackupForgotPasswordWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();
  }
}

import '/flutter_flow/flutter_flow_util.dart';
import 'edit_password_widget.dart' show EditPasswordWidget;
import 'package:flutter/material.dart';

class EditPasswordModel extends FlutterFlowModel<EditPasswordWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey1 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  // State field(s) for old_password widget.
  FocusNode? oldPasswordFocusNode1;
  TextEditingController? oldPasswordTextController1;
  late bool oldPasswordVisibility1;
  String? Function(BuildContext, String?)? oldPasswordTextController1Validator;
  // State field(s) for new_password widget.
  FocusNode? newPasswordFocusNode1;
  TextEditingController? newPasswordTextController1;
  late bool newPasswordVisibility1;
  String? Function(BuildContext, String?)? newPasswordTextController1Validator;
  // State field(s) for confirm_new_password widget.
  FocusNode? confirmNewPasswordFocusNode1;
  TextEditingController? confirmNewPasswordTextController1;
  late bool confirmNewPasswordVisibility1;
  String? Function(BuildContext, String?)?
      confirmNewPasswordTextController1Validator;
  // State field(s) for old_password widget.
  FocusNode? oldPasswordFocusNode2;
  TextEditingController? oldPasswordTextController2;
  late bool oldPasswordVisibility2;
  String? Function(BuildContext, String?)? oldPasswordTextController2Validator;
  // State field(s) for new_password widget.
  FocusNode? newPasswordFocusNode2;
  TextEditingController? newPasswordTextController2;
  late bool newPasswordVisibility2;
  String? Function(BuildContext, String?)? newPasswordTextController2Validator;
  // State field(s) for confirm_new_password widget.
  FocusNode? confirmNewPasswordFocusNode2;
  TextEditingController? confirmNewPasswordTextController2;
  late bool confirmNewPasswordVisibility2;
  String? Function(BuildContext, String?)?
      confirmNewPasswordTextController2Validator;
  // State field(s) for old_password widget.
  FocusNode? oldPasswordFocusNode3;
  TextEditingController? oldPasswordTextController3;
  late bool oldPasswordVisibility3;
  String? Function(BuildContext, String?)? oldPasswordTextController3Validator;
  // State field(s) for new_password widget.
  FocusNode? newPasswordFocusNode3;
  TextEditingController? newPasswordTextController3;
  late bool newPasswordVisibility3;
  String? Function(BuildContext, String?)? newPasswordTextController3Validator;
  // State field(s) for confirm_new_password widget.
  FocusNode? confirmNewPasswordFocusNode3;
  TextEditingController? confirmNewPasswordTextController3;
  late bool confirmNewPasswordVisibility3;
  String? Function(BuildContext, String?)?
      confirmNewPasswordTextController3Validator;

  @override
  void initState(BuildContext context) {
    oldPasswordVisibility1 = false;
    newPasswordVisibility1 = false;
    confirmNewPasswordVisibility1 = false;
    oldPasswordVisibility2 = false;
    newPasswordVisibility2 = false;
    confirmNewPasswordVisibility2 = false;
    oldPasswordVisibility3 = false;
    newPasswordVisibility3 = false;
    confirmNewPasswordVisibility3 = false;
  }

  @override
  void dispose() {
    oldPasswordFocusNode1?.dispose();
    oldPasswordTextController1?.dispose();

    newPasswordFocusNode1?.dispose();
    newPasswordTextController1?.dispose();

    confirmNewPasswordFocusNode1?.dispose();
    confirmNewPasswordTextController1?.dispose();

    oldPasswordFocusNode2?.dispose();
    oldPasswordTextController2?.dispose();

    newPasswordFocusNode2?.dispose();
    newPasswordTextController2?.dispose();

    confirmNewPasswordFocusNode2?.dispose();
    confirmNewPasswordTextController2?.dispose();

    oldPasswordFocusNode3?.dispose();
    oldPasswordTextController3?.dispose();

    newPasswordFocusNode3?.dispose();
    newPasswordTextController3?.dispose();

    confirmNewPasswordFocusNode3?.dispose();
    confirmNewPasswordTextController3?.dispose();
  }
}

import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'email_us_widget.dart' show EmailUsWidget;
import 'package:flutter/material.dart';

class EmailUsModel extends FlutterFlowModel<EmailUsWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for purposeDropDown widget.
  String? purposeDropDownValue;
  FormFieldController<String>? purposeDropDownValueController;
  // State field(s) for inputMessage widget.
  FocusNode? inputMessageFocusNode;
  TextEditingController? inputMessageTextController;
  String? Function(BuildContext, String?)? inputMessageTextControllerValidator;
  String? _inputMessageTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'c2yh7kit' /* Field is required */,
      );
    }

    return null;
  }

  // Stores action output result for [Validate Form] action in submitButton widget.
  bool? isValidated;

  @override
  void initState(BuildContext context) {
    inputMessageTextControllerValidator = _inputMessageTextControllerValidator;
  }

  @override
  void dispose() {
    inputMessageFocusNode?.dispose();
    inputMessageTextController?.dispose();
  }
}

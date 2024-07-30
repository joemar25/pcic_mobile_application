import '/flutter_flow/flutter_flow_util.dart';
import 'signature_widget.dart' show SignatureWidget;
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignatureModel extends FlutterFlowModel<SignatureWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for signature_data widget.
  SignatureController? signatureDataController;
  // Stores action output result for [Custom Action - uploadSignatureToSupabase] action in saveButton widget.
  String? si;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    signatureDataController?.dispose();
  }
}

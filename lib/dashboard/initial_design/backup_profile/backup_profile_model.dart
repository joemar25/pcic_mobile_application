import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import 'backup_profile_widget.dart' show BackupProfileWidget;
import 'package:flutter/material.dart';

class BackupProfileModel extends FlutterFlowModel<BackupProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for connectivity component.
  late ConnectivityModel connectivityModel;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
  }
}

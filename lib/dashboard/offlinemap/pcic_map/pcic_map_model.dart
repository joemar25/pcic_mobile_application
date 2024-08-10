import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/no_internet_dialog/no_internet_dialog_widget.dart';
import 'pcic_map_widget.dart' show PcicMapWidget;
import 'package:flutter/material.dart';

class PcicMapModel extends FlutterFlowModel<PcicMapWidget> {
  ///  Local state fields for this page.

  bool isLoading = true;

  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for noInternetDialog component.
  late NoInternetDialogModel noInternetDialogModel;

  @override
  void initState(BuildContext context) {
    noInternetDialogModel = createModel(context, () => NoInternetDialogModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    noInternetDialogModel.dispose();
  }
}

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'page_loader_model.dart';
export 'page_loader_model.dart';

class PageLoaderWidget extends StatefulWidget {
  const PageLoaderWidget({super.key});

  @override
  State<PageLoaderWidget> createState() => _PageLoaderWidgetState();
}

class _PageLoaderWidgetState extends State<PageLoaderWidget> {
  late PageLoaderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageLoaderModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: 141.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset(
              'assets/images/pccc.gif',
            ).image,
          ),
        ),
      ),
    );
  }
}

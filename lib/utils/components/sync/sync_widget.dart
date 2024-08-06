import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'sync_model.dart';
export 'sync_model.dart';

class SyncWidget extends StatefulWidget {
  const SyncWidget({super.key});

  @override
  State<SyncWidget> createState() => _SyncWidgetState();
}

class _SyncWidgetState extends State<SyncWidget> with TickerProviderStateMixin {
  late SyncModel _model;

  var hasIconTriggered = false;
  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SyncModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.clicked = false;
      setState(() {});
    });

    animationsMap.addAll({
      'iconOnPageLoadAnimation': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        applyInitialState: false,
        effectsBuilder: () => [
          RotateEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 2000.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'iconOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: false,
        effectsBuilder: () => [
          RotateEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      animationsMap['iconOnPageLoadAnimation']!.controller.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        // Start of Sync
        _model.clicked = true;
        setState(() {});
        _model.aww = await actions.syncOnlineOfflineDb();
        // End of Sync
        _model.clicked = false;
        setState(() {});

        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOutQuint,
        width: 30.0,
        height: 30.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x33000000),
              offset: Offset(
                0.0,
                2.0,
              ),
            )
          ],
          shape: BoxShape.circle,
          border: Border.all(
            color: FFAppState().ONLINE
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).warning,
          ),
        ),
        child: Stack(
          children: [
            if (!_model.clicked)
              Align(
                alignment: const AlignmentDirectional(0.0, 0.0),
                child: Icon(
                  Icons.sync,
                  color: FFAppState().ONLINE
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).warning,
                  size: 24.0,
                ),
              ),
            if (_model.clicked)
              Align(
                alignment: const AlignmentDirectional(0.0, 0.0),
                child: Icon(
                  Icons.sync,
                  color: FlutterFlowTheme.of(context).warning,
                  size: 24.0,
                )
                    .animateOnPageLoad(
                        animationsMap['iconOnPageLoadAnimation']!)
                    .animateOnActionTrigger(
                        animationsMap['iconOnActionTriggerAnimation']!,
                        hasBeenTriggered: hasIconTriggered),
              ),
          ],
        ),
      ),
    );
  }
}

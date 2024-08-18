import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'offline_sync_model.dart';
export 'offline_sync_model.dart';

class OfflineSyncWidget extends StatefulWidget {
  const OfflineSyncWidget({super.key});

  @override
  State<OfflineSyncWidget> createState() => _OfflineSyncWidgetState();
}

class _OfflineSyncWidgetState extends State<OfflineSyncWidget>
    with TickerProviderStateMixin {
  late OfflineSyncModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OfflineSyncModel());

    animationsMap.addAll({
      'iconOnPageLoadAnimation': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          RotateEffect(
            curve: Curves.easeIn,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'textOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 150.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
          TiltEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0, 1.396),
            end: const Offset(0, 0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 40.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'columnOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOutQuint,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: const Color(0x80FFFFFF),
            angle: 0.524,
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
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
            child: Container(
              width: MediaQuery.sizeOf(context).width * 1.0,
              height: MediaQuery.sizeOf(context).height * 1.0,
              constraints: BoxConstraints(
                minWidth: MediaQuery.sizeOf(context).width * 1.0,
                minHeight: MediaQuery.sizeOf(context).height * 1.0,
                maxWidth: MediaQuery.sizeOf(context).width * 1.0,
                maxHeight: MediaQuery.sizeOf(context).height * 1.0,
              ),
              decoration: const BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      if (!_model.isSync) {
                        // Online Tasks
                        _model.onlineTasks = await TasksTable().queryRows(
                          queryFn: (q) => q,
                        );
                        // Number Iteration
                        _model.limit = valueOrDefault<int>(
                          _model.onlineTasks?.length,
                          0,
                        );
                        _model.iteration = 0;
                        _model.startSync = true;
                        _model.isSync = true;
                        _model.isSynced = false;
                        setState(() {});
                        while (_model.iteration! < _model.limit!) {
                          await Future.delayed(
                              const Duration(milliseconds: 2000));
                          // Online Tasks
                          _model.ppirOutput = await PpirFormsTable().queryRows(
                            queryFn: (q) => q.eq(
                              'task_id',
                              valueOrDefault<String>(
                                _model
                                    .onlineTasks?[valueOrDefault<int>(
                                  _model.iteration,
                                  0,
                                )]
                                    .id,
                                'id',
                              ),
                            ),
                          );
                          await SQLiteManager.instance.insertOfflineTask(
                            id: valueOrDefault<String>(
                              _model
                                  .onlineTasks?[valueOrDefault<int>(
                                _model.iteration,
                                0,
                              )]
                                  .id,
                              'id',
                            ),
                            taskNumber: valueOrDefault<String>(
                              _model
                                  .onlineTasks?[valueOrDefault<int>(
                                _model.iteration,
                                0,
                              )]
                                  .serviceGroup,
                              'task number',
                            ),
                            serviceGroup: valueOrDefault<String>(
                              _model
                                  .onlineTasks?[valueOrDefault<int>(
                                _model.iteration,
                                0,
                              )]
                                  .serviceGroup,
                              'task number',
                            ),
                            status: valueOrDefault<String>(
                              _model
                                  .onlineTasks?[valueOrDefault<int>(
                                _model.iteration,
                                0,
                              )]
                                  .status,
                              'task number',
                            ),
                            serviceType: valueOrDefault<String>(
                              _model
                                  .onlineTasks?[valueOrDefault<int>(
                                _model.iteration,
                                0,
                              )]
                                  .serviceType,
                              'task number',
                            ),
                            priority: valueOrDefault<String>(
                              _model
                                  .onlineTasks?[valueOrDefault<int>(
                                _model.iteration,
                                0,
                              )]
                                  .priority,
                              'task number',
                            ),
                            assignee: valueOrDefault<String>(
                              _model
                                  .onlineTasks?[valueOrDefault<int>(
                                _model.iteration,
                                0,
                              )]
                                  .assignee,
                              'task number',
                            ),
                            dateAdded: valueOrDefault<String>(
                              _model
                                  .onlineTasks?[valueOrDefault<int>(
                                _model.iteration,
                                0,
                              )]
                                  .dateAdded
                                  ?.toString(),
                              'task number',
                            ),
                            dateAccess: valueOrDefault<String>(
                              _model
                                  .onlineTasks?[valueOrDefault<int>(
                                _model.iteration,
                                0,
                              )]
                                  .dateAccess
                                  ?.toString(),
                              'task number',
                            ),
                            fileId: valueOrDefault<String>(
                              _model
                                  .onlineTasks?[valueOrDefault<int>(
                                _model.iteration,
                                0,
                              )]
                                  .fileId,
                              'task number',
                            ),
                          );
                          await SQLiteManager.instance.insertOfflinePPIRForm(
                            taskId: _model.onlineTasks?[_model.iteration!].id,
                            ppirAssignmentId:
                                _model.ppirOutput?.first.ppirAssignmentid,
                            gpx: _model.ppirOutput?.first.gpx,
                            ppirInsuranceId:
                                _model.ppirOutput?.first.ppirInsuranceid,
                            ppirFarmerName:
                                _model.ppirOutput?.first.ppirFarmername,
                            ppirAddress: _model.ppirOutput?.first.ppirAddress,
                            ppirFarmerType:
                                _model.ppirOutput?.first.ppirFarmertype,
                            ppirMobileNo:
                                _model.ppirOutput?.first.ppirMobileno,
                            ppirGroupName:
                                _model.ppirOutput?.first.ppirGroupname,
                            ppirGroupAddress:
                                _model.ppirOutput?.first.ppirGroupaddress,
                            ppirLenderName:
                                _model.ppirOutput?.first.ppirLendername,
                            ppirLenderAddress:
                                _model.ppirOutput?.first.ppirLenderaddress,
                            ppirCICNo: _model.ppirOutput?.first.ppirCicno,
                            ppirFarmLoc: _model.ppirOutput?.first.ppirFarmloc,
                            ppirNorth: _model.ppirOutput?.first.ppirNorth,
                            ppirSouth: _model.ppirOutput?.first.ppirSouth,
                            ppirEast: _model.ppirOutput?.first.ppirEast,
                            ppirWest: _model.ppirOutput?.first.ppirWest,
                            ppirAtt1: _model.ppirOutput?.first.ppirAtt1,
                            ppirAtt2: _model.ppirOutput?.first.ppirAtt2,
                            ppirAtt3: _model.ppirOutput?.first.ppirAtt3,
                            ppirAtt4: _model.ppirOutput?.first.ppirAtt4,
                            ppirAreaAci: _model.ppirOutput?.first.ppirAreaAci,
                            ppirAreaAct: _model.ppirOutput?.first.ppirAreaAct,
                            ppirDopdsAci:
                                _model.ppirOutput?.first.ppirDopdsAci,
                            ppirDopdsAct:
                                _model.ppirOutput?.first.ppirDopdsAct,
                            ppirDoptpAci:
                                _model.ppirOutput?.first.ppirDoptpAci,
                            ppirDoptpAct:
                                _model.ppirOutput?.first.ppirDoptpAct,
                            ppirSvpAci: _model.ppirOutput?.first.ppirSvpAci,
                            ppirSvpAct: _model.ppirOutput?.first.ppirSvpAct,
                            ppirVariety: _model.ppirOutput?.first.ppirVariety,
                            ppirStageCrop:
                                _model.ppirOutput?.first.ppirStagecrop,
                            ppirRemarks: _model.ppirOutput?.first.ppirRemarks,
                            ppirNameInsured:
                                _model.ppirOutput?.first.ppirNameInsured,
                            ppirNameIUIA:
                                _model.ppirOutput?.first.ppirNameIuia,
                            ppirSigInsured:
                                _model.ppirOutput?.first.ppirSigInsured,
                            ppirSigIUIA: _model.ppirOutput?.first.ppirSigIuia,
                            trackLastCoord:
                                _model.ppirOutput?.first.trackLastCoord,
                            trackDateTime:
                                _model.ppirOutput?.first.trackDateTime,
                            trackTotalArea:
                                _model.ppirOutput?.first.trackTotalArea,
                            trackTotalDistance:
                                _model.ppirOutput?.first.trackTotalDistance,
                            createdAt:
                                _model.ppirOutput?.first.createdAt?.toString(),
                            updatedAt:
                                _model.ppirOutput?.first.updatedAt?.toString(),
                            syncStatus: _model.ppirOutput?.first.syncStatus,
                            lastSyncedAt: _model.ppirOutput?.first.lastSyncedAt
                                ?.toString(),
                            localId: _model.ppirOutput?.first.localId,
                            isDirty:
                                _model.ppirOutput?.first.isDirty?.toString(),
                          );
                          // Number Iteration
                          _model.iteration = _model.iteration! + 1;
                          setState(() {});
                        }
                        _model.isSync = false;
                        _model.startSync = false;
                        _model.isSynced = true;
                        setState(() {});
                      }

                      setState(() {});
                    },
                    child: Container(
                      width: 300.0,
                      decoration: const BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              if (!_model.isSync)
                                FaIcon(
                                  FontAwesomeIcons.sync,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 200.0,
                                ),
                              if (_model.isSync)
                                FaIcon(
                                  FontAwesomeIcons.sync,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 200.0,
                                ).animateOnPageLoad(
                                    animationsMap['iconOnPageLoadAnimation']!),
                            ],
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.0, -1.0),
                            child: AnimatedDefaultTextStyle(
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .labelMediumFamily),
                                  ),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeIn,
                              child: Text(
                                () {
                                  if ((_model.isSync == true) &&
                                      (_model.isSynced == false)) {
                                    return 'Syncing';
                                  } else if ((_model.isSync == false) &&
                                      (_model.isSynced == true)) {
                                    return 'Tap again to sync';
                                  } else {
                                    return 'Tap to sync';
                                  }
                                }(),
                                textAlign: TextAlign.center,
                              ),
                            ).animateOnPageLoad(
                                animationsMap['textOnPageLoadAnimation']!),
                          ),
                        ]
                            .divide(const SizedBox(height: 20.0))
                            .around(const SizedBox(height: 20.0)),
                      ),
                    ),
                  ),
                  if (_model.isSynced)
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total number of tasks synced ${valueOrDefault<String>(
                            _model.iteration?.toString(),
                            '0',
                          )}',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                        FFButtonWidget(
                          onPressed: () async {
                            context.pushNamed(
                              'dashboard',
                              extra: <String, dynamic>{
                                kTransitionInfoKey: const TransitionInfo(
                                  hasTransition: true,
                                  transitionType: PageTransitionType.scale,
                                  alignment: Alignment.bottomCenter,
                                  duration: Duration(milliseconds: 300),
                                ),
                              },
                            );
                          },
                          text: FFLocalizations.of(context).getText(
                            'nzwziy9t' /* Proceed */,
                          ),
                          icon: const Icon(
                            Icons.dashboard,
                            size: 15.0,
                          ),
                          options: FFButtonOptions(
                            width: 200.0,
                            height: 40.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleSmallFamily,
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .titleSmallFamily),
                                ),
                            elevation: 3.0,
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ).animateOnActionTrigger(
                          animationsMap['buttonOnActionTriggerAnimation']!,
                        ),
                      ]
                          .divide(const SizedBox(height: 10.0))
                          .around(const SizedBox(height: 10.0)),
                    ).animateOnActionTrigger(
                      animationsMap['columnOnActionTriggerAnimation']!,
                    ),
                ].divide(const SizedBox(height: 10.0)).around(const SizedBox(height: 10.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

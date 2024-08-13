import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/components/page_loader/page_loader_widget.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'sync_data_model.dart';
export 'sync_data_model.dart';

class SyncDataWidget extends StatefulWidget {
  const SyncDataWidget({super.key});

  @override
  State<SyncDataWidget> createState() => _SyncDataWidgetState();
}

class _SyncDataWidgetState extends State<SyncDataWidget>
    with TickerProviderStateMixin {
  late SyncDataModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SyncDataModel());

    animationsMap.addAll({
      'iconOnPageLoadAnimation': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
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
      'textOnPageLoadAnimation1': AnimationInfo(
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
            begin: Offset(0.8, 0.8),
            end: Offset(1.0, 1.0),
          ),
          TiltEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 300.0.ms,
            begin: Offset(0, 1.396),
            end: Offset(0, 0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, 40.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 100.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.8, 0.8),
            end: Offset(1.0, 1.0),
          ),
          TiltEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 300.0.ms,
            begin: Offset(0, 1.396),
            end: Offset(0, 0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, 40.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation3': AnimationInfo(
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
            begin: Offset(0.8, 0.8),
            end: Offset(1.0, 1.0),
          ),
          TiltEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 300.0.ms,
            begin: Offset(0, 1.396),
            end: Offset(0, 0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, 40.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation4': AnimationInfo(
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
            begin: Offset(0.8, 0.8),
            end: Offset(1.0, 1.0),
          ),
          TiltEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 300.0.ms,
            begin: Offset(0, 1.396),
            end: Offset(0, 0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, 40.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TasksRow>>(
      future: TasksTable().queryRows(
        queryFn: (q) => q,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: PageLoaderWidget(),
          );
        }
        List<TasksRow> syncDataTasksRowList = snapshot.data!;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              body: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        if (!_model.isSync)
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              _model.iteration = 0;
                              _model.limit = valueOrDefault<int>(
                                syncDataTasksRowList.length,
                                0,
                              );
                              _model.isSync = true;
                              _model.startSync = true;
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Sync Started',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 4000),
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).secondary,
                                ),
                              );
                              while (_model.iteration! < _model.limit!) {
                                // Online Tasks
                                _model.ppirOutput =
                                    await PpirFormsTable().queryRows(
                                  queryFn: (q) => q.eq(
                                    'task_id',
                                    syncDataTasksRowList[_model.iteration!].id,
                                  ),
                                );
                                await SQLiteManager.instance.insertOfflineTask(
                                  id: syncDataTasksRowList[_model.iteration!]
                                      .id,
                                  taskNumber:
                                      syncDataTasksRowList[_model.iteration!]
                                          .taskNumber,
                                  serviceGroup:
                                      syncDataTasksRowList[_model.iteration!]
                                          .serviceGroup,
                                  status:
                                      syncDataTasksRowList[_model.iteration!]
                                          .status,
                                  serviceType:
                                      syncDataTasksRowList[_model.iteration!]
                                          .serviceType,
                                  priority:
                                      syncDataTasksRowList[_model.iteration!]
                                          .priority,
                                  assignee:
                                      syncDataTasksRowList[_model.iteration!]
                                          .assignee,
                                  dateAdded:
                                      syncDataTasksRowList[_model.iteration!]
                                          .dateAdded
                                          ?.toString(),
                                  dateAccess:
                                      syncDataTasksRowList[_model.iteration!]
                                          .dateAccess
                                          ?.toString(),
                                  fileId:
                                      syncDataTasksRowList[_model.iteration!]
                                          .fileId,
                                );
                                await SQLiteManager.instance
                                    .insertOfflinePPIRForm(
                                  taskId: _model.ppirOutput?.first?.taskId,
                                  ppirAssignmentId: _model
                                      .ppirOutput?.first?.ppirAssignmentid,
                                  gpx: _model.ppirOutput?.first?.gpx,
                                  ppirInsuranceId:
                                      _model.ppirOutput?.first?.ppirInsuranceid,
                                  ppirFarmerName:
                                      _model.ppirOutput?.first?.ppirFarmername,
                                  ppirAddress:
                                      _model.ppirOutput?.first?.ppirAddress,
                                  ppirFarmerType:
                                      _model.ppirOutput?.first?.ppirFarmertype,
                                  ppirMobileNo:
                                      _model.ppirOutput?.first?.ppirMobileno,
                                  ppirGroupName:
                                      _model.ppirOutput?.first?.ppirGroupname,
                                  ppirGroupAddress: _model
                                      .ppirOutput?.first?.ppirGroupaddress,
                                  ppirLenderName:
                                      _model.ppirOutput?.first?.ppirLendername,
                                  ppirLenderAddress:
                                      _model.ppirOutput?.first?.ppirLendername,
                                  ppirCICNo:
                                      _model.ppirOutput?.first?.ppirCicno,
                                  ppirFarmLoc:
                                      _model.ppirOutput?.first?.ppirFarmloc,
                                  ppirNorth:
                                      _model.ppirOutput?.first?.ppirNorth,
                                  ppirSouth:
                                      _model.ppirOutput?.first?.ppirSouth,
                                  ppirEast: _model.ppirOutput?.first?.ppirEast,
                                  ppirWest: _model.ppirOutput?.first?.ppirWest,
                                  ppirAtt1: _model.ppirOutput?.first?.ppirAtt1,
                                  ppirAtt2: _model.ppirOutput?.first?.ppirAtt2,
                                  ppirAtt3: _model.ppirOutput?.first?.ppirAtt3,
                                  ppirAtt4: _model.ppirOutput?.first?.ppirAtt4,
                                  ppirAreaAci:
                                      _model.ppirOutput?.first?.ppirAreaAci,
                                  ppirAreaAct:
                                      _model.ppirOutput?.first?.ppirAreaAct,
                                  ppirDopdsAci:
                                      _model.ppirOutput?.first?.ppirDoptpAci,
                                  ppirDopdsAct:
                                      _model.ppirOutput?.first?.ppirDopdsAct,
                                  ppirDoptpAci:
                                      _model.ppirOutput?.first?.ppirDoptpAci,
                                  ppirDoptpAct:
                                      _model.ppirOutput?.first?.ppirDoptpAct,
                                  ppirSvpAci:
                                      _model.ppirOutput?.first?.ppirSvpAci,
                                  ppirSvpAct:
                                      _model.ppirOutput?.first?.ppirSvpAct,
                                  ppirVariety:
                                      _model.ppirOutput?.first?.ppirVariety,
                                  ppirStageCrop:
                                      _model.ppirOutput?.first?.ppirStagecrop,
                                  ppirRemarks:
                                      _model.ppirOutput?.first?.ppirRemarks,
                                  ppirNameInsured:
                                      _model.ppirOutput?.first?.ppirNameInsured,
                                  ppirNameIUIA:
                                      _model.ppirOutput?.first?.ppirSigIuia,
                                  ppirSigInsured:
                                      _model.ppirOutput?.first?.ppirSigInsured,
                                  ppirSigIUIA:
                                      _model.ppirOutput?.first?.ppirSigIuia,
                                  trackLastCoord:
                                      _model.ppirOutput?.first?.trackLastCoord,
                                  trackDateTime:
                                      _model.ppirOutput?.first?.trackDateTime,
                                  trackTotalArea:
                                      _model.ppirOutput?.first?.trackTotalArea,
                                  trackTotalDistance: _model
                                      .ppirOutput?.first?.trackTotalDistance,
                                  createdAt: _model.ppirOutput?.first?.createdAt
                                      ?.toString(),
                                  updatedAt: _model.ppirOutput?.first?.updatedAt
                                      ?.toString(),
                                  syncStatus:
                                      _model.ppirOutput?.first?.syncStatus,
                                  lastSyncedAt: _model
                                      .ppirOutput?.first?.lastSyncedAt
                                      ?.toString(),
                                  localId: _model.ppirOutput?.first?.localId,
                                  isDirty: _model.ppirOutput?.first?.isDirty
                                      ?.toString(),
                                );
                                // Number Iteration
                                _model.iteration = _model.iteration! + 1;
                                setState(() {});
                              }
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Successfully sync!',
                                    style: GoogleFonts.getFont(
                                      'Roboto',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 4000),
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).secondary,
                                ),
                              );
                              _model.iteration = 0;
                              _model.limit = 0;
                              _model.isSync = false;
                              setState(() {});

                              setState(() {});
                            },
                            child: FaIcon(
                              FontAwesomeIcons.sync,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 200.0,
                            ),
                          ),
                        if (_model.isSync)
                          FaIcon(
                            FontAwesomeIcons.sync,
                            color: FlutterFlowTheme.of(context).secondary,
                            size: 200.0,
                          ).animateOnPageLoad(
                              animationsMap['iconOnPageLoadAnimation']!),
                      ],
                    ),
                    if (!_model.isSync)
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: Text(
                              FFLocalizations.of(context).getText(
                                '2suywt94' /* Tap to Sync */,
                              ),
                              textAlign: TextAlign.center,
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
                            ).animateOnPageLoad(
                                animationsMap['textOnPageLoadAnimation1']!),
                          ),
                        ],
                      ),
                    if (_model.startSync)
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: Text(
                              !_model.isSync ? 'Sync Done' : 'Syncing',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .displaySmallFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .displaySmallFamily),
                                  ),
                            ).animateOnPageLoad(
                                animationsMap['textOnPageLoadAnimation2']!),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: Text(
                              !_model.isSync
                                  ? 'Please click the button to continue.'
                                  : 'Please wait...',
                              textAlign: TextAlign.center,
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
                            ).animateOnPageLoad(
                                animationsMap['textOnPageLoadAnimation3']!),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: Text(
                              'i=${valueOrDefault<String>(
                                _model.iteration?.toString(),
                                '0',
                              )}; n=${valueOrDefault<String>(
                                _model.limit?.toString(),
                                '0',
                              )};',
                              textAlign: TextAlign.center,
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
                            ).animateOnPageLoad(
                                animationsMap['textOnPageLoadAnimation4']!),
                          ),
                          if (!_model.isSync)
                            FFButtonWidget(
                              onPressed: () async {
                                context.pushNamed(
                                  'dashboard',
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType:
                                          PageTransitionType.bottomToTop,
                                      duration: Duration(milliseconds: 200),
                                    ),
                                  },
                                );
                              },
                              text: FFLocalizations.of(context).getText(
                                'mh2af94v' /* Dashboard */,
                              ),
                              icon: Icon(
                                Icons.dashboard,
                                size: 15.0,
                              ),
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).success,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleSmallFamily,
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .titleSmallFamily),
                                    ),
                                elevation: 3.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                        ]
                            .divide(SizedBox(height: 10.0))
                            .around(SizedBox(height: 10.0)),
                      ),
                  ]
                      .divide(SizedBox(height: 10.0))
                      .around(SizedBox(height: 10.0)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

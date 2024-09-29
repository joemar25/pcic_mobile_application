import '/auth/supabase_auth/auth_util.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:async';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'continue_submit_dialog_model.dart';
export 'continue_submit_dialog_model.dart';

class ContinueSubmitDialogWidget extends StatefulWidget {
  const ContinueSubmitDialogWidget({
    super.key,
    this.taskId,
    this.ppirSvpAct,
    this.ppirDopdsAct,
    this.ppirDoptpAct,
    this.ppirRemarks,
    this.ppirNameInsured,
    this.ppirNameIuia,
    this.ppirFarmloc,
    this.ppirAreaAct,
    this.ppirVariety,
    this.isDirty,
    this.capturedArea,
    this.riceDropdown,
    this.cordDropDown,
    this.gpx,
    this.ppirSigInsured,
    this.ppirSigIuia,
    this.trackLastCoord,
    this.trackDateTime,
    this.trackTotalArea,
    this.trackTotalDistance,
    this.generatedXMLFile,
    this.isFtpSaved,
  });

  final String? taskId;
  final String? ppirSvpAct;
  final String? ppirDopdsAct;
  final String? ppirDoptpAct;
  final String? ppirRemarks;
  final String? ppirNameInsured;
  final String? ppirNameIuia;
  final String? ppirFarmloc;
  final String? ppirAreaAct;
  final String? ppirVariety;
  final bool? isDirty;
  final String? capturedArea;
  final String? riceDropdown;
  final String? cordDropDown;
  final String? gpx;
  final String? ppirSigInsured;
  final String? ppirSigIuia;
  final String? trackLastCoord;
  final String? trackDateTime;
  final String? trackTotalArea;
  final String? trackTotalDistance;
  final String? generatedXMLFile;
  final bool? isFtpSaved;

  @override
  State<ContinueSubmitDialogWidget> createState() =>
      _ContinueSubmitDialogWidgetState();
}

class _ContinueSubmitDialogWidgetState
    extends State<ContinueSubmitDialogWidget> {
  late ContinueSubmitDialogModel _model;

  LatLng? currentUserLocationValue;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ContinueSubmitDialogModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: FutureBuilder<List<SelectPpirFormsRow>>(
        future: SQLiteManager.instance.selectPpirForms(
          taskId: widget.taskId,
        ),
        builder: (context, snapshot) {
          // Customize what your widget looks like when it's loading.
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                width: 100.0,
                height: 100.0,
                child: SpinKitRipple(
                  color: FlutterFlowTheme.of(context).primary,
                  size: 100.0,
                ),
              ),
            );
          }
          final containerSelectPpirFormsRowList = snapshot.data!;

          return Container(
            width: 338.0,
            height: 392.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Lottie.asset(
                    'assets/lottie_animations/confirmSubmit.json',
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.contain,
                    frameRate: FrameRate(120.0),
                    animate: true,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                  child: Text(
                                    FFLocalizations.of(context).getText(
                                      '2gqa0lrn' /* Task Saved */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .headlineLarge
                                        .override(
                                          fontFamily: 'Inter',
                                          fontSize: 30.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'x6p50a5s' /* Do you want to Submit all the ... */,
                                ),
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ].divide(const SizedBox(height: 15.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () async {
                            context.pushNamed('dashboard');
                          },
                          text: FFLocalizations.of(context).getText(
                            '30viluzv' /* Cancel */,
                          ),
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                            elevation: 0.0,
                            borderSide: const BorderSide(
                              width: 0.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      if (FFAppState().ONLINE)
                        FFButtonWidget(
                          onPressed: !FFAppState().ONLINE
                              ? null
                              : () async {
                                  currentUserLocationValue =
                                      await getCurrentUserLocation(
                                          defaultLocation: const LatLng(0.0, 0.0));
                                  await SQLiteManager.instance.updatePPIRForm(
                                    taskId: widget.taskId,
                                    ppirSvpAct: widget.ppirSvpAct,
                                    ppirDopdsAct: widget.ppirDopdsAct,
                                    ppirDoptpAct: widget.ppirDoptpAct,
                                    ppirRemarks: widget.ppirRemarks,
                                    ppirNameInsured: widget.ppirNameInsured,
                                    ppirNameIuia: widget.ppirNameIuia,
                                    ppirFarmloc: widget.ppirFarmloc,
                                    ppirAreaAct: widget.ppirAreaAct,
                                    ppirVariety: widget.ppirVariety == 'rice'
                                        ? widget.riceDropdown
                                        : widget.cordDropDown,
                                    isDirty: false,
                                    capturedArea: widget.capturedArea,
                                  );
                                  await PpirFormsTable().update(
                                    data: {
                                      'ppir_svp_act': widget.ppirSvpAct,
                                      'ppir_dopds_act': widget.ppirDopdsAct,
                                      'ppir_doptp_act': widget.ppirDoptpAct,
                                      'ppir_remarks': widget.ppirRemarks,
                                      'ppir_name_insured':
                                          widget.ppirNameInsured,
                                      'ppir_name_iuia': widget.ppirNameIuia,
                                      'ppir_farmloc': widget.ppirFarmloc,
                                      'ppir_area_act': widget.ppirAreaAct,
                                      'ppir_variety':
                                          widget.ppirVariety == 'rice'
                                              ? widget.riceDropdown
                                              : widget.cordDropDown,
                                      'gpx': widget.gpx,
                                      'ppir_sig_iuia': widget.ppirSigIuia,
                                      'ppir_sig_insured':
                                          widget.ppirSigInsured,
                                      'track_last_coord':
                                          widget.trackLastCoord,
                                      'track_date_time': widget.trackDateTime,
                                      'track_total_area':
                                          widget.trackTotalArea,
                                      'track_total_distance':
                                          widget.trackTotalDistance,
                                      'captured_area': widget.capturedArea,
                                    },
                                    matchingRows: (rows) => rows.eq(
                                      'task_id',
                                      widget.taskId,
                                    ),
                                  );
                                  await TasksTable().update(
                                    data: {
                                      'status': 'completed',
                                    },
                                    matchingRows: (rows) => rows.eq(
                                      'id',
                                      '',
                                    ),
                                  );
                                  await SQLiteManager.instance.updateTaskStatus(
                                    taskId: widget.taskId,
                                    status: 'completed',
                                    isDirty: false,
                                  );
                                  unawaited(
                                    () async {
                                      await actions.saveBlobToBucket(
                                        widget.taskId,
                                      );
                                    }(),
                                  );
                                  _model.generatedXML =
                                      await actions.generateTaskXml(
                                    widget.taskId,
                                  );
                                  await actions.saveTaskXml(
                                    widget.generatedXMLFile,
                                    widget.taskId,
                                  );
                                  _model.isFtpSaved = await actions.saveToFTP(
                                    widget.taskId,
                                  );
                                  unawaited(
                                    () async {
                                      await UserLogsTable().insert({
                                        'user_id': currentUserUid,
                                        'activity': 'Submitted a Task',
                                        'longlat':
                                            '${functions.getLng(currentUserLocationValue).toString()}, ${functions.getLat(currentUserLocationValue).toString()}',
                                        'task_id': widget.taskId,
                                      });
                                    }(),
                                  );
                                  if (widget.isFtpSaved!) {
                                    context.goNamed(
                                      'formSuccess',
                                      queryParameters: {
                                        'taskId': serializeParam(
                                          widget.taskId,
                                          ParamType.String,
                                        ),
                                        'type': serializeParam(
                                          'Saved',
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                      extra: <String, dynamic>{
                                        kTransitionInfoKey: const TransitionInfo(
                                          hasTransition: true,
                                          transitionType:
                                              PageTransitionType.scale,
                                          alignment: Alignment.bottomCenter,
                                          duration: Duration(milliseconds: 200),
                                        ),
                                      },
                                    );
                                  } else {
                                    context.pushNamed(
                                      'fail',
                                      queryParameters: {
                                        'error': serializeParam(
                                          'Failed to submit FTP!',
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                      extra: <String, dynamic>{
                                        kTransitionInfoKey: const TransitionInfo(
                                          hasTransition: true,
                                          transitionType:
                                              PageTransitionType.scale,
                                          alignment: Alignment.bottomCenter,
                                          duration:
                                              Duration(milliseconds: 3000),
                                        ),
                                      },
                                    );
                                  }

                                  safeSetState(() {});
                                },
                          text: FFLocalizations.of(context).getText(
                            'i4fw1nx7' /* Submit */,
                          ),
                          icon: const Icon(
                            Icons.check_sharp,
                            size: 15.0,
                          ),
                          options: FFButtonOptions(
                            width: 120.0,
                            height: 40.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                ),
                            elevation: 3.0,
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                            disabledColor: FlutterFlowTheme.of(context).error,
                            disabledTextColor:
                                FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                    ].divide(const SizedBox(width: 15.0)),
                  ),
                ].divide(const SizedBox(height: 20.0)),
              ),
            ),
          );
        },
      ),
    );
  }
}

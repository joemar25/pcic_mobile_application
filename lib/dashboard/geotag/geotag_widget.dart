import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'geotag_model.dart';
export 'geotag_model.dart';

class GeotagWidget extends StatefulWidget {
  const GeotagWidget({
    super.key,
    required this.taskId,
  });

  final String? taskId;

  @override
  State<GeotagWidget> createState() => _GeotagWidgetState();
}

class _GeotagWidgetState extends State<GeotagWidget> {
  late GeotagModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GeotagModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.isGeotagStart = false;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PpirFormsRow>>(
      future: PpirFormsTable().querySingleRow(
        queryFn: (q) => q.eq(
          'task_id',
          widget.taskId,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: Center(
              child: SizedBox(
                width: 100.0,
                height: 100.0,
                child: SpinKitRipple(
                  color: FlutterFlowTheme.of(context).primary,
                  size: 100.0,
                ),
              ),
            ),
          );
        }
        List<PpirFormsRow> geotagPpirFormsRowList = snapshot.data!;

        final geotagPpirFormsRow = geotagPpirFormsRowList.isNotEmpty
            ? geotagPpirFormsRowList.first
            : null;
        return GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              body: FutureBuilder<List<TasksRow>>(
                future: TasksTable().querySingleRow(
                  queryFn: (q) => q.eq(
                    'id',
                    widget.taskId,
                  ),
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
                  List<TasksRow> stackTasksRowList = snapshot.data!;

                  final stackTasksRow = stackTasksRowList.isNotEmpty
                      ? stackTasksRowList.first
                      : null;
                  return SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      alignment: const AlignmentDirectional(0.0, -1.0),
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0.0, -1.0),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1524661135-423995f22d0b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMXx8Z29vZ2xlJTIwbWFwc3xlbnwwfHx8fDE3MTg2OTQ1MDV8MA&ixlib=rb-4.0.3&q=80&w=1080',
                            width: double.infinity,
                            height: 876.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0.0, -0.92),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: Color(0x520E151B),
                                        offset: Offset(
                                          0.0,
                                          2.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 8.0,
                                    borderWidth: 1.0,
                                    buttonSize: 40.0,
                                    fillColor:
                                        FlutterFlowTheme.of(context).primary,
                                    icon: const Icon(
                                      Icons.chevron_left,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                    onPressed: () async {
                                      context.pushNamed(
                                        'task_details',
                                        queryParameters: {
                                          'taskId': serializeParam(
                                            stackTasksRow?.id,
                                            ParamType.String,
                                          ),
                                          'isCompleted': serializeParam(
                                            true,
                                            ParamType.bool,
                                          ),
                                        }.withoutNulls,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 100.0, 0.0, 0.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 800.0, 0.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 300.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 4.0,
                                            color: Color(0x320E151B),
                                            offset: Offset(
                                              0.0,
                                              -2.0,
                                            ),
                                          )
                                        ],
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(0.0),
                                          bottomRight: Radius.circular(0.0),
                                          topLeft: Radius.circular(16.0),
                                          topRight: Radius.circular(16.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 20.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          context.pushNamed(
                                                            'mapTesting',
                                                            extra: <String,
                                                                dynamic>{
                                                              kTransitionInfoKey:
                                                                  const TransitionInfo(
                                                                hasTransition:
                                                                    true,
                                                                transitionType:
                                                                    PageTransitionType
                                                                        .scale,
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        200),
                                                              ),
                                                            },
                                                          );
                                                        },
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            geotagPpirFormsRow
                                                                ?.ppirAssignmentid,
                                                            'Assignment Id',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .headlineSmall
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 20.0,
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    4.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            stackTasksRow
                                                                ?.taskType,
                                                            'Task Type',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .labelMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Raleway',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    decoration: const BoxDecoration(),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  2.0),
                                                          child: FFButtonWidget(
                                                            onPressed:
                                                                (_model.isGeotagStart ==
                                                                        true)
                                                                    ? null
                                                                    : () async {
                                                                        _model.isGeotagStart =
                                                                            true;
                                                                        setState(
                                                                            () {});
                                                                        if (stackTasksRow?.status ==
                                                                            'for dispatch') {
                                                                          await TasksTable()
                                                                              .update(
                                                                            data: {
                                                                              'status': 'ongoing',
                                                                            },
                                                                            matchingRows: (rows) =>
                                                                                rows.eq(
                                                                              'id',
                                                                              widget.taskId,
                                                                            ),
                                                                          );
                                                                        }
                                                                        await UserLogsTable()
                                                                            .insert({
                                                                          'user_id':
                                                                              currentUserUid,
                                                                          'activity':
                                                                              'Starting to geotag.',
                                                                        });
                                                                      },
                                                            text: FFLocalizations
                                                                    .of(context)
                                                                .getText(
                                                              'pkpqltl8' /* Start */,
                                                            ),
                                                            options:
                                                                FFButtonOptions(
                                                              width: 100.0,
                                                              height: 40.0,
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              iconPadding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              textStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        fontFamily:
                                                                            'Raleway',
                                                                        color: Colors
                                                                            .white,
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                              elevation: 2.0,
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  2.0),
                                                          child: FFButtonWidget(
                                                            onPressed:
                                                                (_model.isGeotagStart ==
                                                                        false)
                                                                    ? null
                                                                    : () async {
                                                                        _model.isGeotagStart =
                                                                            true;
                                                                        setState(
                                                                            () {});
                                                                        await UserLogsTable()
                                                                            .insert({
                                                                          'user_id':
                                                                              currentUserUid,
                                                                          'activity':
                                                                              'Geotagging stopped.',
                                                                        });

                                                                        context
                                                                            .pushNamed(
                                                                          'ppir',
                                                                          queryParameters:
                                                                              {
                                                                            'taskId':
                                                                                serializeParam(
                                                                              widget.taskId,
                                                                              ParamType.String,
                                                                            ),
                                                                          }.withoutNulls,
                                                                          extra: <String,
                                                                              dynamic>{
                                                                            kTransitionInfoKey:
                                                                                const TransitionInfo(
                                                                              hasTransition: true,
                                                                              transitionType: PageTransitionType.bottomToTop,
                                                                              duration: Duration(milliseconds: 200),
                                                                            ),
                                                                          },
                                                                        );
                                                                      },
                                                            text: FFLocalizations
                                                                    .of(context)
                                                                .getText(
                                                              'nu29o86l' /* Stop */,
                                                            ),
                                                            options:
                                                                FFButtonOptions(
                                                              width: 100.0,
                                                              height: 40.0,
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              iconPadding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              textStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        fontFamily:
                                                                            'Raleway',
                                                                        color: Colors
                                                                            .white,
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                              elevation: 2.0,
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

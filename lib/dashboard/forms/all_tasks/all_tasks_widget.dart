import '/auth/supabase_auth/auth_util.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import '/utils/components/empty_lists/empty_lists_widget.dart';
import '/utils/components/page_loader/page_loader_widget.dart';
import 'dart:async';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:text_search/text_search.dart';
import 'all_tasks_model.dart';
export 'all_tasks_model.dart';

class AllTasksWidget extends StatefulWidget {
  const AllTasksWidget({
    super.key,
    String? taskStatus,
  }) : taskStatus = taskStatus ?? 'taskStatus';

  final String taskStatus;

  @override
  State<AllTasksWidget> createState() => _AllTasksWidgetState();
}

class _AllTasksWidgetState extends State<AllTasksWidget> {
  late AllTasksModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AllTasksModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (FFAppState().ONLINE) {
        _model.isDirtyCounterr = await actions.isDirtyCount();
        _model.statusOutput = _model.isDirtyCounterr != '0'
            ? 'Tap to update'
            : 'Tasks are updated';
        safeSetState(() {});
        if (_model.isDirtyCounterr != '0') {
          _model.statusOutput = 'Syncing...';
          _model.isSyncDone = false;
          safeSetState(() {});
          _model.outputMsg = await actions.syncOnlineTaskAndPpirToOffline();
          _model.statusOutput = 'Tasks are updated';
          _model.isSyncDone = true;
          safeSetState(() {});
        }
      }
    });

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return FutureBuilder<List<SELECTPPIRFormsByAssigneeAndTaskStatusRow>>(
      future: SQLiteManager.instance.sELECTPPIRFormsByAssigneeAndTaskStatus(
        assignee: currentUserUid,
        status: widget.taskStatus,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: const Center(
              child: PageLoaderWidget(),
            ),
          );
        }
        final allTasksSELECTPPIRFormsByAssigneeAndTaskStatusRowList =
            snapshot.data!;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).accent1,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                icon: Icon(
                  Icons.chevron_left,
                  color: FlutterFlowTheme.of(context).info,
                  size: 30.0,
                ),
                onPressed: () async {
                  context.pushNamed(
                    'dashboard',
                    extra: <String, dynamic>{
                      kTransitionInfoKey: const TransitionInfo(
                        hasTransition: true,
                        transitionType: PageTransitionType.scale,
                        alignment: Alignment.bottomCenter,
                        duration: Duration(milliseconds: 200),
                      ),
                    },
                  );
                },
              ),
              title: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                    child: Text(
                      () {
                        if (widget.taskStatus == 'for dispatch') {
                          return 'For Dispatch Tasks';
                        } else if (widget.taskStatus == 'ongoing') {
                          return 'Ongoing Tasks';
                        } else {
                          return 'Completed Tasks';
                        }
                      }(),
                      style: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).info,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 5.0, 0.0),
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if (FFAppState().ONLINE)
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      if (FFAppState().ONLINE) {
                                        _model.statusOutput = 'Syncing...';
                                        _model.isSyncDone = false;
                                        safeSetState(() {});
                                        _model.message = await actions
                                            .syncOnlineTaskAndPpirToOffline();
                                        _model.statusOutput =
                                            'Tasks are updated';
                                        _model.isSyncDone = true;
                                        safeSetState(() {});
                                      }

                                      safeSetState(() {});
                                    },
                                    child: Text(
                                      '[ ${_model.statusOutput} ]',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            color: FlutterFlowTheme.of(context)
                                                .info,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                if (!FFAppState().ONLINE)
                                  Text(
                                    '[ No internet for sync ]',
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                              ].divide(const SizedBox(width: 5.0)),
                            ),
                          ),
                        ),
                        wrapWithModel(
                          model: _model.connectivityModel,
                          updateCallback: () => safeSetState(() {}),
                          child: const ConnectivityWidget(),
                        ),
                      ].divide(const SizedBox(width: 5.0)),
                    ),
                  ),
                ],
              ),
              actions: const [],
              centerTitle: false,
              elevation: 0.0,
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.textController,
                        focusNode: _model.textFieldFocusNode,
                        onFieldSubmitted: (_) async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Searching ${_model.textController.text}',
                                style: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              duration: const Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).secondary,
                            ),
                          );
                          safeSetState(() {
                            _model.simpleSearchResults = TextSearch(
                                    allTasksSELECTPPIRFormsByAssigneeAndTaskStatusRowList
                                        .map((e) => e.ppirFarmername)
                                        .withoutNulls
                                        .toList()
                                        .map((str) => TextSearchItem.fromTerms(
                                            str, [str]))
                                        .toList())
                                .search(_model.textController.text)
                                .map((r) => r.object)
                                .toList();
                          });
                        },
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: FFLocalizations.of(context).getText(
                            'agvkb82b' /* Farmer Name */,
                          ),
                          labelStyle:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0.0,
                                  ),
                          hintText: FFLocalizations.of(context).getText(
                            'q2ma3u37' /* Farmer Name */,
                          ),
                          hintStyle:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0.0,
                                  ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          prefixIcon: const Icon(
                            Icons.search_sharp,
                            size: 24.0,
                          ),
                          suffixIcon: const Icon(
                            Icons.send_sharp,
                          ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0.0,
                            ),
                        cursorColor: FlutterFlowTheme.of(context).primaryText,
                        validator:
                            _model.textControllerValidator.asValidator(context),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 2.0,
                  color: FlutterFlowTheme.of(context).alternate,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      width: 0.0,
                      height: MediaQuery.sizeOf(context).height * 1.0,
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.sizeOf(context).width * 1.0,
                        minHeight: MediaQuery.sizeOf(context).height * 1.0,
                      ),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Builder(
                          builder: (context) {
                            final tasks =
                                allTasksSELECTPPIRFormsByAssigneeAndTaskStatusRowList
                                    .where(
                                        (e) => e.status == widget.taskStatus)
                                    .toList();
                            if (tasks.isEmpty) {
                              return Center(
                                child: EmptyListsWidget(
                                  type: '${() {
                                    if (widget.taskStatus == 'for dispatch') {
                                      return 'Dispatch';
                                    } else if (widget.taskStatus ==
                                        'ongoing') {
                                      return 'Ongoing';
                                    } else {
                                      return 'Completed';
                                    }
                                  }()} Tasks',
                                ),
                              );
                            }

                            return FlutterFlowDataTable<
                                SELECTPPIRFormsByAssigneeAndTaskStatusRow>(
                              controller: _model.paginatedDataTableController,
                              data: tasks,
                              columnsBuilder: (onSortChanged) => [
                                DataColumn2(
                                  label: DefaultTextStyle.merge(
                                    softWrap: true,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            FFLocalizations.of(context).getText(
                                              'hialfg9h' /* Task Number */,
                                            ),
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .labelLarge
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .info,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn2(
                                  label: DefaultTextStyle.merge(
                                    softWrap: true,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            FFLocalizations.of(context).getText(
                                              'n3zqay7i' /* Farmer Name */,
                                            ),
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .labelLarge
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .info,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn2(
                                  label: DefaultTextStyle.merge(
                                    softWrap: true,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            FFLocalizations.of(context).getText(
                                              'xpwbz0mf' /* GPX */,
                                            ),
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .labelLarge
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .info,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              dataRowBuilder: (tasksItem, tasksIndex, selected,
                                      onSelectChanged) =>
                                  DataRow(
                                color: WidgetStateProperty.all(
                                  tasksIndex % 2 == 0
                                      ? FlutterFlowTheme.of(context)
                                          .secondaryBackground
                                      : FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                ),
                                cells: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            currentUserLocationValue =
                                                await getCurrentUserLocation(
                                                    defaultLocation:
                                                        const LatLng(0.0, 0.0));
                                            unawaited(
                                              () async {
                                                await UserLogsTable().insert({
                                                  'user_id': currentUserUid,
                                                  'activity': 'Select a Task',
                                                  'longlat':
                                                      '${functions.getLng(currentUserLocationValue).toString()}, ${functions.getLat(currentUserLocationValue).toString()}',
                                                });
                                              }(),
                                            );

                                            context.pushNamed(
                                              'taskDetails',
                                              queryParameters: {
                                                'taskId': serializeParam(
                                                  tasksItem.taskId,
                                                  ParamType.String,
                                                ),
                                                'taskStatus': serializeParam(
                                                  widget.taskStatus,
                                                  ParamType.String,
                                                ),
                                              }.withoutNulls,
                                              extra: <String, dynamic>{
                                                kTransitionInfoKey:
                                                    const TransitionInfo(
                                                  hasTransition: true,
                                                  transitionType:
                                                      PageTransitionType.scale,
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                ),
                                              },
                                            );
                                          },
                                          child: Text(
                                            valueOrDefault<String>(
                                              tasksItem.taskNumber,
                                              'task number',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            currentUserLocationValue =
                                                await getCurrentUserLocation(
                                                    defaultLocation:
                                                        const LatLng(0.0, 0.0));
                                            unawaited(
                                              () async {
                                                await UserLogsTable().insert({
                                                  'user_id': currentUserUid,
                                                  'activity': 'Select a Task',
                                                  'longlat':
                                                      '${functions.getLng(currentUserLocationValue).toString()}, ${functions.getLat(currentUserLocationValue).toString()}',
                                                });
                                              }(),
                                            );

                                            context.pushNamed(
                                              'taskDetails',
                                              queryParameters: {
                                                'taskId': serializeParam(
                                                  tasksItem.taskId,
                                                  ParamType.String,
                                                ),
                                                'taskStatus': serializeParam(
                                                  widget.taskStatus,
                                                  ParamType.String,
                                                ),
                                              }.withoutNulls,
                                              extra: <String, dynamic>{
                                                kTransitionInfoKey:
                                                    const TransitionInfo(
                                                  hasTransition: true,
                                                  transitionType:
                                                      PageTransitionType.scale,
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                ),
                                              },
                                            );
                                          },
                                          child: Text(
                                            valueOrDefault<String>(
                                              tasksItem.ppirFarmername,
                                              'task number',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          currentUserLocationValue =
                                              await getCurrentUserLocation(
                                                  defaultLocation:
                                                      const LatLng(0.0, 0.0));
                                          unawaited(
                                            () async {
                                              await UserLogsTable().insert({
                                                'user_id': currentUserUid,
                                                'activity': 'Select a Task',
                                                'longlat':
                                                    '${functions.getLng(currentUserLocationValue).toString()}, ${functions.getLat(currentUserLocationValue).toString()}',
                                              });
                                            }(),
                                          );

                                          context.pushNamed(
                                            'taskDetails',
                                            queryParameters: {
                                              'taskId': serializeParam(
                                                tasksItem.taskId,
                                                ParamType.String,
                                              ),
                                              'taskStatus': serializeParam(
                                                widget.taskStatus,
                                                ParamType.String,
                                              ),
                                            }.withoutNulls,
                                            extra: <String, dynamic>{
                                              kTransitionInfoKey:
                                                  const TransitionInfo(
                                                hasTransition: true,
                                                transitionType:
                                                    PageTransitionType.scale,
                                                alignment:
                                                    Alignment.bottomCenter,
                                                duration:
                                                    Duration(milliseconds: 200),
                                              ),
                                            },
                                          );
                                        },
                                        child: Text(
                                          (allTasksSELECTPPIRFormsByAssigneeAndTaskStatusRowList
                                                          .first.gpx ==
                                                      ' ') ||
                                                  (allTasksSELECTPPIRFormsByAssigneeAndTaskStatusRowList
                                                          .first.gpx ==
                                                      'null') ||
                                                  (allTasksSELECTPPIRFormsByAssigneeAndTaskStatusRowList
                                                          .first.gpx ==
                                                      '')
                                              ? 'No GPX'
                                              : 'Has GPX',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ].map((c) => DataCell(c)).toList(),
                              ),
                              emptyBuilder: () => Center(
                                child: EmptyListsWidget(
                                  type: '${() {
                                    if (widget.taskStatus == 'for dispatch') {
                                      return 'Dispatch';
                                    } else if (widget.taskStatus ==
                                        'ongoing') {
                                      return 'Ongoing';
                                    } else {
                                      return 'Completed';
                                    }
                                  }()} Tasks',
                                ),
                              ),
                              paginated: true,
                              selectable: false,
                              hidePaginator: false,
                              showFirstLastButtons: false,
                              columnSpacing: 2.0,
                              headingRowColor:
                                  FlutterFlowTheme.of(context).primary,
                              borderRadius: BorderRadius.circular(12.0),
                              addHorizontalDivider: false,
                              addTopAndBottomDivider: false,
                              hideDefaultHorizontalDivider: true,
                              addVerticalDivider: false,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ].divide(const SizedBox(height: 0.0)).around(const SizedBox(height: 0.0)),
            ),
          ),
        );
      },
    );
  }
}

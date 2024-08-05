import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/page_loader/page_loader_widget.dart';
import '/utils/components/toast/toast_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'task_details_model.dart';
export 'task_details_model.dart';

class TaskDetailsWidget extends StatefulWidget {
  const TaskDetailsWidget({
    super.key,
    required this.taskId,
    required this.taskStatus,
  });

  final String? taskId;
  final String? taskStatus;

  @override
  State<TaskDetailsWidget> createState() => _TaskDetailsWidgetState();
}

class _TaskDetailsWidgetState extends State<TaskDetailsWidget> {
  late TaskDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TaskDetailsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.isEditing = false;
      setState(() {});
      await SQLiteManager.instance.sELECTUSERSInSameRegion();
      await SQLiteManager.instance.selectSyncLogs();
      await SQLiteManager.instance.getLastSyncTimestamp();
      await SQLiteManager.instance.getQueuedChanges();
      await SQLiteManager.instance.getModifiedRecords();
      await SQLiteManager.instance.insertUpdateSyncStatus(
        tablename: 'table_name',
        lastsynctimestamp: getCurrentTimestamp,
      );
      await SQLiteManager.instance.updatePPIRBasicInfo(
        ppirfarmername: 'ppir_farmername',
        ppiraddress: 'ppir_address',
        ppirfarmertype: 'ppir_farmertype',
        ppirgroupname: 'ppir_groupname',
        ppirmobileno: 'ppir_mobileno',
        ppirgroupaddress: 'ppir_groupaddress',
        updatedat: getCurrentTimestamp,
        taskid: 'task_id',
      );
      await SQLiteManager.instance.updatePPIRLocation(
        ppirsouth: 'ppir_south',
        ppirnorth: 'ppir_north',
        ppireast: 'ppir_east',
        ppirwest: 'ppir_west',
        ppirfarmloc: 'ppir_farmloc',
        isupdatedat: getCurrentTimestamp,
        isdirty: true,
        taskid: 'task_id',
      );
      await SQLiteManager.instance.updatePPIRCropInfo(
        ppirvariety: 'ppir_variety',
        ppirareaaci: 'ppir_area_aci',
        ppirstagecrop: 'ppir_stagecrop',
        ppirareaact: 'ppir_area_act',
        updatedat: getCurrentTimestamp,
        isdirty: true,
        taskid: 'task_id',
      );
    });

    _model.farmLocInputFocusNode ??= FocusNode();
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
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: const PageLoaderWidget(),
          );
        }
        List<PpirFormsRow> taskDetailsPpirFormsRowList = snapshot.data!;

        // Return an empty Container when the item does not exist.
        if (snapshot.data!.isEmpty) {
          return Container();
        }
        final taskDetailsPpirFormsRow = taskDetailsPpirFormsRowList.isNotEmpty
            ? taskDetailsPpirFormsRowList.first
            : null;

        return GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              appBar: AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                automaticallyImplyLeading: false,
                leading: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30.0,
                  borderWidth: 1.0,
                  buttonSize: 60.0,
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () async {
                    context.pushNamed(
                      'dashboard',
                      extra: <String, dynamic>{
                        kTransitionInfoKey: const TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.leftToRight,
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
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Task Details: Status is ${functions.capitalizeWords(widget.taskStatus)}',
                        style:
                            FlutterFlowTheme.of(context).displaySmall.override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .displaySmallFamily,
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .displaySmallFamily),
                                ),
                      ),
                    ),
                    Stack(
                      children: [
                        if ((_model.isEditing == false) &&
                            (widget.taskStatus != 'completed'))
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              _model.isEditing = !(_model.isEditing ?? true);
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 24.0,
                            ),
                          ),
                        if (_model.isEditing == true)
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              _model.isEditing = !(_model.isEditing ?? true);
                              setState(() {});
                              await PpirFormsTable().update(
                                data: {
                                  'ppir_farmloc':
                                      _model.farmLocInputTextController.text,
                                },
                                matchingRows: (rows) => rows.eq(
                                  'task_id',
                                  widget.taskId,
                                ),
                              );
                              await actions.successToast(
                                context,
                                'Success!',
                                'You have successfully edited the farm location!',
                                600,
                                3000,
                                () async {
                                  Navigator.pop(context);
                                },
                                () async {},
                              );
                            },
                            child: const FaIcon(
                              FontAwesomeIcons.save,
                              color: Colors.white,
                              size: 24.0,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                actions: const [],
                centerTitle: false,
                elevation: 0.0,
              ),
              body: SafeArea(
                top: true,
                child: FutureBuilder<List<TasksRow>>(
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
                    List<TasksRow> containerTasksRowList = snapshot.data!;

                    final containerTasksRow = containerTasksRowList.isNotEmpty
                        ? containerTasksRowList.first
                        : null;

                    return Container(
                      width: 100.0,
                      height: 100.0,
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.sizeOf(context).width * 1.0,
                        minHeight: MediaQuery.sizeOf(context).height * 1.0,
                      ),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 20.0, 20.0, 0.0),
                                    child: Container(
                                      width: 600.0,
                                      constraints: const BoxConstraints(
                                        maxWidth: 570.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 12.0),
                                              child: Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'j9rxgs8h' /* Form Details */,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLargeFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLargeFamily),
                                                        ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'zvbf8lkk' /* Assignment Id */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirAssignmentid,
                                                      'Assignment ID',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'x8d6g468' /* Farmer Name */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirFarmername,
                                                      'Farmer Name',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'webbx3lh' /* Address */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirAddress,
                                                      'Address',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'qfage2ic' /* Insurance Id */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirInsuranceid,
                                                      'Insurance Id',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'ezx6meo9' /* Mobile Number */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirMobileno,
                                                      'Mobile Number',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'gvdbo0h6' /* Farmer Type */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirFarmertype,
                                                      'Farmer Type',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      '0blfogwv' /* Group Name */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirGroupname,
                                                      'Group Name',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'lst6ktx6' /* Group Address */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirGroupaddress,
                                                      'Group Address',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'zv71woqo' /* Lender Name */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirLendername,
                                                      'Lender Name',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'jl733wsk' /* Lender Address */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirLenderaddress,
                                                      'Lender Address',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'zop5kb93' /* Region */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      functions
                                                          .removePpirOnString(
                                                              containerTasksRow
                                                                  ?.serviceType),
                                                      'Region',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'b12iqcln' /* CIC Number */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirCicno,
                                                      'CIC Number',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'p1282pce' /* Farm Location */,
                                                    ),
                                                    style:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                              color: _model
                                                                          .isEditing ==
                                                                      true
                                                                  ? FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary
                                                                  : FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              useGoogleFonts: GoogleFonts
                                                                      .asMap()
                                                                  .containsKey(
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMediumFamily),
                                                            ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  8.0,
                                                                  0.0,
                                                                  8.0,
                                                                  0.0),
                                                      child: TextFormField(
                                                        controller: _model
                                                                .farmLocInputTextController ??=
                                                            TextEditingController(
                                                          text: valueOrDefault<
                                                              String>(
                                                            taskDetailsPpirFormsRow
                                                                ?.ppirFarmloc,
                                                            'Farm Location',
                                                          ),
                                                        ),
                                                        focusNode: _model
                                                            .farmLocInputFocusNode,
                                                        autofocus: false,
                                                        readOnly:
                                                            _model.isEditing ==
                                                                false,
                                                        obscureText: false,
                                                        decoration:
                                                            const InputDecoration(
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          errorBorder:
                                                              InputBorder.none,
                                                          focusedErrorBorder:
                                                              InputBorder.none,
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily),
                                                                ),
                                                        textAlign:
                                                            TextAlign.end,
                                                        validator: _model
                                                            .farmLocInputTextControllerValidator
                                                            .asValidator(
                                                                context),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 16.0, 0.0, 16.0),
                                              child: Divider(
                                                thickness: 2.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .boarderForm,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 12.0),
                                              child: Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'hvb7985g' /* Location Sketch Plan */,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLargeFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLargeFamily),
                                                        ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'cat2uvtb' /* North */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirNorth,
                                                      'North',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'hytwamsl' /* East */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirEast,
                                                      'East',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'qtzirwg5' /* South */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLargeFamily,
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelLargeFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirSouth,
                                                      'South',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'gmqdadav' /* West */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLargeFamily,
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelLargeFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirWest,
                                                      'West',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 16.0, 0.0, 16.0),
                                              child: Divider(
                                                thickness: 2.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .boarderForm,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 12.0),
                                              child: Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'tsu0lxo2' /* Location Sketch Plan */,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLargeFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLargeFamily),
                                                        ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      '792xrz3k' /* Area Planted */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirAreaAci,
                                                      'Area Planted',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'zxmreuh1' /* Date of Planting (DS) */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirDoptpAci,
                                                      'DS',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'ncrtgoe1' /* Datee of Planting (TP) */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirDoptpAci,
                                                      'TP',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'nzua63mv' /* Seed Variety Planted */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      taskDetailsPpirFormsRow
                                                          ?.ppirSvpAci,
                                                      'Variety',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 16.0, 0.0, 16.0),
                                              child: Divider(
                                                thickness: 2.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .boarderForm,
                                              ),
                                            ),
                                            if (widget.taskStatus ==
                                                'completed')
                                              SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      12.0),
                                                          child: Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              'dgbzqn0h' /* Completed Task  Details */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLargeFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyLargeFamily),
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  8.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              'nd1fqdu9' /* Tracking Details */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  8.0,
                                                                  20.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              'uxt6f9xl' /* Last Coordinates */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                          ),
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              taskDetailsPpirFormsRow
                                                                  ?.trackLastCoord,
                                                              'Coordinates',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  8.0,
                                                                  20.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              'or3srkkk' /* Track Date */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                          ),
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              taskDetailsPpirFormsRow
                                                                  ?.trackDateTime,
                                                              'Date Time',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  8.0,
                                                                  20.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              '01tvwwxt' /* Total Area (ha) */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                          ),
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              taskDetailsPpirFormsRow
                                                                  ?.trackTotalArea,
                                                              'Total Area',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  8.0,
                                                                  20.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              'vp2u9vxf' /* Total Distance */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                          ),
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              taskDetailsPpirFormsRow
                                                                  ?.trackTotalDistance,
                                                              'Distance',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  16.0),
                                                      child: Divider(
                                                        thickness: 2.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .boarderForm,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  8.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              'v9d4i47l' /* Seed Details */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  8.0,
                                                                  20.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              '762mtpey' /* Type */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                          ),
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              taskDetailsPpirFormsRow
                                                                  ?.ppirSvpAct,
                                                              'Actual Seed',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  8.0,
                                                                  20.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              'veh8acpl' /* Variety */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                          ),
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              taskDetailsPpirFormsRow
                                                                  ?.ppirSvpAci,
                                                              'Variety',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  16.0),
                                                      child: Divider(
                                                        thickness: 2.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .boarderForm,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  8.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              'anco0w5m' /* Date Details */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  8.0,
                                                                  20.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              '27rka9jx' /* Date of Planting (DS) */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                          ),
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              taskDetailsPpirFormsRow
                                                                  ?.ppirDopdsAct,
                                                              'DS',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  8.0,
                                                                  20.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              '3zj0x11r' /* Date of Planting (TP) */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                          ),
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              taskDetailsPpirFormsRow
                                                                  ?.ppirDoptpAci,
                                                              'TP',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  16.0),
                                                      child: Divider(
                                                        thickness: 2.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .boarderForm,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  8.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              'lnj6pjl7' /* Agent Confirmation */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  8.0,
                                                                  20.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              '966yfol9' /* Remarks */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                          ),
                                                          AutoSizeText(
                                                            valueOrDefault<
                                                                String>(
                                                              taskDetailsPpirFormsRow
                                                                  ?.ppirRemarks,
                                                              'Remarks',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  8.0,
                                                                  20.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              '7ftdujb6' /* Confirmed By */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                          ),
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              taskDetailsPpirFormsRow
                                                                  ?.ppirNameInsured,
                                                              'Name Insured',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  8.0,
                                                                  20.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Align(
                                                              alignment:
                                                                  const AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child: SizedBox(
                                                                width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width *
                                                                    0.8,
                                                                height: MediaQuery.sizeOf(
                                                                            context)
                                                                        .height *
                                                                    0.2,
                                                                child: custom_widgets
                                                                    .Signaturebase64(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.8,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.2,
                                                                  blob: valueOrDefault<
                                                                      String>(
                                                                    taskDetailsPpirFormsRow
                                                                        ?.ppirSigInsured,
                                                                    '/9j/4AAQSkZJRgABAQEBLAEsAAD/4QBWRXhpZgAATU0AKgAAAAgABAEaAAUAAAABAAAAPgEbAAUAAAABAAAARgEoAAMAAAABAAIAAAITAAMAAAABAAEAAAAAAAAAAAEsAAAAAQAAASwAAAAB/+0ALFBob3Rvc2hvcCAzLjAAOEJJTQQEAAAAAAAPHAFaAAMbJUccAQAAAgAEAP/hDIFodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvADw/eHBhY2tldCBiZWdpbj0n77u/JyBpZD0nVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkJz8+Cjx4OnhtcG1ldGEgeG1sbnM6eD0nYWRvYmU6bnM6bWV0YS8nIHg6eG1wdGs9J0ltYWdlOjpFeGlmVG9vbCAxMC4xMCc+CjxyZGY6UkRGIHhtbG5zOnJkZj0naHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyc+CgogPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9JycKICB4bWxuczp0aWZmPSdodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyc+CiAgPHRpZmY6UmVzb2x1dGlvblVuaXQ+MjwvdGlmZjpSZXNvbHV0aW9uVW5pdD4KICA8dGlmZjpYUmVzb2x1dGlvbj4zMDAvMTwvdGlmZjpYUmVzb2x1dGlvbj4KICA8dGlmZjpZUmVzb2x1dGlvbj4zMDAvMTwvdGlmZjpZUmVzb2x1dGlvbj4KIDwvcmRmOkRlc2NyaXB0aW9uPgoKIDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PScnCiAgeG1sbnM6eG1wTU09J2h0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8nPgogIDx4bXBNTTpEb2N1bWVudElEPmFkb2JlOmRvY2lkOnN0b2NrOjFhZWQ4MDk2LWE5NzUtNDI2ZC04MDY3LTRhOTIxODZmNzU5MjwveG1wTU06RG9jdW1lbnRJRD4KICA8eG1wTU06SW5zdGFuY2VJRD54bXAuaWlkOmMxM2MwNDBlLTBlNjAtNGY2Yy04ZjFiLWJmOGIwNzZhMDMxZDwveG1wTU06SW5zdGFuY2VJRD4KIDwvcmRmOkRlc2NyaXB0aW9uPgo8L3JkZjpSREY+CjwveDp4bXBtZXRhPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAo8P3hwYWNrZXQgZW5kPSd3Jz8+/9sAQwAFAwQEBAMFBAQEBQUFBgcMCAcHBwcPCwsJDBEPEhIRDxERExYcFxMUGhURERghGBodHR8fHxMXIiQiHiQcHh8e/9sAQwEFBQUHBgcOCAgOHhQRFB4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4e/8AAEQgBaAHgAwERAAIRAQMRAf/EABwAAQACAgMBAAAAAAAAAAAAAAAGBwQFAQIDCP/EAEAQAQABBAECBAMFBQUFCQAAAAABAgMEBQYHERIhMUETUWEIFCIykRVCUnGBFhczQ4IjYqGisTZUZJKTssLS8P/EABYBAQEBAAAAAAAAAAAAAAAAAAABAv/EACARAQEAAQQDAQEBAAAAAAAAAAABAhESMVEDE0EhIiP/2gAMAwEAAhEDEQA/APssAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADuDVYHJePZ+6yNJg7zXZWzxqPHfxLOTRXdtR37d6qYnvT5/MG1AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA7gr/kfVHV4+3u8e4nr8vmHIbc+G5hayaZtY0/+IyJ/wBnZj6TM1fKmQa7+w3MuZf7XqLyerE19frx/j12vHsTH8N7J8rt76xT4KfpIJ3xbjPH+La2nXcd02DqsWn/AC8WxTbifrPbzqn6z3kG2AAAAAkFecp57nXb+fruF42DlVa6Kv2nuthcm3rNb4Y71xXVHnduUx60UT+H96qn0B6dD9pzLdcby9pyu/j5GPkZlVWov04M4l2/ido8Nyu1NVXg8U95piZ7+HwzPnIJ+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACHc66jaDiuZZ1NUZW23+TT4sXS6218fLvR/F4Y8qKP9+uaaY+YI9HFec89j43PNpXxzS3PTjulyZi7cp+WVlx2qq8vWi14af96oFg8c0Wm45qbOp0WsxNbg2Y7W7GNaiiiPr2j1n6z5yDYgAAAAAAgPKtjl8q3GXxDS5l3C12JTH7f21qvwVWYmO/3WzX7XaqfOqv/LomP3qo7BouOavB57Th4mtwbeF001FcRhYtFHho3N2ifKuY98WiqO8d/wDFq/FPemI8QW3Edo7AAAAAAAAAAAAAAAAAAAAd4+YHcDv/AD/QDv8Az/QDuAAAAAAAAAAAAAAAAAAAAADD3O012l1eRtNtnY+Dg41E3L+RfuRRbt0x7zVPlAKw/tBzXqf3tcLjI4pxOvyq5DlWO2bm0e/3SxVH4KZj0vXI9+9NPuCbcE4NxvheHds6TBmnIyKvHl5t+ub2Vl1/x3btXequf5z2j2iASUAAAAAAAET57vM+xcxONccqtzyDaRV8KuqnxU4VintFzKrj5U94imJ/NXNMenfsEI0uoxOaWKeK6Cq9b6e667VRss74kzd5BkxVM3LcV+tVnx95u3P8yrvRH4fFILgx7NrHsUWLFui1at0xTRRRTFNNNMR2iIiPSIj2B0zsrGwcS9mZmRax8ezRNy7du1RTRRTEd5qmZ8oiPmDG4/udXyDTY240ufj5+vyqfHYyLFfiouR3mO8T/OJj+gM8AAAAAAAAADvHzBxNURHeZ7R85Bodzzbh2mir9r8q0eBNPrGRn2rc/pNXdZLRDNn9oTo7gVVUVc4wMm5T+5h27uRM/wAvh0zDU8eV4g10/aE45mdqeO8Q53yCqryonC0NyKKv9Vzwr6spyOlfVjqPm/h0fQfk9dU+UVbPOsYdMfz795J4+7AnkH2i9hTVXhcA4Xpon8tGx3Fy/XH/AKUdjbhryOKtN9pLOoib3MuA6map84xNXevTT/W5PaU/gdP7tutOwmZ2vXjIx4mO3g12hsWo/WZ7rbh0OLvQ/keVRNOf1y6jXe/5vg5lFmJ/pFLOuPQ85+zlq7tMRmdTepuT8/Hv57T/AE8JbOh51fZi4XXMzc5Xz6539fFvJn/4pqJ10o6aa7pxazsfVb/kWxxsyqmubO0zYv02qo796qPwxMTPeO/z7QgnIAAAAAAAAAAAAAAAAAAAIl1F57p+F42NRk0ZGw2+fVNrWanCo+JlZtz+Gin2pj3rntTTHrIIzpeAbjlu2x+UdV68fKu2K4u67jlivx4Gvn2quf8AeL0fx1R4aZ/LHuC04iIjtEdgAAAAAAAAarlu+wOM8fyt1sq6osY9MdqKI713a5mKaLdEe9dVUxTEe8zAKR4nj7zqZs9pRbya8bVZl7wck3GNcmPvXg7xTqsKuP8AItxM03L1P5qpr8P5pmAvvWYOHrNfj6/X41nFxMa3Tas2bVEU0W6KY7RTTEekRAOu22GFqdZk7PZZVrEw8W1Vev37tXhot0Ux3mqZ+UQD5UnM5N9qbm1/BxbuXpukupyYi/coiaLu0rp8/D3+vr29KImJnvVMAvnkvN+nvSrG4/xrPy8fU0ZddvC1mBjWaq6op7+GJiimJmKIntHin3n3kE87grnrF1g4x02jCwsz4u03uwvW7WHqMOqn7xd8VUR4p7z2op+tXbvPlHv2D25f1m6acTx/HvOW62zkeHv90s3oyMjv/D4LXinv38vl9QQ2OrvUTmP4OmPSvYfda/ybfklf3LG7fxU2/wA9cfykE46Z6XqLg38nY8+5jhba7kW4pt67Xa+mzi4s9+8zTXP+0rn285iPoCTbjkfH9NTNW43ms10R6zlZdu12/wDNMGlEG2fXzpJg3psU8zw8+/7WtdbuZdVX8vhU1Nzx534NfPXCjOomeN9M+oe6jv2puUaf7vamZ9PxXao8vr2X1X6PL+2/W/a1dtR0ewtVRM9ou7nfW47fWaLVMz/xXZjOchzOs+0Vtoj7zyfgvHKKvX7jr72Xco/rcnwz+h/lO6FfSbneyq77/rly29RP5qNZj2MCP5d6ImTfhOMQo+zrwLIrpr3ubynkVcetWz3t+53/AKU1RHY9t+SDf6bon0n1HacPgGhmqP37+LF6r9a+8p7c+xMdfodJrrdNvA0+vxKKY7U02caiiIj+kM3LK80bHsyHaPkAAAAAAAAAAAAAAAAAAAAAAAAAACA9TufX9Hm4vFeK4FG75nsqJqw8Cau1rHt+k5OTVH+HZp/WqfKn6B6dN+n1rjuVkci3ufVv+X59EU522vUdpin1izYo9LVmPamPX1nvIJ0AAAAAAAADreuW7Nqq7drpoooiaqqqp7RTEeszPtAPnXkmpz/tF8wxrdvJycPpXpMnxfHtzNFW9yqZmJm3Pr8Gnzpiv385jznvSH0Dp9bgafV42r1eJZw8LFt02rFizRFNFuiI7RTER6QDLkHyv1W2m/8AtBdSLvSvhuVcxOFaa/E8k3FrzovXKZ/wqJ9Ku0xMRT6TV3qnypgFpc35r0+6AdO8PWUWqbVGPjzRrNRjTE38ntEzNXz7d+81XJ+s+c+QIT0S4NjXsiOv3VjZ4t3e7SzTmYVOVXFvF1OPVT3txT4p7eKKJjtP7vfy85mQabqp9qjS39xHE+ne1w8eu7M0ZHI82zXXjYse82rVNM13avl5dpnt6x5rMblwNPo9f0tz9DlY1vphz/qlts+7F/N3mXq7lmvJux386b1yqmbdHn5U0+3bv3b9eX0SzhvFOX6iui9wj7P/AAnidfrRl7vaRk34j6/Dpqrif9RtxnNE1jiXXDcU9tz1T1GkoqiJqt6PR01VR9IuX6pnt9exrhB0/uJwthPflPUPn/IaZ9bORuarNmZ+fgtRT/1PZJxBt9N0K6Saqum5Y4Lqb92J7/FzKJyq5n5zN2au8nty+CcanSabUU+DVanAwKfljY1FqP8AliGblleaNh2ZDtHyAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABCer/OKuGaLGo1uF+0+RbbIjB0uvie33jIq96vlboj8VVXtEfUHHSfgdHENflZuzzZ2/KNtXGRudrcj8WRd7eVFP8Nqj8tFEeURHzkE3AAAAAAAABi7fY4Oo1mRs9nl2MPCxrc3b9+9XFFFuiPWqqZ8ogHzTsOU8h+0N1DucI0ljP0vTjXxbv7rMqoqtX9nbq/FbtR386KLkecU+s0/in2gH0pj29dptVax7VOPg4OLapt26Y7W7dqimO0Ux7REQCFcn61dK+OV1WtnzjTzfp9bGLe+83e/y8FrxT3WS3gUt1I+0FsepGPc4N0L0+52mzy6KvvufTZ+BONj94iqbc1z+Gqe/bx1dvD38u8z5Jj+6DS8J5/1F0+0tdIuknTbjuvu4UROZfr2M7CnFqq/Ncyb1vw2/ieXnHeqf3Yjy7Fkn0THWfZm3mw3+w5LzLqvus7b7WxVjZ1zAx6LPis1eVVmmqvxTTRMd47UxTHbya1x6Ej1X2X+muPl2L23vci5FZx6aaMfF2uzquWbVNMdoiKaYp8o+Xp9GBaXHeF8R47ZotaLjOn1tNH5fu2Hbon9Yju1vy7G+7MgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACneH2v7U/aX5ju8/wDFRxDExtRq7dU+Vuu/b+NfuxHtVVE009/lHYFxAAAAAAA87961YtVXb1yi3bp86qq6opiP6yCEcj6w9MOP3JtbPnGkpvR5TYsZMZF3v8vBb8VX/Ak14Gi/vpp2cduH9Oudciir/DyKdZ9zxqvr8S/NHl/RdtFQdbsrrVyLmPGrGz4zx7EwM7MizquLZef96m/finxTlZEWu1Nyi128UxVPgp8u8VTPndJ2LA4V0T53q9RdwNl1k21qjLybmXmzp9dZxr2ReuT3qrqv1xVXM+kR6doiIiIiDXHob6joL04t+LN5LRtuTV2o8dV/f7e9k00xHnMzTVVFER7+hu6ghmu1uD1HvXuO9J9LgcS4Jarqs7PkuDg0Wb2x9q7GHPh7+GfSq9P8o+tueV+jJx/syYOt5Ftf7Nc023HOLbamzGZqNbapou3It0+HwfeZma/BPeqZjt5zVP0YFy8F4dxrhGhtaTi+px9bhW/OabcfiuVfxV1T511fWZmQb4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFY8q0u/4jz7M6g8S1Ve7xtrYtWN/p7NdNF+7NqJi1k481TFNVymmZpqomY8URHae8eYZGB1t6a3rkY+x5Fb0Gb6V4e7s14F63PvExdiI/SZj6g3VPUzpzVbm5Tz7i00R6z+17H/2BgZvWTpTh0zN/qJxfy9qNlbrn9KZmQamvr50xrq8Gs3GfubvtRrNTlZMz/KaLfb/AIg6T1a3ef8Ah450h57nzP5a8zFta+3P9b1cT2/oaDj9q9edvVP3PinDOMWp99ls7uddp/02aaae/wDqBx/d/wBTdv8A9pOsewxrVX5sfj+rsYUR9IuV/Er/AOi/g72egnT29epyOQWdxynIjz+LvNtfyu8/OaJqij/lNROOP8R4tx6imjRcc1GrimIiPumFbtT+tMdzWj35VvdVxjjudv8Ad5dGJrsGzN6/ernyppj5fOZnyiPWZmIQQTo9otnttnl9UeXY1djd7mzFvXYV311Wu797dn6XK/Ku5PzmI9gWDvtvrNDp8rcbnOsYOBiW5uX8i9X4aLdMe8z/APu4Kbx8Xedd8mnL2lrN0nTGiqKsfBq72srf9p7xcu+9vH8u8UetXrPt2C6tdhYmuwbGDgY1nFxbFEW7NmzRFFFumI7RTTEeURHyBkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAx87Aws+z8HOxLGVb/gvW6a4/SYkGjq4DwWqvx1cM45VV/FOrsd//AGgzcLjHHMHt9y0Gqxu3p8HCt0dv0pBtaaKaaYppiKYj2jyB27QAAAACl9vEdWesFWh7fE4bwnJou7HtPejYbTt3t2Jj3osxPiqj3qmImAWbzblWi4ZxzI3/ACPYW8HAx4jxV1ec11T6UU0x51VT7Ux5yCr9BxjkHVvbYvLOpGvuazjGLci/peK3fW5Mflyc2P3q/em16U+/v3C6qKaaKYppiIiI7REewOQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARXq7yeeGdMuRcoop8V3XYFy9Zpn0m527URP08U0ggHGN1oeiXSDQaraVX9jyTY2/jxr8Wn4mbs8+9+O5NNPrP46u01T5RER9IBn8L4DveScix+e9V/g39pYq+JqNFar8eHp4n0n5Xcj53J8on8vpHYLaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABrOVaLW8n45sOP7ix8fX7DHrx8i337TNFUdp7T7T7xPtMAi/TvpPw/g+fe2uux8vP3N6nwXNrtMmrKy5o7dooi5V+Wnt7U9vr3BOwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf//Z',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  8.0,
                                                                  20.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              '8bdkh9n1' /* Prepared By */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                          ),
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              taskDetailsPpirFormsRow
                                                                  ?.ppirNameIuia,
                                                              'Name IUIA',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  8.0,
                                                                  20.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Align(
                                                              alignment:
                                                                  const AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child: SizedBox(
                                                                width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width *
                                                                    0.8,
                                                                height: MediaQuery.sizeOf(
                                                                            context)
                                                                        .height *
                                                                    0.2,
                                                                child: custom_widgets
                                                                    .Signaturebase64(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.8,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.2,
                                                                  blob:
                                                                      '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',
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  16.0),
                                                      child: Divider(
                                                        thickness: 2.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .boarderForm,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  8.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              'ahzx9d2y' /* Geotag */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(),
                                                      child: SizedBox(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                1.0,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.2,
                                                        child: custom_widgets
                                                            .MapBase64(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  1.0,
                                                          height:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .height *
                                                                  0.2,
                                                          blob: taskDetailsPpirFormsRow
                                                                          ?.gpx !=
                                                                      null &&
                                                                  taskDetailsPpirFormsRow
                                                                          ?.gpx !=
                                                                      ''
                                                              ? taskDetailsPpirFormsRow
                                                                  ?.gpx
                                                              : 'PD94bWwgdmVyc2lvbj0iMS4wIj8+DQo8Z3B4IHZlcnNpb249IjEuMCIgeG1sbnM9Imh0dHA6Ly93d3cudG9wb2dyYWZpeC5jb20vR1BYLzEvMCI+DQogIDx0cms+DQogICAgPHRya3NlZz4NCiAgICAgIDx0cmtwdCBsYXQ9IjU1Ljc1MzU3MiIgbG9uPSIzNy44MDgyNTAiPg0KICAgICAgICA8ZWxlPjEzNS4wMDwvZWxlPg0KICAgICAgICA8dGltZT4yMDA5LTA1LTE5VDA0OjAwOjMwWjwvdGltZT4NCiAgICAgIDwvdHJrcHQ+DQogICAgICA8dHJrcHQgbGF0PSI1NS43NTM2MjIiIGxvbj0iMzcuODA4MjU1Ij4NCiAgICAgICAgPGVsZT4xMzUuMDA8L2VsZT4NCiAgICAgICAgPHRpbWU+MjAwOS0wNS0xOVQwNDowMDozMVo8L3RpbWU+DQogICAgICA8L3Rya3B0Pg0KICAgICAgPHRya3B0IGxhdD0iNTUuNzUzNTkzIiBsb249IjM3LjgwODE1OCI+DQogICAgICAgIDxlbGU+MTM1LjAwPC9lbGU+DQogICAgICAgIDx0aW1lPjIwMDktMDUtMTlUMDQ6MDA6MzJaPC90aW1lPg0KICAgICAgPC90cmtwdD4NCiAgICAgIDx0cmtwdCBsYXQ9IjU1Ljc1ODE3NyIgbG9uPSIzNy42Nzc4MDIiPg0KICAgICAgICA8ZWxlPjE1Mi4wMDwvZWxlPg0KICAgICAgICA8dGltZT4yMDA5LTA1LTE5VDA0OjQ2OjI3WjwvdGltZT4NCiAgICAgIDwvdHJrcHQ+DQogICAgPC90cmtzZWc+DQogIDwvdHJrPg0KPC9ncHg+',
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  16.0),
                                                      child: Divider(
                                                        thickness: 2.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .boarderForm,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ].divide(const SizedBox(height: 10.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if ((taskDetailsPpirFormsRow?.gpx != null &&
                                  taskDetailsPpirFormsRow?.gpx != '') &&
                              (widget.taskStatus == 'ongoing'))
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 8.0, 16.0, 12.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  if (_model.isEditing!) {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      enableDrag: false,
                                      useSafeArea: true,
                                      context: context,
                                      builder: (context) {
                                        return GestureDetector(
                                          onTap: () => _model
                                                  .unfocusNode.canRequestFocus
                                              ? FocusScope.of(context)
                                                  .requestFocus(
                                                      _model.unfocusNode)
                                              : FocusScope.of(context)
                                                  .unfocus(),
                                          child: Padding(
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child: SizedBox(
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.1,
                                              child: const ToastWidget(
                                                notificationTitle: 'Fail',
                                                notificationMessage:
                                                    'You are still editing the farm location. Please finishi it first.',
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ).then((value) => safeSetState(() {}));
                                  } else {
                                    context.pushNamed(
                                      'ppir',
                                      queryParameters: {
                                        'taskId': serializeParam(
                                          widget.taskId,
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
                                  }
                                },
                                child: Container(
                                  width: 300.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
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
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color:
                                          FlutterFlowTheme.of(context).accent1,
                                      width: 2.0,
                                    ),
                                  ),
                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Icon(
                                          Icons.task_outlined,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBtnText,
                                          size: 24.0,
                                        ),
                                      ),
                                      Text(
                                        FFLocalizations.of(context).getText(
                                          'g06chmkk' /* Continue Form */,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmallFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBtnText,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmallFamily),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if ((widget.taskStatus != 'completed') &&
                              (taskDetailsPpirFormsRow?.gpx == null ||
                                  taskDetailsPpirFormsRow?.gpx == ''))
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 8.0, 16.0, 12.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  currentUserLocationValue =
                                      await getCurrentUserLocation(
                                          defaultLocation: const LatLng(0.0, 0.0));
                                  await AttemptsTable().insert({
                                    'task_id': widget.taskId,
                                  });
                                  if (_model.isEditing!) {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      enableDrag: false,
                                      useSafeArea: true,
                                      context: context,
                                      builder: (context) {
                                        return GestureDetector(
                                          onTap: () => _model
                                                  .unfocusNode.canRequestFocus
                                              ? FocusScope.of(context)
                                                  .requestFocus(
                                                      _model.unfocusNode)
                                              : FocusScope.of(context)
                                                  .unfocus(),
                                          child: Padding(
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child: SizedBox(
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.1,
                                              child: const ToastWidget(
                                                notificationTitle: 'Fail',
                                                notificationMessage:
                                                    'You are still editing the farm location. Please finishi it first.',
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ).then((value) => safeSetState(() {}));
                                  } else {
                                    context.pushNamed(
                                      'geotagging',
                                      queryParameters: {
                                        'taskId': serializeParam(
                                          widget.taskId,
                                          ParamType.String,
                                        ),
                                        'taskType': serializeParam(
                                          containerTasksRow?.taskType,
                                          ParamType.String,
                                        ),
                                        'taskStatus': serializeParam(
                                          widget.taskStatus,
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
                                  }
                                },
                                child: Container(
                                  width: 300.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
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
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color:
                                          FlutterFlowTheme.of(context).accent1,
                                      width: 2.0,
                                    ),
                                  ),
                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Icon(
                                          Icons.map_outlined,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBtnText,
                                          size: 24.0,
                                        ),
                                      ),
                                      Text(
                                        FFLocalizations.of(context).getText(
                                          '63201k0m' /* Geotag */,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmallFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBtnText,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmallFamily),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (widget.taskStatus == 'completed')
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 8.0, 16.0, 12.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await TasksTable().update(
                                    data: {
                                      'status': 'ongoing',
                                    },
                                    matchingRows: (rows) => rows.eq(
                                      'id',
                                      widget.taskId,
                                    ),
                                  );
                                  await AttemptsTable().insert({
                                    'task_id': widget.taskId,
                                  });

                                  context.pushNamed(
                                    'geotagging',
                                    queryParameters: {
                                      'taskId': serializeParam(
                                        widget.taskId,
                                        ParamType.String,
                                      ),
                                      'taskType': serializeParam(
                                        containerTasksRow?.taskType,
                                        ParamType.String,
                                      ),
                                      'taskStatus': serializeParam(
                                        containerTasksRow?.status,
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
                                },
                                child: Container(
                                  width: 300.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
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
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color:
                                          FlutterFlowTheme.of(context).accent1,
                                      width: 2.0,
                                    ),
                                  ),
                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Icon(
                                          Icons.redo_sharp,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBtnText,
                                          size: 24.0,
                                        ),
                                      ),
                                      Text(
                                        FFLocalizations.of(context).getText(
                                          'm6egon7b' /* Resubmit */,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmallFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBtnText,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmallFamily),
                                            ),
                                      ),
                                    ],
                                  ),
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
          ),
        );
      },
    );
  }
}

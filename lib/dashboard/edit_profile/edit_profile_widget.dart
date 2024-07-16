import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/components/change_photo/change_photo_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'edit_profile_model.dart';
export 'edit_profile_model.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({super.key});

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  late EditProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditProfileModel());

    _model.displayNameFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.chevron_left,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 30.0,
          ),
          onPressed: () async {
            context.safePop();
          },
        ),
        title: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
          child: Text(
            FFLocalizations.of(context).getText(
              '5fv645iv' /* Edit Profile */,
            ),
            style: FlutterFlowTheme.of(context).displaySmall.override(
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  letterSpacing: 0.0,
                ),
          ),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: FutureBuilder<List<UsersRow>>(
          future: UsersTable().querySingleRow(
            queryFn: (q) => q.eq(
              'email',
              currentUserEmail,
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
            List<UsersRow> columnUsersRowList = snapshot.data!;

            final columnUsersRow =
                columnUsersRowList.isNotEmpty ? columnUsersRowList.first : null;
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: SizedBox(
                    height: 150.0,
                    child: Stack(
                      alignment: const AlignmentDirectional(1.0, 0.0),
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0.0, -0.13),
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  enableDrag: false,
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: const ChangePhotoWidget(),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 90.0,
                                    height: 90.0,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: CachedNetworkImage(
                                      fadeInDuration:
                                          const Duration(milliseconds: 300),
                                      fadeOutDuration:
                                          const Duration(milliseconds: 300),
                                      imageUrl: valueOrDefault<String>(
                                        columnUsersRow?.photoUrl,
                                        'https://newsko.com.ph/wp-content/uploads/2024/06/Mikha.jpg',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        60.0, 60.0, 0.0, 0.0),
                                    child: FlutterFlowIconButton(
                                      borderRadius: 20.0,
                                      borderWidth: 0.0,
                                      buttonSize: 40.0,
                                      fillColor:
                                          FlutterFlowTheme.of(context).primary,
                                      icon: const FaIcon(
                                        FontAwesomeIcons.solidEdit,
                                        color: Color(0xFFF1F4F8),
                                        size: 20.0,
                                      ),
                                      onPressed: () {
                                        print('IconButton pressed ...');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                  child: TextFormField(
                    controller: _model.displayNameTextController ??=
                        TextEditingController(
                      text: columnUsersRow?.displayName,
                    ),
                    focusNode: _model.displayNameFocusNode,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: FFLocalizations.of(context).getText(
                        'r9vm5mt1' /* Your Name */,
                      ),
                      labelStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
                                fontFamily: 'Raleway',
                                letterSpacing: 0.0,
                              ),
                      hintStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
                                fontFamily: 'Raleway',
                                letterSpacing: 0.0,
                              ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primary,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Raleway',
                          letterSpacing: 0.0,
                        ),
                    validator: _model.displayNameTextControllerValidator
                        .asValidator(context),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0.0, 0.05),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        await UsersTable().update(
                          data: {
                            'photo_url': columnUsersRow?.photoUrl,
                            'display_name': columnUsersRow?.displayName,
                          },
                          matchingRows: (rows) => rows,
                        );
                        await UserLogsTable().insert({
                          'user_id': currentUserUid,
                          'activity': 'Saving profile.',
                        });

                        context.pushNamed('success');
                      },
                      text: FFLocalizations.of(context).getText(
                        'ntj2ozhk' /* Save Changes */,
                      ),
                      options: FFButtonOptions(
                        width: 270.0,
                        height: 50.0,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        iconPadding:
                            const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Raleway',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                ),
                        elevation: 2.0,
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Ensure this import is correct
import 'package:p_c_i_c_mobile_app/components/image_view_widget.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

/// A custom sliding up panel widget that displays an image with a title and body text.
///
/// This widget uses the `sliding_up_panel` package to provide a sliding panel
/// that can be expanded or collapsed by the user.
class CustomSlidingUpPanel extends StatefulWidget {
  const CustomSlidingUpPanel({
    super.key,
    this.width,
    this.height,
    required this.title,
    required this.body,
    required this.taskId,
  });

  /// The width of the panel.
  final double? width;

  /// The height of the panel.
  final double? height;

  /// The title text displayed on the panel.
  final String title;

  /// The body text displayed on the panel.
  final String body;

  /// The task ID associated with the panel.
  final String taskId;

  @override
  State<CustomSlidingUpPanel> createState() => _CustomSlidingUpPanelState();
}

class _CustomSlidingUpPanelState extends State<CustomSlidingUpPanel> {
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      minHeight: MediaQuery.of(context).size.height * .08,
      maxHeight: MediaQuery.of(context).size.height * .70,
      panel: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          border: Border.all(
            color: FlutterFlowTheme.of(context).primary,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 15,
              left: MediaQuery.of(context).size.width * .40,
              right: MediaQuery.of(context).size.width * .40,
              child: Icon(
                Icons.maximize_outlined,
                color: FlutterFlowTheme.of(context).primary,
                size: 50,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * .1,
              right: 0,
              left: 0,
              child: ImageViewWidget(
                body: widget.body,
                taskId: widget.taskId,
                title: widget.title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

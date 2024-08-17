// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:typed_data';

class Signaturebase64 extends StatefulWidget {
  const Signaturebase64({
    super.key,
    this.width,
    this.height,
    this.taskId,
    this.signatureBlob,
  });

  final double? width;
  final double? height;
  final String? taskId;
  final String? signatureBlob;

  @override
  State<Signaturebase64> createState() => _Signaturebase64State();
}

class _Signaturebase64State extends State<Signaturebase64> {
  Uint8List? _signatureData;

  @override
  void initState() {
    super.initState();
    _loadSignature();
  }

  void _loadSignature() {
    if (widget.signatureBlob != null && widget.signatureBlob!.isNotEmpty) {
      setState(() {
        _signatureData = base64.decode(widget.signatureBlob!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 230,
      width: widget.width ?? double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _signatureData != null
            ? Image.memory(
                _signatureData!,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              )
            : SizedBox.shrink(),
      ),
    );
  }
}

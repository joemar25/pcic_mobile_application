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

class IndividualBlobImageLoader extends StatefulWidget {
  const IndividualBlobImageLoader({
    Key? key,
    this.width,
    this.height,
    this.imageBlob,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? imageBlob;

  @override
  State<IndividualBlobImageLoader> createState() =>
      _IndividualBlobImageLoaderState();
}

class _IndividualBlobImageLoaderState extends State<IndividualBlobImageLoader> {
  Uint8List? _decodedImageData;

  @override
  void initState() {
    super.initState();
    _decodeImage();
  }

  @override
  void didUpdateWidget(IndividualBlobImageLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageBlob != oldWidget.imageBlob) {
      _decodeImage();
    }
  }

  void _decodeImage() {
    if (widget.imageBlob != null && widget.imageBlob!.isNotEmpty) {
      try {
        setState(() {
          _decodedImageData = base64.decode(widget.imageBlob!);
        });
      } catch (e) {
        print('Error decoding image: $e');
        setState(() {
          _decodedImageData = null;
        });
      }
    } else {
      setState(() {
        _decodedImageData = null;
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
        child: _decodedImageData != null
            ? Image.memory(
                _decodedImageData!,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $error');
                  return const Center(child: Text('Failed to load image'));
                },
              )
            : const Center(child: Text('No image available')),
      ),
    );
  }
}

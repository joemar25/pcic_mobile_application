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

import 'package:signature/signature.dart';
import 'dart:typed_data';

class CustomSignature extends StatefulWidget {
  const CustomSignature({
    super.key,
    this.width,
    this.height,
    required this.taskId,
  });

  final double? width;
  final double? height;
  final String taskId;

  @override
  State<CustomSignature> createState() => _CustomSignatureState();
}

class _CustomSignatureState extends State<CustomSignature> {
  late SignatureController _controller;
  Uint8List? _signatureData;
  String? _fileName;

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveSignature() async {
    if (_controller.isNotEmpty) {
      try {
        _signatureData = await _controller.toPngBytes();
        if (_signatureData != null) {
          _fileName = 'signature_${DateTime.now().millisecondsSinceEpoch}.png';
          final String folderPath = 'PPIR_${widget.taskId}';

          await Supabase.instance.client.storage
              .from('signature')
              .uploadBinary('$folderPath/$_fileName', _signatureData!);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signature saved successfully')),
          );

          final String publicUrl = Supabase.instance.client.storage
              .from('signature')
              .getPublicUrl('$folderPath/$_fileName');

          print('Signature URL: $publicUrl');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred while saving: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please draw a signature before saving')),
      );
    }
  }

  Future<void> _clearSignature() async {
    _controller.clear();
    if (_fileName != null) {
      final String folderPath = 'PPIR_${widget.taskId}';
      try {
        await Supabase.instance.client.storage
            .from('signature')
            .remove(['$folderPath/$_fileName']);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Signature cleared and deleted from storage')),
        );
        _fileName = null;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred while deleting: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No signature file to delete')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 230,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Signature(
            controller: _controller,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _clearSignature,
              child: const Text('Clear'),
            ),
            ElevatedButton(
              onPressed: _saveSignature,
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}

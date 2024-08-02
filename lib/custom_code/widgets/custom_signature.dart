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
    this.taskId,
  });

  final double? width;
  final double? height;
  final String? taskId;

  @override
  State<CustomSignature> createState() => _CustomSignatureState();
}

class _CustomSignatureState extends State<CustomSignature> {
  late final SignatureController _controller;
  bool _isSaving = false;

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
    if (_controller.isEmpty) {
      _showSnackBar('Please draw a signature before saving');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final Uint8List? signatureData = await _controller.toPngBytes();
      if (signatureData == null)
        throw Exception('Failed to get signature data');

      final String fileName =
          'signature_${DateTime.now().millisecondsSinceEpoch}.png';

      await Supabase.instance.client.storage
          .from('signature')
          .uploadBinary(fileName, signatureData);

      final String publicUrl = Supabase.instance.client.storage
          .from('signature')
          .getPublicUrl(fileName);

      _showSnackBar('Signature saved successfully');
      print('Signature URL: $publicUrl');
    } catch (e) {
      _showSnackBar('An error occurred: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? 300,
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
              onPressed: _controller.clear,
              child: const Text('Clear'),
            ),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveSignature,
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}

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
    this.signatureFor,
  });

  final double? width;
  final double? height;
  final String? taskId;
  final String? signatureFor;

  @override
  State<Signaturebase64> createState() => _Signaturebase64State();
}

class _Signaturebase64State extends State<Signaturebase64> {
  Uint8List? _signatureData;
  String _statusMessage = '';
  bool _isLoading = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    debugPrint('Signaturebase64: initState called');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadExistingSignature();
      }
    });
  }

  void setStateIfMounted(VoidCallback fn) {
    if (mounted && !_isDisposed) setState(fn);
  }

  Future<void> _loadExistingSignature() async {
    debugPrint('Signaturebase64: Loading existing signature');
    if (_isDisposed) return;
    setStateIfMounted(() => _isLoading = true);
    try {
      if (!FFAppState().ONLINE) {
        throw Exception('No internet connection');
      }

      final response = await SupaFlow.client
          .from('ppir_forms')
          .select(widget.signatureFor == 'insured'
              ? 'ppir_sig_insured'
              : 'ppir_sig_iuia')
          .eq('task_id', widget.taskId)
          .single()
          .execute();

      if (_isDisposed) return;

      if (response.status == 200 && response.data != null) {
        final signatureBlob = response.data[widget.signatureFor == 'insured'
            ? 'ppir_sig_insured'
            : 'ppir_sig_iuia'] as String?;
        if (signatureBlob != null) {
          setStateIfMounted(() {
            _signatureData = base64.decode(signatureBlob);
            _statusMessage = 'Signature loaded';
          });
        } else {
          setStateIfMounted(() {
            _statusMessage = 'No signature found';
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading existing signature: $e');
      setStateIfMounted(() {
        _statusMessage = 'Failed to load signature: ${e.toString()}';
      });
    } finally {
      setStateIfMounted(() => _isLoading = false);
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
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_signatureData != null)
              Image.memory(
                _signatureData!,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              )
            else
              Center(child: Text('No signature available')),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  _statusMessage,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('Signaturebase64: dispose called');
    _isDisposed = true;
    super.dispose();
  }
}

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

import 'index.dart'; // Imports other custom widgets

import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';

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
          _fileName =
              'signature_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.png';

          // Query the tasks table to get service_group and task_number
          final taskResponse = await SupaFlow.client
              .from('tasks')
              .select('service_group, task_number, assignee')
              .eq('id', widget.taskId)
              .single()
              .execute();

          if (taskResponse.status != 200 || taskResponse.data == null) {
            throw Exception(
                'Error querying tasks table: ${taskResponse.status}');
          }

          final taskData = taskResponse.data as Map<String, dynamic>;
          final String serviceGroup = taskData['service_group'] ?? '';
          final String taskNumber = taskData['task_number'] ?? '';

          // Get the current user's email
          final currentUser = SupaFlow.client.auth.currentUser;
          final String userEmail =
              currentUser?.email ?? taskData['assignee'] ?? '';

          if (userEmail.isEmpty) {
            throw Exception('Unable to get user email');
          }

          // Define the file path in the bucket
          final filePath =
              '$serviceGroup/$userEmail/$taskNumber/attachments/$_fileName';

          // Upload the signature file to Supabase storage
          final response =
              await SupaFlow.client.storage.from('for_ftp').uploadBinary(
                    filePath,
                    _signatureData!,
                    fileOptions: FileOptions(
                      contentType: 'image/png',
                      upsert: true,
                    ),
                  );

          if (response != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Signature saved successfully')),
            );

            final String publicUrl =
                SupaFlow.client.storage.from('for_ftp').getPublicUrl(filePath);

            print('Signature URL: $publicUrl');

            // Update the ppir_forms table with the signature file path
            await SupaFlow.client.from('ppir_forms').update({
              'signature_file_path': filePath,
            }).eq('task_id', widget.taskId);

            print('ppir_forms table updated with signature file path');
          } else {
            throw Exception('Error uploading signature file');
          }
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
      try {
        // Query the tasks table to get service_group and task_number
        final taskResponse = await SupaFlow.client
            .from('tasks')
            .select('service_group, task_number, assignee')
            .eq('id', widget.taskId)
            .single()
            .execute();

        if (taskResponse.status != 200 || taskResponse.data == null) {
          throw Exception('Error querying tasks table: ${taskResponse.status}');
        }

        final taskData = taskResponse.data as Map<String, dynamic>;
        final String serviceGroup = taskData['service_group'] ?? '';
        final String taskNumber = taskData['task_number'] ?? '';

        // Get the current user's email
        final currentUser = SupaFlow.client.auth.currentUser;
        final String userEmail =
            currentUser?.email ?? taskData['assignee'] ?? '';

        if (userEmail.isEmpty) {
          throw Exception('Unable to get user email');
        }

        final filePath =
            '$serviceGroup/$userEmail/$taskNumber/attachments/$_fileName';

        await SupaFlow.client.storage.from('for_ftp').remove([filePath]);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Signature cleared and deleted from storage')),
        );
        _fileName = null;

        // Update the ppir_forms table to remove the signature file path
        await SupaFlow.client.from('ppir_forms').update({
          'signature_file_path': null,
        }).eq('task_id', widget.taskId);

        print('ppir_forms table updated to remove signature file path');
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

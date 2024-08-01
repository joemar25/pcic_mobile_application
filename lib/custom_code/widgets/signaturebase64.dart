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

// class Signaturebase64 extends StatefulWidget {
//   const Signaturebase64({
//     super.key,
//     this.width,
//     this.height,
//     this.blob,
//   });

//   final double? width;
//   final double? height;
//   final String? blob;

//   @override
//   State<Signaturebase64> createState() => _Signaturebase64State();
// }

// class _Signaturebase64State extends State<Signaturebase64> {
//   List<String> _imageUrls = [];

//   @override
//   void initState() {
//     super.initState();
//     if (widget.blob != null) {
//       _decodeBase64Images(widget.blob!);
//     }
//   }

//   void _decodeBase64Images(String base64Data) {
//     try {
//       // Split the base64 data in case multiple images are passed
//       final base64Strings = base64Data.split(',');
//       setState(() {
//         _imageUrls = base64Strings
//             .map((base64String) => 'data:image/png;base64,$base64String')
//             .toList();
//       });
//     } catch (e) {
//       print('Error decoding base64 images: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: widget.width,
//       height: widget.height,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: _imageUrls.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Image.network(
//               _imageUrls[index],
//               fit: BoxFit.cover,
//               width: widget.width,
//               height: widget.height,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// mar is updating this
import 'dart:convert';

class Signaturebase64 extends StatefulWidget {
  const Signaturebase64({
    Key? key,
    this.width,
    this.height,
    this.blob,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? blob;

  @override
  State<Signaturebase64> createState() => _Signaturebase64State();
}

class _Signaturebase64State extends State<Signaturebase64> {
  List<Uint8List> _imageData = [];

  @override
  void initState() {
    super.initState();
    if (widget.blob != null) {
      _decodeBase64Images(widget.blob!);
    }
  }

  void _decodeBase64Images(String base64Data) {
    try {
      // Split the base64 data in case multiple images are passed
      final base64Strings = base64Data.split(',');
      setState(() {
        _imageData = base64Strings
            .map((base64String) => base64Decode(base64String.trim()))
            .toList();
      });
    } catch (e) {
      print('Error decoding base64 images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _imageData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.memory(
              _imageData[index],
              fit: BoxFit.cover,
              width: widget.width,
              height: widget.height,
            ),
          );
        },
      ),
    );
  }
}

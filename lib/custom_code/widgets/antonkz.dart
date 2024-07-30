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

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:xml/xml.dart';
import 'dart:convert';

class Antonkz extends StatefulWidget {
  const Antonkz({
    super.key,
    this.width,
    this.height,
    this.blob,
  });

  final double? width;
  final double? height;
  final String? blob;

  @override
  State<Antonkz> createState() => _AntonkzState();
}

class _AntonkzState extends State<Antonkz> {
  List<latlong.LatLng> _coordinates = []; // Use type aliasing

  @override
  void initState() {
    super.initState();
    if (widget.blob != null) {
      _parseGPX(widget.blob!);
    }
  }

  void _parseGPX(String base64Data) {
    try {
      // Decode the base64 string to get the GPX data
      final decodedBytes = base64Decode(base64Data);
      final gpxString = utf8.decode(decodedBytes);

      // Parse the GPX data using the xml package
      final document = XmlDocument.parse(gpxString);
      final trkpts = document.findAllElements('trkpt');

      List<latlong.LatLng> coordinates = [];

      for (var trkpt in trkpts) {
        final lat = double.parse(trkpt.getAttribute('lat')!);
        final lon = double.parse(trkpt.getAttribute('lon')!);
        coordinates.add(latlong.LatLng(lat, lon));
      }

      setState(() {
        _coordinates = coordinates;
      });
    } catch (e) {
      print('Error parsing GPX data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: _coordinates.isNotEmpty
              ? _coordinates.first
              : latlong.LatLng(0, 0),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: _coordinates,
                strokeWidth: 4.0,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:xml/xml.dart';
import 'dart:convert';
import 'package:flutter_map/plugin_api.dart';

class MapBase64 extends StatefulWidget {
  const MapBase64({
    super.key,
    this.width,
    this.height,
    this.blob,
    required this.accessToken,
  });

  final double? width;
  final double? height;
  final String? blob;
  final String accessToken;

  @override
  State<MapBase64> createState() => _MapBase64State();
}

class _MapBase64State extends State<MapBase64> {
  List<latlong.LatLng> _coordinates = [];
  late final MapController _mapController;
  final NetworkTileProvider _tileProvider = NetworkTileProvider();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    if (widget.blob != null) {
      _parseGPX(widget.blob!);
    }
  }

  void _parseGPX(String base64Data) {
    try {
      final decodedBytes = base64Decode(base64Data);
      final gpxString = utf8.decode(decodedBytes);

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

      WidgetsBinding.instance.addPostFrameCallback((_) => _fitBounds());
    } catch (e) {
      print('Error parsing GPX data: $e');
    }
  }

  void _fitBounds() {
    if (_coordinates.isNotEmpty) {
      final bounds = LatLngBounds.fromPoints(_coordinates);
      _mapController.fitBounds(
        bounds,
        options: FitBoundsOptions(padding: EdgeInsets.all(50.0)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _coordinates.isNotEmpty
              ? _coordinates.first
              : latlong.LatLng(0, 0),
          initialZoom: 13.0,
          interactionOptions: InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}@2x?access_token=${widget.accessToken}',
            additionalOptions: {
              'accessToken': widget.accessToken,
            },
            tileProvider: _tileProvider,
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

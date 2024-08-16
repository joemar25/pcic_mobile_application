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
import 'dart:math' as math;

class MapBase64 extends StatefulWidget {
  const MapBase64({
    Key? key,
    this.width,
    this.height,
    this.blob,
    required this.accessToken,
  }) : super(key: key);

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
  double _currentZoom = 18.0;

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
      final document = XmlDocument.parse(utf8.decode(base64Decode(base64Data)));
      _coordinates = document.findAllElements('trkpt').map((trkpt) {
        return latlong.LatLng(
          double.parse(trkpt.getAttribute('lat')!),
          double.parse(trkpt.getAttribute('lon')!),
        );
      }).toList();

      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) => _centerMap());
    } catch (e) {
      print('Error parsing GPX data: $e');
    }
  }

  void _centerMap() {
    if (_coordinates.isNotEmpty) {
      final bounds = _calculateBounds(_coordinates);
      final centerLat = (bounds[0] + bounds[2]) / 2;
      final centerLon = (bounds[1] + bounds[3]) / 2;
      _currentZoom = _calculateZoom(bounds);
      _mapController.move(latlong.LatLng(centerLat, centerLon), _currentZoom);
    }
  }

  List<double> _calculateBounds(List<latlong.LatLng> points) {
    return points.fold(
        [double.infinity, double.infinity, -double.infinity, -double.infinity],
        (List<double> bounds, latlong.LatLng point) {
      return [
        math.min(bounds[0], point.latitude),
        math.min(bounds[1], point.longitude),
        math.max(bounds[2], point.latitude),
        math.max(bounds[3], point.longitude),
      ];
    });
  }

  double _calculateZoom(List<double> bounds) {
    const WORLD_PX = 256.0;
    const ZOOM_MAX = 21.0;
    const ZOOM_MIN = 0.0;

    final latFraction = (bounds[2] - bounds[0]) / 360.0;
    final lonFraction = (bounds[3] - bounds[1]) / 360.0;

    final latZoom = math.log(WORLD_PX / latFraction) / math.ln2;
    final lonZoom = math.log(WORLD_PX / lonFraction) / math.ln2;

    return math.min(latZoom, lonZoom).clamp(ZOOM_MIN, ZOOM_MAX);
  }

  void _zoomIn() {
    _currentZoom = math.min(_currentZoom + 1, 21);
    _mapController.move(_mapController.camera.center, _currentZoom);
  }

  void _zoomOut() {
    _currentZoom = math.max(_currentZoom - 1, 0);
    _mapController.move(_mapController.camera.center, _currentZoom);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _coordinates.isNotEmpty
                  ? _coordinates.first
                  : latlong.LatLng(0, 0),
              initialZoom: _currentZoom,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}@2x?access_token=${widget.accessToken}',
                additionalOptions: {'accessToken': widget.accessToken},
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
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: Column(
            children: [
              FloatingActionButton(
                mini: true,
                child: Icon(Icons.add),
                onPressed: _zoomIn,
              ),
              SizedBox(height: 8),
              FloatingActionButton(
                mini: true,
                child: Icon(Icons.remove),
                onPressed: _zoomOut,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

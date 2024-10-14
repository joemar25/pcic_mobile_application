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
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class GeoJson extends StatefulWidget {
  const GeoJson({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<GeoJson> createState() => _GeoJsonState();
}

class _GeoJsonState extends State<GeoJson> {
  late GeoJsonParser _geoJsonParser;

  @override
  void initState() {
    super.initState();
    _geoJsonParser = GeoJsonParser();
    _loadGeoJson();
  }

  Future<void> _loadGeoJson() async {
    try {
      print('DEBUG: Attempting to load GeoJSON file...');
      final String geoJsonString = await rootBundle
          .loadString('assets/jsons/philippines-with-regions.json');
      print('DEBUG: GeoJSON file loaded successfully.');

      print('DEBUG: Parsing GeoJSON data...');

      // Parse the JSON manually to handle type casting
      final jsonData = json.decode(geoJsonString);
      final features = jsonData['features'] as List;

      for (var feature in features) {
        if (feature['geometry']['type'] == 'MultiPolygon') {
          var coordinates = feature['geometry']['coordinates'] as List;
          _processMultiPolygon(coordinates);
        }
        // Add more conditions here for other geometry types if needed
      }

      print('DEBUG: GeoJSON data parsed successfully.');
      print('DEBUG: Number of polygons: ${_geoJsonParser.polygons.length}');
      print('DEBUG: Number of polylines: ${_geoJsonParser.polylines.length}');
      print('DEBUG: Number of markers: ${_geoJsonParser.markers.length}');

      setState(() {});
      print('DEBUG: Widget state updated.');
    } catch (e) {
      print('DEBUG: Error loading or parsing GeoJSON: $e');
    }
  }

  void _processMultiPolygon(List coordinates) {
    for (var polygon in coordinates) {
      for (var ring in polygon) {
        List<latlong2.LatLng> points = [];
        for (var coord in ring) {
          double lat =
              (coord[1] is int) ? (coord[1] as int).toDouble() : coord[1];
          double lng =
              (coord[0] is int) ? (coord[0] as int).toDouble() : coord[0];
          points.add(latlong2.LatLng(lat, lng));
        }
        _geoJsonParser.polygons.add(Polygon(
          points: points,
          color: Colors.blue.withOpacity(0.3),
          borderColor: Colors.blue,
          borderStrokeWidth: 2,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 400,
      child: FlutterMap(
        options: MapOptions(
          initialCenter:
              latlong2.LatLng(12.8797, 121.7740), // Center of Philippines
          initialZoom: 6, // Adjusted to show more of the Philippines
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.app',
          ),
          PolygonLayer(polygons: _geoJsonParser.polygons),
          PolylineLayer(polylines: _geoJsonParser.polylines),
          MarkerLayer(markers: _geoJsonParser.markers),
        ],
      ),
    );
  }
}

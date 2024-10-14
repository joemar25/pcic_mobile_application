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
      // Load the GeoJSON data from the asset
      print('DEBUG: Attempting to load GeoJSON file...');
      final String geoJsonString = await rootBundle
          .loadString('assets/lottie_animations/philippines-with-regions.json');
      print('DEBUG: GeoJSON file loaded successfully.');

      // Parse the GeoJSON data
      print('DEBUG: Parsing GeoJSON data...');
      _geoJsonParser.parseGeoJsonAsString(geoJsonString);
      print('DEBUG: GeoJSON data parsed successfully.');

      // Print some information about the parsed data
      print('DEBUG: Number of polygons: ${_geoJsonParser.polygons.length}');
      print('DEBUG: Number of polylines: ${_geoJsonParser.polylines.length}');
      print('DEBUG: Number of markers: ${_geoJsonParser.markers.length}');

      setState(() {});
      print('DEBUG: Widget state updated.');
    } catch (e) {
      print('DEBUG: Error loading or parsing GeoJSON: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 400,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: latlong2.LatLng(14.60905, 121.02226),
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          PolygonLayer(polygons: _geoJsonParser.polygons),
          PolylineLayer(polylines: _geoJsonParser.polylines),
          MarkerLayer(markers: _geoJsonParser.markers),
        ],
      ),
    );
  }
}

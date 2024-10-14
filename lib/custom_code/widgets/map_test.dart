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

class MapTest extends StatefulWidget {
  const MapTest({
    super.key,
    this.width,
    this.height,
    this.accessToken,
  });

  final double? width;
  final double? height;
  final String? accessToken;

  @override
  State<MapTest> createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/*
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';

class MapTest extends StatefulWidget {
  const MapTest({
    Key? key,
    this.width,
    this.height,
    this.accessToken,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? accessToken;

  @override
  State<MapTest> createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: FlutterMap(
        options: MapOptions(
          center: LatLng(13.4215, 123.4437),
          zoom: 8,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}@2x?access_token=${widget.accessToken}',
            additionalOptions: {
              'accessToken': widget.accessToken ?? '',
            },
          ),
          PolygonLayer(
            polygons: [
              Polygon(
                points: _convertCoordinates(),
                color: Colors.blue.withOpacity(0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<LatLng> _convertCoordinates() {
    const String geoJsonString = '''
    {
      "type": "Feature",
      "properties": {
        "name": "Region V (Bicol Region)"
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [124.0785, 13.6606],
            [123.9723, 13.8899],
            [123.7547, 13.3236],
            [123.6592, 13.5259],
            [123.5306, 13.5759],
            [123.5855, 13.4404],
            [123.5816, 13.3966],
            [123.4129, 13.3469],
            [123.2669, 13.4341],
            [123.1886, 13.4341],
            [122.8873, 13.5766],
            [122.7982, 13.6505],
            [122.8614, 13.6903],
            [122.8358, 13.7349],
            [122.7423, 13.7771],
            [122.7779, 13.7871],
            [122.7264, 13.8203],
            [122.6535, 13.8206],
            [122.6399, 13.883],
            [122.5669, 13.9051],
            [122.5853, 13.9258],
            [122.5547, 13.9217],
            [122.5483, 13.9495],
            [122.7926, 14.0145],
            [123.0592, 13.8371],
            [123.0479, 13.774],
            [123.1229, 13.7264],
            [123.2301, 13.7298],
            [123.3218, 13.8014],
            [123.3286, 13.7853],
            [123.2842, 13.8965],
            [123.3325, 13.9393],
            [123.3411, 13.9715],
            [123.2939, 13.927],
            [123.265, 13.9622],
            [123.2321, 13.968],
            [123.2286, 14.0034],
            [123.2642, 14.0133],
            [123.2311, 14.0253],
            [123.2872, 14.0317],
            [123.2576, 14.0736],
            [123.3178, 14.0344],
            [123.3086, 14.0675],
            [123.3467, 14.0686],
            [123.3286, 14.0908],
            [123.3414, 14.1056],
            [123.3744, 14.0411],
            [123.3528, 14.0386],
            [123.3433, 14.0136],
            [123.388, 14.0351],
            [123.3939, 13.987],
            [123.4162, 13.9844],
            [123.4296, 13.9148],
            [123.4165, 13.8858],
            [123.4563, 13.9329],
            [123.4483, 13.9701],
            [123.5018, 13.941],
            [123.4895, 13.9127],
            [123.5165, 13.9303],
            [123.5427, 13.9088],
            [123.5447, 13.9329],
            [123.5669, 13.9019],
            [123.6797, 13.8777],
            [123.7141, 13.8833],
            [123.7076, 13.943],
            [123.7816, 13.8604],
            [123.7756, 13.8505],
            [123.8475, 13.8107],
            [123.8671, 13.8257],
            [123.9417, 13.7954],
            [123.9484, 13.7539],
            [123.9755, 13.7399],
            [123.9692, 13.7087],
            [123.8732, 13.7375],
            [123.8023, 13.6877],
            [123.56, 13.7359],
            [123.5839, 13.7235],
            [123.5304, 13.5759],
            [123.6021, 13.5282],
            [123.5431, 13.5042],
            [123.5855, 13.4404],
            [123.5816, 13.3966],
            [123.4129, 13.3469],
            [124.0785, 13.6606]
          ]
        ]
      }
    }
    ''';

    final geoJson = json.decode(geoJsonString);
    final coordinates = geoJson['geometry']['coordinates'][0] as List<dynamic>;

    return coordinates.map((coord) {
      return LatLng(coord[1] as double, coord[0] as double);
    }).toList();
  }
}

*/

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
import 'package:latlong2/latlong.dart' as ll;

class MapangMakabayan extends StatefulWidget {
  const MapangMakabayan({
    super.key,
    this.width,
    this.height,
    this.accessToken,
  });

  final double? width;
  final double? height;
  final String? accessToken;

  @override
  State<MapangMakabayan> createState() => _MapangMakabayanState();
}

class _MapangMakabayanState extends State<MapangMakabayan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? MediaQuery.of(context).size.height,
      child: FlutterMap(
        options: MapOptions(
          center:
              ll.LatLng(14.5995, 120.9842), // Default to Manila, Philippines
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: {
              'accessToken':
                  widget.accessToken ?? 'default_mapbox_access_token_here',
            },
          ),
        ],
      ),
    );
  }
}

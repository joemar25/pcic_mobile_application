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
import 'package:geolocator/geolocator.dart';

class MapangMakabayan extends StatefulWidget {
  const MapangMakabayan({
    super.key,
    this.width,
    this.height,
    this.accessToken,
    this.userCurrentLocation,
  });

  final double? width;
  final double? height;
  final String? accessToken;
  final LatLng? userCurrentLocation;

  @override
  State<MapangMakabayan> createState() => _MapangMakabayanState();
}

class _MapangMakabayanState extends State<MapangMakabayan> {
  ll.LatLng? currentLocation;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    if (widget.userCurrentLocation != null) {
      currentLocation = ll.LatLng(widget.userCurrentLocation!.latitude,
          widget.userCurrentLocation!.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? MediaQuery.of(context).size.height,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: currentLocation ??
              ll.LatLng(0, 0), // Default to (0,0) if no location provided
          initialZoom: 17.0, // Closer zoom level
          maxZoom: 19.0, // Set a maximum zoom level
          minZoom: 2.0, // Set a minimum zoom level if needed
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: {
              'accessToken':
                  widget.accessToken ?? 'your_default_mapbox_access_token_here',
            },
          ),
          if (currentLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: currentLocation!,
                  width: 80.0,
                  height: 80.0,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

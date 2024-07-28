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

import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:geolocator/geolocator.dart';

class MapangMakabayan extends StatefulWidget {
  const MapangMakabayan({
    Key? key,
    this.width,
    this.height,
    this.accessToken,
    this.userCurrentLocation,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? accessToken;
  final ll.LatLng? userCurrentLocation;

  @override
  _MapangMakabayanState createState() => _MapangMakabayanState();
}

class _MapangMakabayanState extends State<MapangMakabayan> {
  ll.LatLng? currentLocation;
  final List<ll.LatLng> route = [];
  final MapController _mapController = MapController();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    checkPermissions().then((_) {
      getCurrentLocation();
      timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
        getCurrentLocation();
      });
    });
  }

  Future<void> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }
  }

  void getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      setState(() {
        currentLocation = ll.LatLng(position.latitude, position.longitude);
      });

      if (currentLocation != null) {
        _mapController.move(currentLocation!, 15.0);
      }

      Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 1,
        ),
      ).listen((Position position) {
        ll.LatLng newPosition =
            ll.LatLng(position.latitude, position.longitude);
        if (mounted) {
          setState(() {
            currentLocation = newPosition;
            if (FFAppState().routeStarted) {
              route.add(newPosition);
            }
          });
          _mapController.move(newPosition, 15.0);
        }
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocation == null) {
      return SizedBox(
        width: widget.width ?? MediaQuery.of(context).size.width,
        height: widget.height ?? MediaQuery.of(context).size.height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? MediaQuery.of(context).size.height,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: currentLocation!,
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: {
              'accessToken': widget.accessToken ?? '',
            },
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: currentLocation!,
                width: 80.0,
                height: 80.0,
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ],
          ),
          if (route.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: route,
                  strokeWidth: 4.0,
                  color: Colors.red,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

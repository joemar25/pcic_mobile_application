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
  final List<ll.LatLng> route = [];
  bool clearRoute = false;
  final MapController _mapController = MapController();
  Timer? timer;

  Future<bool> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location is not enabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location is not enabled.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location is not enabled.');
    }
    return true;
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLocation = ll.LatLng(position.latitude, position.longitude);
    });
    _mapController.move(currentLocation!, 15);

    Geolocator.getPositionStream(
            locationSettings: LocationSettings(
                accuracy: LocationAccuracy.best, distanceFilter: 3))
        .listen((Position position) {
      ll.LatLng newPosition = ll.LatLng(position.latitude, position.longitude);
      if (mounted) {
        setState(() {
          currentLocation = newPosition;
          if (FFAppState().routeStarted) {
            if (clearRoute) {
              route.clear();
              clearRoute = false;
            }
            route.add(newPosition);
          } else {
            if (!clearRoute) {
              clearRoute = true;
            }
          }
        });
        _mapController.move(newPosition, _mapController.zoom);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkPermissions().then((permissionAccepted) {
      if (permissionAccepted) {
        timer = Timer.periodic(Duration(seconds: 2), (Timer t) {});

        getCurrentLocation();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocation == null) {
      return Container(
        width: widget.width ?? MediaQuery.of(context).size.width,
        height: widget.height ?? MediaQuery.of(context).size.height,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Stack(
      children: [
        Container(
          width: widget.width ?? MediaQuery.of(context).size.width,
          height: widget.height ?? MediaQuery.of(context).size.height,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: currentLocation!,
              zoom: 15.0,
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
                    width: 80.0,
                    height: 80.0,
                    point: currentLocation!,
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
                      color: Colors.blue,
                    ),
                  ],
                ),
            ],
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.white.withOpacity(0.8),
              child: Text(
                'Lat: ${currentLocation!.latitude.toStringAsFixed(6)}\nLng: ${currentLocation!.longitude.toStringAsFixed(6)}',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

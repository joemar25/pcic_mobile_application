// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;

class GeotagMap extends StatefulWidget {
  const GeotagMap({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<GeotagMap> createState() => _GeotagMapState();
}

class _GeotagMapState extends State<GeotagMap> {
  // mga barya-balls
  ll.LatLng? currentLocation;

  final List<ll.LatLng> route = [];
  final MapController _mapController = MapController();

  Timer? timer;
  bool clearRoute = false;

  Future<bool> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location Permission Denied');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location Permission Denied');
    }
    return true;
  }

  void getCurrentLocation() async {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,

        // this code will only update when a user travels a certain distance
        // this is a 3 word meters
        distanceFilter: 3,
      ),
    ).listen((Position position) {
      ll.LatLng newPosition = ll.LatLng(position.latitude, position.longitude);

      if (mounted) {
        setState(() => currentLocation = newPosition);

        if (FFAppState().routeStarted) {
          if (clearRoute) {
            setState(() {
              route.clear();
              clearRoute = false;
            });
          }

          setState(() {
            route.add(newPosition);
          });

          // ibalik si user sa dating position pag nag move ng map kung sakali pag naga update ki location
          _mapController.move(newPosition, 13);
        } else {
          if (!clearRoute) {
            setState(() {
              clearRoute = true;
            });
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkPermissions().then((permissionAccepted) {
      if (permissionAccepted) {
        timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
          // taga kuha ng current location
          getCurrentLocation();
        });
      }
    });
  }

  // imbis maali si timer unused chuchuness iooveride ta
  @override
  void dispose() {
    super.dispose();
    timer?.cancel;
  }

  @override
  Widget build(BuildContext context) {
    return currentLocation == null
        ? Center(child: CircularProgressIndicator())
        : FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: currentLocation!,
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80,
                    height: 80,
                    point: currentLocation!,
                    child: Icon(
                      Icons.circle_rounded,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: route,
                    strokeWidth: 8,
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          );
  }
}

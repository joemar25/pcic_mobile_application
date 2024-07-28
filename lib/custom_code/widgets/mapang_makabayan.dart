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
import 'dart:math' show cos, sqrt, asin, pi;

class MapangMakabayan extends StatefulWidget {
  final double? width;
  final double? height;
  final String? accessToken;

  const MapangMakabayan({Key? key, this.width, this.height, this.accessToken})
      : super(key: key);

  @override
  _MapangMakabayanState createState() => _MapangMakabayanState();
}

class _MapangMakabayanState extends State<MapangMakabayan> {
  ll.LatLng? currentLocation;
  bool locationLoaded = false;
  List<ll.LatLng> route = [];
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionSubscription;
  final double _minDistanceFilter = 3.0; // 3 meters
  final double _minTurnAngle = 20.0; // Minimum angle to consider as a turn
  ll.LatLng? _lastValidLocation;
  double _currentZoom = 18.0;

  @override
  void initState() {
    super.initState();
    checkPermissions().then((hasPermission) {
      if (hasPermission) {
        getCurrentLocation();
        trackMovement();
      }
    });
  }

  Future<bool> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return false;
    }

    return true;
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      setState(() {
        currentLocation = ll.LatLng(position.latitude, position.longitude);
        _lastValidLocation = currentLocation;
        locationLoaded = true;
        route.add(currentLocation!);
      });
      _mapController.move(currentLocation!, _currentZoom);
      print(
          "Initial location set: ${currentLocation!.latitude}, ${currentLocation!.longitude}");
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void trackMovement() {
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      _updateLocation(position);
    });
  }

  void _updateLocation(Position position) {
    final newLocation = ll.LatLng(position.latitude, position.longitude);

    if (_lastValidLocation != null) {
      final distance = calculateDistance(_lastValidLocation!, newLocation);
      print("Distance moved: $distance meters");

      if (distance >= _minDistanceFilter) {
        bool shouldAddPoint = true;

        if (route.length >= 2) {
          final lastPoint = route[route.length - 1];
          final secondLastPoint = route[route.length - 2];

          final angle = calculateAngle(secondLastPoint, lastPoint, newLocation);
          print("Turn angle: $angle degrees");

          if (angle < _minTurnAngle) {
            // If the turn is not significant, update the last point instead of adding a new one
            shouldAddPoint = false;
            route[route.length - 1] = newLocation;
          }
        }

        if (shouldAddPoint) {
          setState(() {
            route.add(newLocation);
          });
          print("New point added. Total points: ${route.length}");
        }

        setState(() {
          currentLocation = newLocation;
          _lastValidLocation = newLocation;
          _mapController.move(newLocation, _currentZoom);
        });

        print(
            "New location: ${newLocation.latitude}, ${newLocation.longitude}");
      }
    } else {
      setState(() {
        currentLocation = newLocation;
        _lastValidLocation = newLocation;
        route.add(newLocation);

        _mapController.move(newLocation, _currentZoom);
      });
      print("First point added. Total points: ${route.length}");
    }
  }

  double calculateDistance(ll.LatLng start, ll.LatLng end) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((end.latitude - start.latitude) * p) / 2 +
        c(start.latitude * p) *
            c(end.latitude * p) *
            (1 - c((end.longitude - start.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a)) * 1000; // 2 * R; R = 6371 km
  }

  double calculateAngle(ll.LatLng p1, ll.LatLng p2, ll.LatLng p3) {
    final vector1 =
        ll.LatLng(p2.latitude - p1.latitude, p2.longitude - p1.longitude);
    final vector2 =
        ll.LatLng(p3.latitude - p2.latitude, p3.longitude - p2.longitude);

    final dot = vector1.latitude * vector2.latitude +
        vector1.longitude * vector2.longitude;
    final mag1 = sqrt(vector1.latitude * vector1.latitude +
        vector1.longitude * vector1.longitude);
    final mag2 = sqrt(vector2.latitude * vector2.latitude +
        vector2.longitude * vector2.longitude);

    final cosAngle = dot / (mag1 * mag2);
    return asin(cosAngle) * (180 / pi); // Convert to degrees
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!locationLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: currentLocation!,
              initialZoom: _currentZoom,
              maxZoom: 23.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/quanbysolutions/cluhoxol502q801oi8od2cmvz/tiles/{z}/{x}/{y}?access_token={accessToken}',
                additionalOptions: {
                  'accessToken': widget.accessToken ??
                      'your_default_mapbox_access_token_here',
                },
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: route,
                    strokeWidth: 4.0,
                    color: Colors.blue,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: currentLocation!,
                    width: 20.0,
                    height: 20.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              color: Colors.white.withOpacity(0.7),
              padding: EdgeInsets.all(8),
              child: Text(
                'Points: ${route.length}\n'
                'Current: ${currentLocation?.latitude.toStringAsFixed(6)}, ${currentLocation?.longitude.toStringAsFixed(6)}',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

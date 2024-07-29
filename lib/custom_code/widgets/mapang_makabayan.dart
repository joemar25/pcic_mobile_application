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
  final double _minDistanceFilter =
      1.0; // 1 meter for balance between accuracy and smoothness
  ll.LatLng? _lastValidLocation;
  double _currentZoom = 19.0;
  bool _isTracking = false;
  List<ll.LatLng> pinDrops = [];
  List<Position> _recentPositions = [];
  final int _smoothingFactor = 10;
  ll.LatLng? _startingPoint;
  final double _closingThreshold = 1.0; // 1 meter to snap to starting point
  final double _minAreaThreshold =
      10.0; // Minimum area in square meters to consider for snapping

  @override
  void initState() {
    super.initState();
    checkPermissions().then((hasPermission) {
      if (hasPermission) {
        getCurrentLocation().then((_) {
          startContinuousLocationUpdates();
        });
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
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 30),
      );

      setState(() {
        currentLocation = ll.LatLng(position.latitude, position.longitude);
        _lastValidLocation = currentLocation;
        locationLoaded = true;
      });

      _mapController.move(currentLocation!, _currentZoom);
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void startTracking() {
    setState(() {
      _isTracking = true;
      route.clear();
      pinDrops.clear();
      _recentPositions.clear();
      _startingPoint = currentLocation;
      if (_startingPoint != null) {
        route.add(_startingPoint!);
      }
    });
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // Update every 1 meter
        timeLimit: Duration(seconds: 10),
      ),
    ).listen((Position position) {
      _updateLocation(position);
    });
  }

  void stopTracking() {
    setState(() {
      _isTracking = false;
    });
    _positionSubscription?.cancel();
    _processRouteData();
  }

  void _updateLocation(Position position) {
    if (position.accuracy <= 10) {
      // Only use positions with accuracy better than 15 meters
      _recentPositions.add(position);
      if (_recentPositions.length > _smoothingFactor) {
        _recentPositions.removeAt(0);
      }

      if (_recentPositions.length == _smoothingFactor) {
        Position averagePosition = _calculateAveragePosition(_recentPositions);
        final newLocation =
            ll.LatLng(averagePosition.latitude, averagePosition.longitude);

        setState(() {
          currentLocation = newLocation;
          _mapController.move(newLocation, _currentZoom);
        });

        if (_isTracking && _lastValidLocation != null) {
          final distance = calculateDistance(_lastValidLocation!, newLocation);

          if (distance >= _minDistanceFilter) {
            setState(() {
              if (_startingPoint != null &&
                  calculateDistance(_startingPoint!, newLocation) <=
                      _closingThreshold) {
                double currentArea = calculateArea([...route, newLocation]);
                if (currentArea >= _minAreaThreshold) {
                  route.add(_startingPoint!);
                  _lastValidLocation = _startingPoint;
                  stopTracking();
                } else {
                  route.add(newLocation);
                  _lastValidLocation = newLocation;
                }
              } else {
                route.add(newLocation);
                _lastValidLocation = newLocation;
              }
            });
          }
        } else {
          _lastValidLocation = newLocation;
        }
      }
    }
  }

  void _processRouteData() {
    // Process the route data after stopping
    double finalArea = calculateArea(route);
    print('Final Area: $finalArea sq meters');
    // Add any other post-processing here
  }

  Position _calculateAveragePosition(List<Position> positions) {
    double latSum = 0, lonSum = 0, altSum = 0;
    double totalWeight = 0;
    for (Position position in positions) {
      double weight =
          1 / (position.accuracy + 1); // More weight to more accurate positions
      latSum += position.latitude * weight;
      lonSum += position.longitude * weight;
      altSum += position.altitude * weight;
      totalWeight += weight;
    }
    return Position.fromMap({
      'latitude': latSum / totalWeight,
      'longitude': lonSum / totalWeight,
      'altitude': altSum / totalWeight,
      'accuracy':
          positions.map((p) => p.accuracy).reduce((a, b) => a < b ? a : b),
      'speed': 0,
      'speedAccuracy': 0,
      'heading': 0,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'altitudeAccuracy': 0,
      'headingAccuracy': 0,
    });
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

  double calculateArea(List<ll.LatLng> points) {
    if (points.length < 3) return 0;
    double area = 0;
    for (int i = 0; i < points.length; i++) {
      int j = (i + 1) % points.length;
      area += (points[i].longitude * points[j].latitude -
          points[j].longitude * points[i].latitude);
    }
    return (area.abs() / 2) *
        111319.9 *
        111319.9; // Rough conversion to square meters
  }

  void dropPin() {
    if (currentLocation != null) {
      setState(() {
        pinDrops.add(currentLocation!);
      });
    }
  }

  void startContinuousLocationUpdates() {
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0, // Update as frequently as possible
        timeLimit: Duration(seconds: 5),
      ),
    ).listen((Position position) {
      _updateLocation(position);
    });
  }

  void recenterMap() {
    if (currentLocation != null) {
      _mapController.move(currentLocation!, _currentZoom);
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!locationLoaded) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Initializing map...', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }

    double area = calculateArea(route);

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
              maxZoom: 22.0,
              minZoom: 15.0,
              onMapReady: () {
                if (currentLocation != null) {
                  _mapController.move(currentLocation!, _currentZoom);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}?access_token={accessToken}',
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
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                  ...pinDrops.map(
                    (point) => Marker(
                      point: point,
                      width: 20.0,
                      height: 20.0,
                      child: Icon(Icons.location_pin, color: Colors.red),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Points: ${route.length}\n'
                    'Current: ${currentLocation?.latitude.toStringAsFixed(6)}, ${currentLocation?.longitude.toStringAsFixed(6)}',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Area: ${area.toStringAsFixed(2)} sq meters',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _isTracking ? stopTracking : startTracking,
                        child: Text(_isTracking ? 'Stop' : 'Start'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _isTracking ? dropPin : null,
                        child: Text('Drop Pin'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 70, // Adjust as needed
            right: 10,
            child: FloatingActionButton(
              onPressed: recenterMap,
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}

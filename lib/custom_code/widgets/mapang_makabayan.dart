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
  final double _minDistanceFilter = 1.0; // 1 meter
  ll.LatLng? _lastValidLocation;
  double _currentZoom = 19.0;
  bool _isTracking = false;
  double _calculatedArea = 0.0;
  final double _minMovementThreshold = 2.0; // in meters
  final int _bufferSize = 5;
  List<ll.LatLng> _recentLocations = [];

  @override
  void initState() {
    super.initState();
    checkPermissions().then((hasPermission) {
      if (hasPermission) {
        getInitialLocation();
      } else {
        showPermissionDeniedDialog();
      }
    });
  }

  Future<bool> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  void showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission Required'),
          content:
              Text('This app needs location permissions to function properly.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> getInitialLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentLocation = ll.LatLng(position.latitude, position.longitude);
        locationLoaded = true;
      });
      _mapController.move(currentLocation!, _currentZoom);
    } catch (e) {
      print("Error getting initial location: $e");
    }
  }

  void startLiveLocationUpdates() {
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
        forceLocationManager: true,
      ),
    ).listen((Position position) {
      _updateLocation(position);
    }, onError: (error) {
      print("Error getting location: $error");
    });
  }

  void _updateLocation(Position position) {
    ll.LatLng newLocation = ll.LatLng(position.latitude, position.longitude);

    _recentLocations.add(newLocation);
    if (_recentLocations.length > _bufferSize) {
      _recentLocations.removeAt(0);
    }

    ll.LatLng averageLocation = _calculateAverageLocation(_recentLocations);

    if (currentLocation != null) {
      double distance = calculateDistance(currentLocation!, averageLocation);
      if (distance < _minMovementThreshold) {
        return;
      }
    }

    setState(() {
      currentLocation = averageLocation;

      if (_isTracking) {
        if (_lastValidLocation == null ||
            calculateDistance(_lastValidLocation!, currentLocation!) >=
                _minDistanceFilter) {
          route.add(currentLocation!);
          _lastValidLocation = currentLocation;
        }
      }
    });

    _mapController.move(currentLocation!, _currentZoom);
  }

  ll.LatLng _calculateAverageLocation(List<ll.LatLng> locations) {
    double latitude = 0;
    double longitude = 0;
    for (var location in locations) {
      latitude += location.latitude;
      longitude += location.longitude;
    }
    return ll.LatLng(latitude / locations.length, longitude / locations.length);
  }

  void startTracking() async {
    // Get the current location again
    await getInitialLocation();

    setState(() {
      _isTracking = true;
      route.clear();
      _calculatedArea = 0.0;
      _lastValidLocation = null;
      _recentLocations.clear();
      if (currentLocation != null) {
        route.add(currentLocation!);
        _lastValidLocation = currentLocation;
      }
    });

    // Start live updates after getting initial location
    startLiveLocationUpdates();
  }

  void stopTracking() {
    setState(() {
      _isTracking = false;
      if (route.length > 2) {
        _calculatedArea = calculateArea(route);
      } else {
        _calculatedArea = 0.0;
      }
    });
    _positionSubscription?.cancel();
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
              if (_isTracking || route.isNotEmpty)
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
                  if (currentLocation != null)
                    Marker(
                      point: currentLocation!,
                      width: 12.0,
                      height: 12.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current: ${currentLocation?.latitude.toStringAsFixed(6)}, '
                    '${currentLocation?.longitude.toStringAsFixed(6)}',
                    style: TextStyle(fontSize: 12),
                  ),
                  if (_calculatedArea > 0)
                    Text(
                      'Area: ${_calculatedArea.toStringAsFixed(2)} sq meters',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ElevatedButton(
                    onPressed: _isTracking ? stopTracking : startTracking,
                    child: Text(_isTracking ? 'Stop' : 'Start'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 70,
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

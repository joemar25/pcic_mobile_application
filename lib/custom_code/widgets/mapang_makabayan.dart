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
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

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
  final double _minDistanceFilter = 0.5; // 0.5 meters for more precise tracking
  ll.LatLng? _lastValidLocation;
  double _currentZoom = 19.0;
  bool _isTracking = false;
  double _calculatedArea = 0.0;
  final double _minMovementThreshold =
      0.2; // 0.2 meters for more sensitive movement detection
  final int _bufferSize = 3; // Reduced for more responsive tracking
  List<Position> _recentPositions = [];
  final double _maxAccuracy = 5.0; // Maximum accepted GPS accuracy in meters
  late final StreamController<LocationMarkerPosition> _positionStreamController;
  late final Stream<LocationMarkerPosition> _positionStream;

  @override
  void initState() {
    super.initState();
    _positionStreamController = StreamController<LocationMarkerPosition>();
    _positionStream = _positionStreamController.stream.asBroadcastStream();
    _checkLocationServicesAndPermissions();
  }

  Future<void> _checkLocationServicesAndPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Location Services Disabled'),
          content: Text('Please enable location services to use this app.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Location Permission Denied'),
            content: Text('This app needs location permissions to function.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Location Permissions Permanently Denied'),
          content: Text(
              'Please enable location permissions in your device settings to use this app.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    getInitialLocation();
  }

  Future<void> getInitialLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      setState(() {
        currentLocation = ll.LatLng(position.latitude, position.longitude);
        locationLoaded = true;
      });
      _mapController.move(currentLocation!, _currentZoom);
    } catch (e) {
      print("Error getting initial location: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to get initial location. Please try again.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  void startLiveLocationUpdates() {
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
        forceLocationManager: false, // Use Google's Fused Location Provider
        intervalDuration: const Duration(seconds: 1),
        //foregroundNotificationConfig: ForegroundNotificationConfig(
        //  notificationText: "App is tracking your location",
        //  notificationTitle: "Location Tracking",
        //  enableWakeLock: true,
        //),
      ),
    ).listen((Position position) {
      _updateLocation(position);
    }, onError: (error) {
      if (error is LocationServiceDisabledException) {
        print("Location services are disabled.");
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Location Services Disabled'),
            content:
                Text('Please enable location services to continue tracking.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      } else {
        print("Error getting location: $error");
      }
    });
  }

  void _updateLocation(Position position) {
    if (position.accuracy > _maxAccuracy) {
      print("Skipping inaccurate location: ${position.accuracy} meters");
      return;
    }

    _recentPositions.add(position);
    if (_recentPositions.length > _bufferSize) {
      _recentPositions.removeAt(0);
    }

    Position averagePosition = _calculateAveragePosition(_recentPositions);
    ll.LatLng newLocation =
        ll.LatLng(averagePosition.latitude, averagePosition.longitude);

    if (currentLocation != null) {
      double distance = calculateDistance(currentLocation!, newLocation);
      if (distance < _minMovementThreshold) {
        return;
      }
    }

    setState(() {
      currentLocation = newLocation;

      if (_isTracking) {
        if (_lastValidLocation == null ||
            calculateDistance(_lastValidLocation!, currentLocation!) >=
                _minDistanceFilter) {
          route.add(currentLocation!);
          _lastValidLocation = currentLocation;
        }
      }
    });

    _positionStreamController.add(LocationMarkerPosition(
      latitude: currentLocation!.latitude,
      longitude: currentLocation!.longitude,
      accuracy: position.accuracy,
    ));
    _mapController.move(currentLocation!, _currentZoom);
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

    double avgAccuracy =
        positions.map((p) => p.accuracy).reduce((a, b) => a < b ? a : b);

    return Position(
      latitude: latSum / totalWeight,
      longitude: lonSum / totalWeight,
      altitude: altSum / totalWeight,
      accuracy: avgAccuracy,
      speed: 0,
      speedAccuracy: 0,
      heading: 0,
      timestamp: DateTime.now(),
      altitudeAccuracy: 0, // Add this line
      headingAccuracy: 0, // Add this line
      floor:
          null, // Add this line if needed, or use a meaningful value if available
    );
  }

  void startTracking() async {
    await getInitialLocation();

    setState(() {
      _isTracking = true;
      route.clear();
      _calculatedArea = 0.0;
      _lastValidLocation = null;
      _recentPositions.clear();
      if (currentLocation != null) {
        route.add(currentLocation!);
        _lastValidLocation = currentLocation;
      }
    });

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
              CurrentLocationLayer(
                positionStream: _positionStream,
                style: LocationMarkerStyle(
                  marker: DefaultLocationMarker(
                    child: Icon(
                      Icons.navigation,
                      color: Colors.white,
                    ),
                  ),
                  markerSize: Size(20, 20),
                  accuracyCircleColor: Colors.green.withOpacity(0.1),
                  headingSectorColor: Colors.green.withOpacity(0.8),
                  headingSectorRadius: 60,
                ),
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

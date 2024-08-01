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

import 'index.dart'; // Imports other custom widgets

import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;
import 'package:connectivity_plus/connectivity_plus.dart';

class MapBox extends StatefulWidget {
  const MapBox({
    super.key,
    this.width,
    this.height,
    this.accessToken,
    this.taskId,
  });

  final double? width;
  final double? height;
  final String? accessToken;
  final String? taskId;

  @override
  State<MapBox> createState() => _MapBoxState();
}

class _MapBoxState extends State<MapBox> {
  final MapController _mapController = MapController();
  ll.LatLng? _currentLocation;
  List<ll.LatLng> _routeCoordinates = [];
  StreamSubscription<Position>? _positionStreamSubscription;
  List<Marker> _cornerMarkers = [];
  bool _isTracking = false;
  bool _isInitialized = false;
  String? _errorMessage;
  bool _isMapReady = false;
  bool _isOnline = true;

  ll.LatLng? _startingPosition;

  final ll.Distance _distance = ll.Distance();

  static const double _currentZoom = 18.0;
  static const double _movementThreshold = 3.0; // meters
  static const double _minAccuracy = 10.0; // meters
  static const int _movingAverageWindow = 5;
  static const int _maxRetries = 3;

  List<ll.LatLng> _recentLocations = [];

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      await _checkLocationPermission();
      await _checkLocationAccuracy();

      Position initialPosition = await _getCurrentPositionWithRetry();
      setState(() {
        _currentLocation =
            ll.LatLng(initialPosition.latitude, initialPosition.longitude);
        _isInitialized = true;
      });

      _startLocationStream();
    } catch (e) {
      setState(() {
        _errorMessage = "Initialization error: $e";
      });
    }
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isOnline = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _checkLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Location services are disabled.');

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }
  }

  Future<void> _checkLocationAccuracy() async {
    try {
      LocationAccuracyStatus accuracy = await Geolocator.getLocationAccuracy();
      if (accuracy == LocationAccuracyStatus.reduced) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enable precise location for better accuracy'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () {
                Geolocator.openAppSettings();
              },
            ),
          ),
        );
      }
    } catch (e) {
      print('Error checking location accuracy: $e');
    }
  }

  Future<Position> _getCurrentPositionWithRetry({int retries = 0}) async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: Duration(seconds: 10),
      );
    } catch (e) {
      if (retries < _maxRetries) {
        await Future.delayed(Duration(seconds: 2));
        return _getCurrentPositionWithRetry(retries: retries + 1);
      } else {
        throw Exception(
            'Failed to get current position after $_maxRetries attempts');
      }
    }
  }

  void _startLocationStream() {
    LocationSettings locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
      intervalDuration: const Duration(seconds: 1),
      forceLocationManager: true,
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText: "PCIC is tracking your location",
        notificationTitle: "Location Tracking Active",
        enableWakeLock: true,
      ),
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        _processNewPosition(position);
      },
      onError: (error) {
        print("Location stream error: $error");
        _restartLocationStream();
      },
    );
  }

  void _restartLocationStream() {
    _positionStreamSubscription?.cancel();
    _startLocationStream();
  }

  void _processNewPosition(Position position) {
    if (!_isTracking) return;
    print('Position accuracy: ${position.accuracy} meters');
    if (position.accuracy <= _minAccuracy) {
      ll.LatLng newLocation = ll.LatLng(position.latitude, position.longitude);
      _recentLocations.add(newLocation);
      if (_recentLocations.length > _movingAverageWindow) {
        _recentLocations.removeAt(0);
      }
      ll.LatLng averageLocation = _calculateAverageLocation();

      if (_startingPosition != null) {
        double distanceFromStart = _distance.as(
            ll.LengthUnit.Meter, _startingPosition!, averageLocation);

        if (distanceFromStart >= _movementThreshold ||
            _routeCoordinates.length > 1) {
          _updatePosition(averageLocation);
        } else {
          print('Not updating position: Too close to starting point');
        }
      } else {
        _updatePosition(averageLocation);
      }
    } else {
      print('Skipping low accuracy position');
    }
  }

  void _updatePosition(ll.LatLng location) {
    setState(() {
      _currentLocation = location;
      if (_isTracking) {
        _routeCoordinates.add(_currentLocation!);
      }
      if (_isMapReady) {
        _mapController.move(_currentLocation!, _currentZoom);
      }
    });
  }

  ll.LatLng _calculateAverageLocation() {
    double latSum = 0, lonSum = 0;
    for (var loc in _recentLocations) {
      latSum += loc.latitude;
      lonSum += loc.longitude;
    }
    return ll.LatLng(
        latSum / _recentLocations.length, lonSum / _recentLocations.length);
  }

  Future<bool> _isGpsEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<void> _startTracking() async {
    if (_isInitialized && !_isTracking) {
      bool gpsEnabled = await _isGpsEnabled();
      if (!gpsEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('GPS is not enabled. Please turn on GPS to start tracking.'),
        ));
        FFAppState().routeStarted = false;
        return;
      }

      try {
        setState(() {
          _isTracking = true;
          _routeCoordinates.clear();
          _cornerMarkers.clear();
          _startingPosition = _currentLocation;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Initializing GPS'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Please wait for 10 seconds while GPS stabilizes...'),
                  ],
                ),
              );
            },
          );
        });

        await Future.delayed(Duration(seconds: 10));

        Position startPosition = await _getCurrentPositionWithRetry();

        setState(() {
          _startingPosition =
              ll.LatLng(startPosition.latitude, startPosition.longitude);
          _routeCoordinates.add(_startingPosition!);
          _cornerMarkers.add(
            Marker(
              point: _startingPosition!,
              child: Icon(Icons.star, color: Colors.red),
            ),
          );
        });

        Navigator.of(context).pop(); // Dismiss the dialog

        // Start updating positions
        _startLocationStream();

        FFAppState().routeStarted = true;
      } catch (e) {
        setState(() {
          _isTracking = false;
          _errorMessage = "Failed to start tracking: $e";
        });
        FFAppState().routeStarted = false;
      }
    }
  }

  void _completeTracking() {
    if (_isTracking) {
      setState(() {
        _isTracking = false;
        if (_routeCoordinates.isNotEmpty &&
            _routeCoordinates.first != _routeCoordinates.last) {
          _routeCoordinates.add(_routeCoordinates.first);
        }
      });

      // Convert ll.LatLng to FlutterFlow's LatLng
      List<LatLng> convertedCoordinates = _routeCoordinates
          .map((coord) => LatLng(coord.latitude, coord.longitude))
          .toList();

      debugPrint('Converted coordinates: $convertedCoordinates');
      // debugPrint('Task ID: ${FFAppState().currentTaskId}');
      debugPrint('Saving IDK');

      /// saveGpx('idk', convertedCoordinates);
      saveGpx(widget.taskId ?? 'default_task_id', convertedCoordinates);
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = FFAppState();

    if (appState.routeStarted && !_isTracking) {
      _startTracking();
    } else if (!appState.routeStarted && _isTracking) {
      _completeTracking();
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_errorMessage'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                  _isInitialized = false;
                });
                _initializeLocation();
              },
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (!_isInitialized || _currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? MediaQuery.of(context).size.height,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentLocation!,
          initialZoom: _currentZoom,
          minZoom: 0,
          maxZoom: 22,
          onMapReady: () {
            setState(() {
              _isMapReady = true;
            });
          },
        ),
        children: [
          TileLayer(
            tileProvider: FMTC.FMTCStore('mapStore').getTileProvider(),
            urlTemplate:
                'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: {
              'accessToken':
                  widget.accessToken ?? 'your_default_mapbox_access_token_here',
            },
          ),
          CurrentLocationLayer(
            alignPositionOnUpdate: AlignOnUpdate.always,
            alignDirectionStream: null,
            style: LocationMarkerStyle(
              marker: const DefaultLocationMarker(color: Colors.green),
              markerSize: const Size(15, 15),
              markerDirection: MarkerDirection.heading,
              accuracyCircleColor: Colors.green.withOpacity(0.2),
              headingSectorColor: Colors.green.withOpacity(0.8),
            ),
            alignDirectionAnimationDuration: Duration(milliseconds: 100),
          ),
          if (_isTracking)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: _routeCoordinates,
                  strokeWidth: 4.0,
                  color: Colors.blue,
                ),
              ],
            ),
          if (!_isTracking && _routeCoordinates.isNotEmpty)
            PolygonLayer(
              polygons: [
                Polygon(
                  points: _routeCoordinates,
                  color: Colors.blue.withOpacity(0.2),
                  borderColor: Colors.blue,
                  borderStrokeWidth: 3,
                ),
              ],
            ),
          MarkerLayer(markers: _cornerMarkers),
        ],
      ),
    );
  }
}

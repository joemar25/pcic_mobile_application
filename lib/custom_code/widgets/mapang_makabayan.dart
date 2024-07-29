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
  late Future<ll.LatLng> _initialLocationFuture;
  List<ll.LatLng> route = [];
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionSubscription;
  bool _isTracking = false;
  final double _minDistanceFilter = 3.0; // 3 meters between points
  ll.LatLng? _currentLocation;
  final double _currentZoom = 19.0;
  late final StreamController<LocationMarkerPosition> _positionStreamController;
  late final Stream<LocationMarkerPosition> _positionStream;

  final double _minAccuracyThreshold = 10.0; // in meters
  final int _locationUpdateInterval = 1; // in seconds
  final int _locationAveragingSamples = 5; // number of samples to average

  List<Position> _recentPositions = [];

  @override
  void initState() {
    super.initState();
    _positionStreamController = StreamController<LocationMarkerPosition>();
    _positionStream = _positionStreamController.stream.asBroadcastStream();
    _initialLocationFuture = _getInitialLocation();
  }

  Future<ll.LatLng> _getInitialLocation() async {
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

    try {
      Position position = await _getAveragedPosition();
      _currentLocation = ll.LatLng(position.latitude, position.longitude);
      _updateLocationMarker(_currentLocation!, position.accuracy);
      return _currentLocation!;
    } catch (e) {
      print("Error getting initial location: $e");
      throw Exception('Failed to get location: $e');
    }
  }

  Future<Position> _getAveragedPosition() async {
    List<Position> positions = [];
    for (int i = 0; i < _locationAveragingSamples; i++) {
      positions.add(await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      ));
      await Future.delayed(Duration(seconds: 1));
    }

    double latSum = 0,
        lonSum = 0,
        altSum = 0,
        accSum = 0,
        altAccSum = 0,
        headingSum = 0,
        headingAccSum = 0,
        speedSum = 0,
        speedAccSum = 0;
    for (var pos in positions) {
      latSum += pos.latitude;
      lonSum += pos.longitude;
      altSum += pos.altitude;
      accSum += pos.accuracy;
      altAccSum += pos.altitudeAccuracy ?? 0;
      headingSum += pos.heading;
      headingAccSum += pos.headingAccuracy ?? 0;
      speedSum += pos.speed;
      speedAccSum += pos.speedAccuracy;
    }

    return Position(
      latitude: latSum / _locationAveragingSamples,
      longitude: lonSum / _locationAveragingSamples,
      altitude: altSum / _locationAveragingSamples,
      accuracy: accSum / _locationAveragingSamples,
      altitudeAccuracy: altAccSum / _locationAveragingSamples,
      heading: headingSum / _locationAveragingSamples,
      headingAccuracy: headingAccSum / _locationAveragingSamples,
      speed: speedSum / _locationAveragingSamples,
      speedAccuracy: speedAccSum / _locationAveragingSamples,
      timestamp: DateTime.now(),
      floor: null,
      isMocked: false,
    );
  }

  void startTracking() async {
    try {
      Position position = await _getAveragedPosition();
      _currentLocation = ll.LatLng(position.latitude, position.longitude);

      setState(() {
        _isTracking = true;
        route = [_currentLocation!];
        print('Started tracking. Initial point: $_currentLocation');
      });

      _updateLocationMarker(_currentLocation!, position.accuracy);
      _mapController.move(_currentLocation!, _currentZoom);
    } catch (e) {
      print("Error getting current location: $e");
      return;
    }

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1, // Update every 1 meter
        forceLocationManager: false,
        intervalDuration: Duration(seconds: _locationUpdateInterval),
      ),
    ).listen((Position position) {
      _updateLocation(position);
    }, onError: (error) {
      print("Error getting location: $error");
    });
  }

  void stopTracking() {
    setState(() {
      _isTracking = false;
    });
    _positionSubscription?.cancel();
    print('Stopped tracking. Total points in route: ${route.length}');
  }

  void _updateLocation(Position position) {
    _recentPositions.add(position);
    if (_recentPositions.length > _locationAveragingSamples) {
      _recentPositions.removeAt(0);
    }

    Position averagedPosition = _averagePositions(_recentPositions);

    if (averagedPosition.accuracy > _minAccuracyThreshold) {
      print(
          'Low accuracy data (${averagedPosition.accuracy} meters), skipping update');
      return;
    }

    ll.LatLng newLocation =
        ll.LatLng(averagedPosition.latitude, averagedPosition.longitude);

    if (_isTracking) {
      double distance = _calculateDistance(route.last, newLocation);
      if (distance >= _minDistanceFilter) {
        setState(() {
          route.add(newLocation);
          print(
              'Added point to route. Total points: ${route.length}. Distance from last point: $distance meters');
        });
      }
    }

    _currentLocation = newLocation;
    _updateLocationMarker(newLocation, averagedPosition.accuracy);

    if (_isTracking) {
      _mapController.move(newLocation, _currentZoom);
    }
  }

  Position _averagePositions(List<Position> positions) {
    double latSum = 0,
        lonSum = 0,
        altSum = 0,
        accSum = 0,
        altAccSum = 0,
        headingSum = 0,
        headingAccSum = 0,
        speedSum = 0,
        speedAccSum = 0;
    for (var pos in positions) {
      latSum += pos.latitude;
      lonSum += pos.longitude;
      altSum += pos.altitude;
      accSum += pos.accuracy;
      altAccSum += pos.altitudeAccuracy ?? 0;
      headingSum += pos.heading;
      headingAccSum += pos.headingAccuracy ?? 0;
      speedSum += pos.speed;
      speedAccSum += pos.speedAccuracy;
    }
    int count = positions.length;
    return Position(
      latitude: latSum / count,
      longitude: lonSum / count,
      altitude: altSum / count,
      accuracy: accSum / count,
      altitudeAccuracy: altAccSum / count,
      heading: headingSum / count,
      headingAccuracy: headingAccSum / count,
      speed: speedSum / count,
      speedAccuracy: speedAccSum / count,
      timestamp: DateTime.now(),
      floor: null,
      isMocked: false,
    );
  }

  void _updateLocationMarker(ll.LatLng location, double accuracy) {
    _positionStreamController.add(LocationMarkerPosition(
      latitude: location.latitude,
      longitude: location.longitude,
      accuracy: accuracy,
    ));
  }

  double _calculateDistance(ll.LatLng start, ll.LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _positionStreamController.close();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ll.LatLng>(
      future: _initialLocationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No location data'));
        }

        ll.LatLng initialLocation = snapshot.data!;

        return SizedBox(
          width: widget.width ?? MediaQuery.of(context).size.width,
          height: widget.height ?? MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: initialLocation,
                  initialZoom: _currentZoom,
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
                  CurrentLocationLayer(
                    positionStream: _positionStream,
                    style: LocationMarkerStyle(
                      marker: DefaultLocationMarker(
                        color: Colors.green,
                      ),
                      markerSize: Size(20, 20),
                      accuracyCircleColor: Colors.green.withOpacity(0.1),
                      headingSectorColor: Colors.green.withOpacity(0.8),
                      headingSectorRadius: 40,
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: _isTracking ? stopTracking : startTracking,
                      child: Text(_isTracking ? 'Stop' : 'Start'),
                    ),
                    SizedBox(height: 8),
                    Text('Points: ${route.length}',
                        style: TextStyle(backgroundColor: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

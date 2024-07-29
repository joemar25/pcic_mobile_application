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
  ll.LatLng? _lastRecordedPoint;
  final double _currentZoom = 19.0;
  late final StreamController<LocationMarkerPosition> _positionStreamController;
  late final Stream<LocationMarkerPosition> _positionStream;

  final int _minSatellitesForAccuracy = 4;
  final double _minAccuracyThreshold = 3.0; // in meters

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
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      ).timeout(Duration(seconds: 10));
      ll.LatLng location = ll.LatLng(position.latitude, position.longitude);
      _updateLocationMarker(location, position.accuracy);
      return location;
    } catch (e) {
      print("Error getting initial location: $e");
      throw Exception('Failed to get location: $e');
    }
  }

  void startTracking() async {
    setState(() {
      _isTracking = true;
      route.clear();
      _lastRecordedPoint = null;
    });

    // Get current location before starting the stream
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      _updateLocation(position);
    } catch (e) {
      print("Error getting current location: $e");
    }

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
        forceLocationManager: false,
        intervalDuration: const Duration(seconds: 1),
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
  }

  void _updateLocation(Position position) {
    if (position is AndroidPosition) {
      print('Accuracy: ${position.accuracy} meters');
      if (position.satellitesUsedInFix < _minSatellitesForAccuracy ||
          position.accuracy > _minAccuracyThreshold) {
        print('Low accuracy data, skipping update');
        return;
      }

      if (position.isMocked) {
        print('Warning: Location may be mocked');
        return;
      }

      print('Satellites in use: ${position.satellitesUsedInFix}');
    }

    ll.LatLng newLocation = ll.LatLng(position.latitude, position.longitude);

    setState(() {
      if (_isTracking) {
        if (_lastRecordedPoint == null ||
            _calculateDistance(_lastRecordedPoint!, newLocation) >=
                _minDistanceFilter) {
          route.add(newLocation);
          _lastRecordedPoint = newLocation;
        }
      }
    });

    _updateLocationMarker(newLocation, position.accuracy);
    _mapController.move(newLocation, _currentZoom);
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
                child: ElevatedButton(
                  onPressed: _isTracking ? stopTracking : startTracking,
                  child: Text(_isTracking ? 'Stop' : 'Start'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

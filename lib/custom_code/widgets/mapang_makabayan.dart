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
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:geolocator/geolocator.dart';

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
  final MapController _mapController = MapController();
  ll.LatLng? _currentLocation;
  double _previousLatEstimate = 0.0;
  double _previousLngEstimate = 0.0;
  double _errorCovarianceLat = 1.0;
  double _errorCovarianceLng = 1.0;

  static const double _currentZoom = 19.0;

  String? _errorMessage;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      await _checkLocationPermission();
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _updatePosition(position);
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
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

  void _updatePosition(Position position) {
    final filteredLatLng = kalmanFilterAlgo(
      position.latitude,
      position.longitude,
      _previousLatEstimate,
      _previousLngEstimate,
      _errorCovarianceLat,
      _errorCovarianceLng,
    );

    setState(() {
      _currentLocation =
          ll.LatLng(filteredLatLng.latitude, filteredLatLng.longitude);
      _previousLatEstimate = filteredLatLng.latitude;
      _previousLngEstimate = filteredLatLng.longitude;
    });
  }

  ll.LatLng kalmanFilterAlgo(
    double latitude,
    double longitude,
    double previousLatitude,
    double previousLongitude,
    double previousErrorCovarianceLat,
    double previousErrorCovarianceLng,
  ) {
    double q = 0.0001; // Process noise covariance
    double r = 0.01; // Measurement noise covariance

    // Kalman filter calculation for latitude
    double pLat = previousErrorCovarianceLat + q;
    double kLat = pLat / (pLat + r);
    double filteredLat =
        previousLatitude + kLat * (latitude - previousLatitude);
    double updatedErrorCovarianceLat = (1 - kLat) * pLat;

    // Kalman filter calculation for longitude
    double pLng = previousErrorCovarianceLng + q;
    double kLng = pLng / (pLng + r);
    double filteredLng =
        previousLongitude + kLng * (longitude - previousLongitude);
    double updatedErrorCovarianceLng = (1 - kLng) * pLng;

    // Update error covariances
    _errorCovarianceLat = updatedErrorCovarianceLat;
    _errorCovarianceLng = updatedErrorCovarianceLng;

    // Return the filtered LatLng coordinates
    return ll.LatLng(filteredLat, filteredLng);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Center(child: Text('Error: $_errorMessage'));
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
          maxZoom: 19,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: {
              'accessToken':
                  widget.accessToken ?? 'your_default_mapbox_access_token_here',
            },
          ),
          CurrentLocationLayer(
            style: LocationMarkerStyle(
              marker: DefaultLocationMarker(
                color: Colors.green,
                child: Icon(
                  Icons.person_pin_circle,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              markerSize: const Size(15, 15),
              accuracyCircleColor: Colors.green.withOpacity(0.1),
              headingSectorColor: Colors.green.withOpacity(0.8),
              headingSectorRadius: 120,
            ),
          ),
        ],
      ),
    );
  }
}

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

import 'dart:math' as math;
import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:geolocator/geolocator.dart';
import 'package:vector_math/vector_math.dart' show radians;

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
  double _heading = 0;
  final MapController _mapController = MapController();
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamSubscription<Position>? _positionSubscription;
  final double _minDistanceFilter = 1.0; // meters
  final double _headingFilter = 5.0; // degrees
  ll.LatLng? _lastValidLocation;
  double _currentZoom = 19.0;
  final List<Position> _recentPositions = [];
  final int _positionsToAverage = 5;

  double _filteredHeading = 0;
  final double _alpha = 0.5; // Increased for even faster response
  bool _isMoving = false;

  @override
  void initState() {
    super.initState();
    checkPermissions().then((hasPermission) {
      if (hasPermission) {
        getCurrentLocation();
        trackMovement();
        listenToGyroscope();
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
    _recentPositions.add(position);
    if (_recentPositions.length > _positionsToAverage) {
      _recentPositions.removeAt(0);
    }

    if (_recentPositions.length == _positionsToAverage) {
      final averagePosition = _calculateAveragePosition(_recentPositions);
      final newLocation =
          ll.LatLng(averagePosition.latitude, averagePosition.longitude);

      if (_lastValidLocation != null) {
        final distance = Geolocator.distanceBetween(
          _lastValidLocation!.latitude,
          _lastValidLocation!.longitude,
          newLocation.latitude,
          newLocation.longitude,
        );

        final bearing = Geolocator.bearingBetween(
          _lastValidLocation!.latitude,
          _lastValidLocation!.longitude,
          newLocation.latitude,
          newLocation.longitude,
        );

        if (distance >= _minDistanceFilter ||
            (bearing - _heading).abs() >= _headingFilter) {
          setState(() {
            currentLocation = newLocation;
            _lastValidLocation = newLocation;
            route.add(newLocation);
            _mapController.move(newLocation, _currentZoom);

            if (distance >= _minDistanceFilter) {
              _heading = bearing;
              _filteredHeading = _heading;
              _isMoving = true;
            }
          });
        }
      } else {
        setState(() {
          currentLocation = newLocation;
          _lastValidLocation = newLocation;
          route.add(newLocation);
          _mapController.move(newLocation, _currentZoom);
        });
      }
    }
  }

  Position _calculateAveragePosition(List<Position> positions) {
    double latSum = 0, lonSum = 0, altSum = 0;
    for (var position in positions) {
      latSum += position.latitude;
      lonSum += position.longitude;
      altSum += position.altitude;
    }
    return Position.fromMap({
      'latitude': latSum / positions.length,
      'longitude': lonSum / positions.length,
      'altitude': altSum / positions.length,
      'accuracy': positions.last.accuracy,
      'heading': positions.last.heading,
      'speed': positions.last.speed,
      'speedAccuracy': positions.last.speedAccuracy,
      'timestamp': positions.last.timestamp,
      'altitudeAccuracy': positions.last.altitudeAccuracy,
      'headingAccuracy': positions.last.headingAccuracy,
    });
  }

  void listenToGyroscope() {
    _gyroscopeSubscription =
        gyroscopeEventStream().listen((GyroscopeEvent event) {
      if (_isMoving) {
        _filteredHeading = _filteredHeading +
            _alpha * ((_heading + event.z * 180 / math.pi) - _filteredHeading);
        _filteredHeading = _filteredHeading % 360;

        setState(() {
          _heading = _filteredHeading;
        });
      }
    });
  }

  @override
  void dispose() {
    _gyroscopeSubscription?.cancel();
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
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: currentLocation!,
          initialZoom: _currentZoom,
          maxZoom: 23.0,
          onMapEvent: (MapEvent event) {
            if (event is MapEventMoveEnd) {
              setState(() {
                _currentZoom = _mapController.camera.zoom;
              });
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/quanbysolutions/cluhoxol502q801oi8od2cmvz/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: {
              'accessToken':
                  widget.accessToken ?? 'your_default_mapbox_access_token_here',
            },
          ),
          StreamBuilder<List<ll.LatLng>>(
            stream: Stream.periodic(Duration(milliseconds: 100), (_) => route),
            builder: (context, snapshot) {
              return PolylineLayer(
                polylines: [
                  Polyline(
                    points: snapshot.data ?? [],
                    strokeWidth: 4.0,
                    color: Colors.blue,
                  ),
                ],
              );
            },
          ),
          MarkerLayer(
            markers: [
              if (_isMoving && currentLocation != null)
                Marker(
                  point: currentLocation!,
                  width: 80.0,
                  height: 80.0,
                  child: FlashlightMarker(heading: _heading),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class FlashlightMarker extends StatelessWidget {
  final double heading;

  const FlashlightMarker({Key? key, required this.heading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: radians(heading),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(60, 60),
            painter: FlashlightBeamPainter(),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ],
      ),
    );
  }
}

class FlashlightBeamPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.blue.withOpacity(0.6), Colors.blue.withOpacity(0)],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.height / 2,
      ))
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(size.width / 2, size.height / 2)
      ..lineTo(size.width / 2 - 15, size.height)
      ..arcTo(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height),
          radius: 15,
        ),
        math.pi,
        math.pi,
        false,
      )
      ..lineTo(size.width / 2, size.height / 2)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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
  final List<double> _gyroReadings = List.filled(20, 0);
  int _gyroIndex = 0;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamSubscription<Position>? _positionSubscription;
  final double _minDistanceFilter = 2.0; // meters
  final double _headingFilter = 5.0; // degrees
  ll.LatLng? _lastValidLocation;
  double _currentZoom = 19.0;

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
    final newLocation = ll.LatLng(position.latitude, position.longitude);

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
          _heading = bearing;
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

  void listenToGyroscope() {
    _gyroscopeSubscription =
        gyroscopeEventStream().listen((GyroscopeEvent event) {
      setState(() {
        _gyroReadings[_gyroIndex] = event.z;
        _gyroIndex = (_gyroIndex + 1) % _gyroReadings.length;
        _heading = _calculateSmoothedHeading();
      });
    });
  }

  double _calculateSmoothedHeading() {
    double sum = _gyroReadings.reduce((a, b) => a + b);
    return sum / _gyroReadings.length;
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
          PolylineLayer(
            polylines: [
              Polyline(
                points: route,
                strokeWidth: 4.0,
                color: Colors.blue,
                strokeCap: StrokeCap.round,
                strokeJoin: StrokeJoin.round,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
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
      angle: -radians(heading),
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

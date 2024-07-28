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
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_map/flutter_map.dart';
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
  ll.LatLng? currentLocation;
  bool locationLoaded = false;
  List<ll.LatLng> route = [];
  double _heading = 0;
  final MapController _mapController = MapController();
  final List<double> _gyroReadings = List.filled(10, 0);
  int _gyroIndex = 0;

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
        locationLoaded = true;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void trackMovement() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 3,
      ),
    ).listen((Position position) {
      setState(() {
        currentLocation = ll.LatLng(position.latitude, position.longitude);
        route.add(currentLocation!);
      });
    });
  }

  void listenToGyroscope() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroReadings[_gyroIndex] = event.z;
        _gyroIndex = (_gyroIndex + 1) % _gyroReadings.length;
        _heading = _gyroReadings.reduce((a, b) => a + b) / _gyroReadings.length;
      });
    });
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
          initialCenter: currentLocation ?? ll.LatLng(0, 0),
          initialZoom: 19.0,
          maxZoom: 23.0,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token={accessToken}',
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
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: currentLocation ?? ll.LatLng(0, 0),
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
      angle: -heading,
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

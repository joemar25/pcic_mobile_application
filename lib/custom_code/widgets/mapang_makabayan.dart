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
import 'dart:math' as math;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MapangMakabayan extends StatefulWidget {
  const MapangMakabayan({
    Key? key,
    this.width,
    this.height,
    this.accessToken,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? accessToken;

  @override
  _MapangMakabayanState createState() => _MapangMakabayanState();
}

class _MapangMakabayanState extends State<MapangMakabayan> {
  ll.LatLng? currentLocation;
  bool locationLoaded = false;
  List<ll.LatLng> route = [];
  double heading = 0.0;

  @override
  void initState() {
    super.initState();
    checkPermissions().then((hasPermission) {
      if (hasPermission) {
        getCurrentLocation();
        trackMovement();
      }
    });
    listenToHeading();
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
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 3,
      ),
    ).listen((Position position) {
      setState(() {
        currentLocation = ll.LatLng(position.latitude, position.longitude);
        route.add(currentLocation!);
        print(
            'New Position: ${currentLocation!.latitude}, ${currentLocation!.longitude}');
      });
    });
  }

  void listenToHeading() {
    gyroscopeEventStream().listen((GyroscopeEvent event) {
      setState(() {
        heading = event.z * (180 / math.pi);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!locationLoaded) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? MediaQuery.of(context).size.height,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: currentLocation!,
          initialZoom: 19.0,
          maxZoom: 23.0,
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
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: currentLocation!,
                width: 40.0,
                height: 40.0,
                child: Transform.rotate(
                  angle: heading * (math.pi / 180),
                  child: FlashlightMarker(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FlashlightMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(40, 40),
          painter: FlashlightBeamPainter(),
        ),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}

class FlashlightBeamPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(size.width / 2, size.height / 2)
      ..lineTo(size.width / 2 - 20, size.height)
      ..lineTo(size.width / 2 + 20, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

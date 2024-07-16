// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;

class GeotagMap extends StatefulWidget {
  const GeotagMap({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<GeotagMap> createState() => _GeotagMapState();
}

class _GeotagMapState extends State<GeotagMap> {
  late LatLng currentLocation;

  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Location Permission Denied');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location Permission Denied');
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location Permission Denied');
    }
    return true;
  }

  void getCurrentLocation() async {
    Geolocator.getPositionStream(
            locationSettings: LocationSettings(
                accuracy: LocationAccuracy.best, distanceFilter: 3))
        .listen((Position position) {});
  }

  @override
  void initState() {
    super.initState();
    // checkPermission().then((permissionAccepted){
    //   if(permissionAccepted){
    //     Timer timer = Timer.periodic(Duration(seconds: 2), (Timer t){

    //     });
    //   }
    // })
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

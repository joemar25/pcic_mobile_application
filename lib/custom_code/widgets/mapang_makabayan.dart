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
import 'dart:math' show acos, asin, atan, atan2, cos, pi, sin, sqrt, tan;

extension on double {
  double toRadians() {
    return this * (pi / 180.0);
  }
}

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
  List<ll.LatLng> corners = [];
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionSubscription;
  final double _minDistanceFilter = 1.0; // 1 meter for higher precision
  final double _minTurnAngle = 10.0; // Reduced for more detail
  ll.LatLng? _lastValidLocation;
  double _currentZoom = 20.0; // Increased zoom for more detail
  List<Position> _recentPositions = [];
  bool _isMarking = false;
  double _totalDistance = 0.0;
  bool _polygonClosed = false;

  @override
  void initState() {
    super.initState();
    checkPermissions().then((hasPermission) {
      if (hasPermission) {
        getCurrentLocation();
        trackMovement();
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
      print(
          "Initial location set: ${currentLocation!.latitude}, ${currentLocation!.longitude}");
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void trackMovement() {
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0, // Get all updates
      ),
    ).listen((Position position) {
      _updateLocation(position);
    });
  }

  void _updateLocation(Position position) {
    _recentPositions.add(position);
    if (_recentPositions.length > 10) {
      _recentPositions.removeAt(0);
    }

    if (_recentPositions.length == 10) {
      Position averagePosition = _calculateAveragePosition(_recentPositions);
      final newLocation =
          ll.LatLng(averagePosition.latitude, averagePosition.longitude);

      if (_lastValidLocation != null && averagePosition.accuracy < 3) {
        final distance =
            calculateVincentyDistance(_lastValidLocation!, newLocation);
        _totalDistance += distance;
        print("Distance moved: $distance meters");

        if (distance >= _minDistanceFilter || _isMarking) {
          bool shouldAddPoint = true;

          if (route.length >= 2 && !_isMarking) {
            final lastPoint = route[route.length - 1];
            final secondLastPoint = route[route.length - 2];

            final angle =
                calculateAngle(secondLastPoint, lastPoint, newLocation);
            print("Turn angle: $angle degrees");

            if (angle < _minTurnAngle) {
              shouldAddPoint = false;
              route[route.length - 1] = newLocation;
            }
          }

          if (shouldAddPoint) {
            setState(() {
              route.add(newLocation);
              if (_isMarking) {
                corners.add(newLocation);
                _isMarking = false;
              }
            });
            print("New point added. Total points: ${route.length}");
          }

          setState(() {
            currentLocation = newLocation;
            _lastValidLocation = newLocation;
            _mapController.move(newLocation, _currentZoom);
          });

          print(
              "New location: ${newLocation.latitude}, ${newLocation.longitude}");
        }
      } else if (_lastValidLocation == null) {
        setState(() {
          currentLocation = newLocation;
          _lastValidLocation = newLocation;
          route.add(newLocation);
          _mapController.move(newLocation, _currentZoom);
        });
        print("First point added. Total points: ${route.length}");
      }
    }
  }

  Position _calculateAveragePosition(List<Position> positions) {
    double latSum = 0, lonSum = 0, altSum = 0, accSum = 0;
    for (var position in positions) {
      latSum += position.latitude;
      lonSum += position.longitude;
      altSum += position.altitude;
      accSum += position.accuracy;
    }
    return Position(
      latitude: latSum / positions.length,
      longitude: lonSum / positions.length,
      altitude: altSum / positions.length,
      accuracy: accSum / positions.length,
      speed: 0,
      speedAccuracy: 0,
      heading: 0,
      timestamp: DateTime.now(),
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
  }

  double calculateVincentyDistance(ll.LatLng start, ll.LatLng end) {
    const double a = 6378137.0; // WGS84 major axis
    const double b = 6356752.314245;
    const double f = 1 / 298.257223563; // WGS84 flattening
    double L = (end.longitude - start.longitude).toRadians();
    double U1 = atan((1 - f) * tan(start.latitude.toRadians()));
    double U2 = atan((1 - f) * tan(end.latitude.toRadians()));
    double sinU1 = sin(U1), cosU1 = cos(U1);
    double sinU2 = sin(U2), cosU2 = cos(U2);

    double lambda = L, lambdaP, iterLimit = 100;
    double cosSqAlpha, sinSigma, cos2SigmaM, cosSigma, sigma;
    do {
      double sinLambda = sin(lambda), cosLambda = cos(lambda);
      sinSigma = sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda) +
          (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) *
              (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda));
      if (sinSigma == 0) return 0; // co-incident points
      cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;
      sigma = atan2(sinSigma, cosSigma);
      double sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma;
      cosSqAlpha = 1 - sinAlpha * sinAlpha;
      cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;
      if (cos2SigmaM.isNaN) cos2SigmaM = 0; // equatorial line
      double C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
      lambdaP = lambda;
      lambda = L +
          (1 - C) *
              f *
              sinAlpha *
              (sigma +
                  C *
                      sinSigma *
                      (cos2SigmaM +
                          C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
    } while ((lambda - lambdaP).abs() > 1e-12 && --iterLimit > 0);

    if (iterLimit == 0) return 0; // formula failed to converge

    double uSq = cosSqAlpha * (a * a - b * b) / (b * b);
    double A =
        1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
    double B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));
    double deltaSigma = B *
        sinSigma *
        (cos2SigmaM +
            B /
                4 *
                (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) -
                    B /
                        6 *
                        cos2SigmaM *
                        (-3 + 4 * sinSigma * sinSigma) *
                        (-3 + 4 * cos2SigmaM * cos2SigmaM)));
    double s = b * A * (sigma - deltaSigma);

    return s;
  }

  double calculateAngle(ll.LatLng p1, ll.LatLng p2, ll.LatLng p3) {
    final vector1 =
        ll.LatLng(p2.latitude - p1.latitude, p2.longitude - p1.longitude);
    final vector2 =
        ll.LatLng(p3.latitude - p2.latitude, p3.longitude - p2.longitude);

    final dot = vector1.latitude * vector2.latitude +
        vector1.longitude * vector2.longitude;
    final mag1 = sqrt(vector1.latitude * vector1.latitude +
        vector1.longitude * vector1.longitude);
    final mag2 = sqrt(vector2.latitude * vector2.latitude +
        vector2.longitude * vector2.longitude);

    final cosAngle = dot / (mag1 * mag2);
    return acos(cosAngle) * (180 / pi); // Convert to degrees
  }

  double calculateArea() {
    if (corners.length < 3) return 0;
    double area = 0;
    for (int i = 0; i < corners.length; i++) {
      int j = (i + 1) % corners.length;
      area += (corners[i].longitude * corners[j].latitude -
          corners[j].longitude * corners[i].latitude);
    }
    area = (area.abs() / 2) *
        111319.9 *
        111319.9; // Rough conversion to square meters
    return area;
  }

  void markCorner() {
    if (currentLocation != null) {
      setState(() {
        corners.add(currentLocation!);
        _isMarking = true;
      });
    }
  }

  void closePolygon() {
    if (corners.length >= 3) {
      setState(() {
        _polygonClosed = true;
        corners.add(corners.first); // Close the polygon
      });
    }
  }

  List<Polyline> splitPolyline(List<ll.LatLng> points, int splitEvery) {
    List<Polyline> polylines = [];
    for (int i = 0; i < points.length; i += splitEvery) {
      int endIdx =
          (i + splitEvery < points.length) ? i + splitEvery : points.length;
      polylines.add(Polyline(
        points: points.sublist(i, endIdx),
        strokeWidth: 4.0,
        color: Colors.blue,
      ));
    }
    return polylines;
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!locationLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    double area = calculateArea();
    List<Polyline> splitPolylines = splitPolyline(route, 100);

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
              maxZoom: 23.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/quanbysolutions/cluhoxol502q801oi8od2cmvz/tiles/{z}/{x}/{y}?access_token={accessToken}',
                additionalOptions: {
                  'accessToken': widget.accessToken ??
                      'your_default_mapbox_access_token_here',
                },
              ),
              PolylineLayer(
                polylines: splitPolylines,
              ),
              PolygonLayer(
                polygons: [
                  if (_polygonClosed)
                    Polygon(
                      points: corners,
                      color: Colors.blue.withOpacity(0.3),
                      borderColor: Colors.blue,
                      borderStrokeWidth: 3,
                    ),
                ],
              ),
              MarkerLayer(
                markers: [
                  ...corners.map((corner) => Marker(
                        point: corner,
                        width: 15.0,
                        height: 15.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      )),
                  Marker(
                    point: currentLocation!,
                    width: 20.0,
                    height: 20.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
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
                    'Points: ${route.length}\n'
                    'Corners: ${corners.length}\n'
                    'Current: ${currentLocation?.latitude.toStringAsFixed(6)}, ${currentLocation?.longitude.toStringAsFixed(6)}',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Area: ${area.toStringAsFixed(2)} sq meters',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Total Distance: ${_totalDistance.toStringAsFixed(2)} meters',
                    style: TextStyle(fontSize: 12),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: markCorner,
                        child: Text('Mark Corner'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _polygonClosed ? null : closePolygon,
                        child: Text('Close Polygon'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              color: Colors.white.withOpacity(0.7),
              padding: EdgeInsets.all(8),
              child: Text(
                'GPS Accuracy: ${_recentPositions.isNotEmpty ? _recentPositions.last.accuracy.toStringAsFixed(2) : "N/A"} meters',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

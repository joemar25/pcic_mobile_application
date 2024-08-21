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

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/src/layer/marker_layer/marker_layer.dart' as fmap;
import 'package:latlong2/latlong.dart' as ll;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;
import 'package:connectivity_plus/connectivity_plus.dart';

class SearchableMapWidget extends StatefulWidget {
  const SearchableMapWidget({
    Key? key,
    this.width,
    this.height,
    required this.accessToken,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String accessToken;

  @override
  State<SearchableMapWidget> createState() => _SearchableMapWidgetState();
}

class _SearchableMapWidgetState extends State<SearchableMapWidget> {
  final TextEditingController _typeAheadController = TextEditingController();
  final MapController _mapController = MapController();
  ll.LatLng _center = ll.LatLng(0, 0);
  bool _isLoading = true;
  LatLngBounds? _boundaryBox;
  String _selectedAddress = '';
  double _downloadProgress = 0.0;
  bool _isDownloading = false;
  final FocusNode _focusNode = FocusNode();
  bool _mounted = true;
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_mounted) {
        _checkInternetConnectivity();
        _getCurrentLocation();
      }
    });
    _mapController.mapEventStream.listen((event) {
      if (event is MapEventMoveEnd && _mounted) {
        _updateBoundaryBox();
      }
    });
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.isNotEmpty) {
      setState(() {
        _hasInternet =
            results.any((result) => result != ConnectivityResult.none);
      });
    }
  }

  Widget _buildNoInternetMessage() {
    return Center(
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.signal_wifi_off,
                size: 60,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                'No Internet Connection',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Please check your network settings and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveStoreRegion(String storeName, LatLngBounds bounds) async {
    final md = FMTC.FMTCStore(storeName).metadata;
    await md.setBulk(kvs: {
      'region_north': bounds.north.toString(),
      'region_south': bounds.south.toString(),
      'region_east': bounds.east.toString(),
      'region_west': bounds.west.toString(),
    });
  }

  void _updateBoundaryBox() {
    if (!_mounted) return;
    setState(() {
      final bounds = _mapController.camera.visibleBounds;
      final center = bounds.center;
      final height = bounds.north - bounds.south;
      final width = bounds.east - bounds.west;
      _boundaryBox = LatLngBounds(
        ll.LatLng(
            center.latitude - height * 0.45, center.longitude - width * 0.45),
        ll.LatLng(
            center.latitude + height * 0.45, center.longitude + width * 0.45),
      );
    });
  }

  Future<void> _getCurrentLocation() async {
    if (!_mounted) return;

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (_mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (_mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (_mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true,
      );

      if (_mounted) {
        setState(() {
          _center = ll.LatLng(position.latitude, position.longitude);
          _isLoading = false;
        });

        Map<String, dynamic> addressInfo = await fetchAddressFromCoordinates(
          position.longitude,
          position.latitude,
        );

        if (_mounted) {
          String formattedAddress = _formatAddress(addressInfo);
          setState(() {
            _selectedAddress = formattedAddress;
            _typeAheadController.text = formattedAddress;
          });
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_mounted) {
            _mapController.move(_center, 17);
            _updateBoundaryBox();
          }
        });
      }
    } catch (e) {
      if (_mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatAddress(Map<String, dynamic> addressInfo) {
    List<String> addressParts = [];
    if (addressInfo['street'] != '') addressParts.add(addressInfo['street']);
    if (addressInfo['barangayVillage'] != '')
      addressParts.add(addressInfo['barangayVillage']);
    if (addressInfo['city'] != '') addressParts.add(addressInfo['city']);
    if (addressInfo['province'] != '')
      addressParts.add(addressInfo['province']);

    return addressParts.join(', ');
  }

  Future<Map<String, String>> reverseGeocoding(double lat, double lon) async {
    final String url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$lon,$lat.json?access_token=${widget.accessToken}&types=place,locality,neighborhood,address&limit=1';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List;
        if (features.isNotEmpty) {
          final feature = features[0];
          final List<String> addressParts = [];

          if (feature['text'] != null) addressParts.add(feature['text']);

          final context = feature['context'] as List? ?? [];
          for (var item in context) {
            if (item['id'].startsWith('neighborhood') ||
                item['id'].startsWith('locality') ||
                item['id'].startsWith('place') ||
                item['id'].startsWith('region')) {
              addressParts.add(item['text']);
            }
          }

          String formattedAddress = addressParts.join(', ');

          return {
            'formatted': formattedAddress,
            'raw': feature['place_name'],
          };
        }
      }
    } catch (e) {}
    return {'formatted': 'Unknown location', 'raw': ''};
  }

  void _refreshLocation() async {
    setState(() {
      _isLoading = true;
    });
    await _getCurrentLocation();
    setState(() {
      _isLoading = false;
    });
  }

  Future<List<Map<String, dynamic>>> forwardGeocoding(String query) async {
    final String url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=${widget.accessToken}&country=PH';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final features = data['features'] as List;
      return features.map((feature) {
        return {
          'place_name': feature['place_name'],
          'coordinates': feature['geometry']['coordinates'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load geocoding data');
    }
  }

  void _moveMap(ll.LatLng newCenter) {
    if (!_mounted) return;
    setState(() {
      _center = newCenter;
    });
    _mapController.move(newCenter, 17);
  }

  Future<void> _saveMap() async {
    if (!_mounted) return;
    _focusNode.unfocus();

    await _checkInternetConnectivity();
    if (!_hasInternet) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('No internet connection. Unable to download map.')),
      );
      return;
    }

    if (_boundaryBox == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an area to save the map.')),
      );
      return;
    }

    if (_selectedAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please select a location before saving the map.')),
      );
      return;
    }

    if (_isDownloading) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('A download is already in progress.')),
      );
      return;
    }

    setState(() {
      _isDownloading = true;
    });

    final String storeName = sanitizeStoreName(_selectedAddress);

    try {
      await FMTC.FMTCStore(storeName).manage.create();

      final region = FMTC.RectangleRegion(_boundaryBox!);
      final downloadableRegion = region.toDownloadable(
        minZoom: _mapController.camera.zoom.floor(),
        maxZoom: (_mapController.camera.zoom + 2).ceil(),
        options: TileLayer(
          urlTemplate:
              'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}@2x?access_token=${widget.accessToken}',
          additionalOptions: {
            'accessToken': widget.accessToken,
            'id': 'mapbox/satellite-v9',
          },
        ),
      );

      await FMTC.FMTCStore(storeName)
          .download
          .startForeground(
            region: downloadableRegion,
            parallelThreads: 15,
            maxBufferLength: 100,
            skipExistingTiles: true,
            skipSeaTiles: true,
            maxReportInterval: Duration(seconds: 1),
            instanceId: DateTime.now().millisecondsSinceEpoch,
          )
          .listen((progress) {
        setState(() {
          _downloadProgress = progress.percentageProgress / 100;
        });

        if (progress.isComplete) {
          _saveStoreRegion(storeName, _boundaryBox!);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Map download completed for $_selectedAddress')),
          );
          setState(() {
            _downloadProgress = 0.0;
            _isDownloading = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        _isDownloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save map: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: !_hasInternet
          ? Center(child: _buildNoInternetMessage())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TypeAheadField<Map<String, dynamic>>(
                          controller: _typeAheadController,
                          focusNode: _focusNode,
                          suggestionsCallback: (pattern) async {
                            if (pattern.isEmpty) return [];
                            return await forwardGeocoding(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                                title: Text(suggestion['place_name']));
                          },
                          onSelected: (suggestion) {
                            setState(() {
                              _selectedAddress = suggestion['place_name'];
                              _typeAheadController.text = _selectedAddress;
                            });
                            final lon = suggestion['coordinates'][0];
                            final lat = suggestion['coordinates'][1];
                            _moveMap(ll.LatLng(lat, lon));
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: _refreshLocation,
                      ),
                      IconButton(
                        icon: Icon(Icons.save),
                        onPressed: _saveMap,
                      ),
                    ],
                  ),
                ),
                if (_isDownloading)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: LinearProgressIndicator(
                      value: _downloadProgress,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: _center,
                            initialZoom: 17,
                            maxZoom: 22,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://api.mapbox.com/styles/v1/mapbox/satellite-streets-v12/tiles/{z}/{x}/{y}?access_token={accessToken}',
                              additionalOptions: {
                                'accessToken': widget.accessToken,
                              },
                            ),
                            MarkerLayer(
                              markers: [
                                fmap.Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: _center,
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 40.0,
                                  ),
                                ),
                              ],
                            ),
                            PolygonLayer(
                              polygons: [
                                if (_boundaryBox != null)
                                  Polygon(
                                    points: [
                                      _boundaryBox!.northWest,
                                      _boundaryBox!.northEast,
                                      _boundaryBox!.southEast,
                                      _boundaryBox!.southWest,
                                    ],
                                    color: Colors.blue.withOpacity(0.2),
                                    borderColor: Colors.blue,
                                    borderStrokeWidth: 2,
                                  ),
                              ],
                            ),
                          ],
                        ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _mounted = false;
    _focusNode.dispose();
    _mapController.dispose();
    super.dispose();
  }
}

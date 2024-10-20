// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom widgets

import 'dart:async';
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
  StreamSubscription? _downloadSubscription;
  bool _showDownloadDialog = false;
  int _tilesToDownload = 0;
  Object _downloadInstanceId = 0;
  bool _showMapInstructions = false;
  Timer? _instructionsTimer;

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
      'user_region_north': bounds.north.toString(),
      'user_region_south': bounds.south.toString(),
      'user_region_east': bounds.east.toString(),
      'user_region_west': bounds.west.toString(),
      'user_selected_name': _selectedAddress,
    });
  }

  void _startInstructionsTimer() {
    _instructionsTimer?.cancel();
    _instructionsTimer = Timer(Duration(seconds: 5), () {
      if (_mounted) {
        setState(() {
          _showMapInstructions = false;
        });
      }
    });
  }

  Widget _buildMapInstructions() {
    return AnimatedOpacity(
      opacity: _showMapInstructions ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.touch_app, color: Colors.white, size: 24),
            SizedBox(height: 4),
            Text(
              'Swipe to move',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            SizedBox(height: 8),
            Icon(Icons.zoom_in, color: Colors.white, size: 24),
            SizedBox(height: 4),
            Text(
              'Pinch-in to zoom.\nPinch-out to expand.',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
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

      // Show instructions when the boundary box is first created
      if (!_showMapInstructions) {
        _showMapInstructions = true;
        _startInstructionsTimer();
      }
    });
    print("Bounding box updated: ${_boundaryBox?.toString()}");
    _updateAddressFromBoundaryBox();
  }

  Future<void> _updateAddressFromBoundaryBox() async {
    if (_boundaryBox == null) return;

    final center = _boundaryBox!.center;
    print("Updating address for center: ${center.toString()}");

    final address = await reverseGeocoding(center.latitude, center.longitude);

    print("Reverse geocoding result: $address");

    setState(() {
      _selectedAddress = address['formatted']!;
      _typeAheadController.text = _selectedAddress;
    });
    print("Address updated to: $_selectedAddress");
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

  Future<Map<String, String>> reverseGeocoding(double lat, double lon) async {
    final String url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&addressdetails=1&countrycodes=PH';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'PCIC Tracking App'},
      );

      if (response.statusCode == 200) {
        final Map data = json.decode(response.body);
        final address = data['address'] as Map;

        // Extract address components.
        String street = address['road'] ?? '';
        String barangayVillage = address['village'] ?? address['suburb'] ?? '';
        String town = address['town'] ?? '';
        String city = address['city'] ?? address['city_district'] ?? '';
        String province = address['state'] ?? address['state_district'] ?? '';

        // Format the address as "street, barangayVillage, town, city, province".
        String formattedAddress = [
          street,
          barangayVillage,
          town,
          city,
          province,
        ].where((part) => part.isNotEmpty).join(', ');

        // Default to 'Loading...' if the address cannot be determined.
        if (formattedAddress.isEmpty) {
          formattedAddress = 'Loading...';
        }

        // Print the raw JSON for debugging.
        print('Reverse geocoding result: ${json.encode(data)}');

        // Return the formatted address and additional details.
        return {
          'formatted': formattedAddress,
          'barangayVillage': barangayVillage,
          'buildingName': address['building'] ?? '',
          'historic': address['historic'] ?? '',
          'city': city,
          'town': town,
          'province': province,
          'street': street,
          'raw': json.encode(data),
        };
      } else {
        print('Failed to fetch address: ${response.statusCode}');
        return {'formatted': 'Unknown location', 'raw': ''};
      }
    } catch (e) {
      print('Error fetching address: $e');
      return {'formatted': 'Unknown location', 'raw': ''};
    }
  }

  String _formatAddress(Map<String, dynamic> addressInfo) {
    return addressInfo['formatted'] ?? 'Loading...';
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
    _updateBoundaryBox(); // This will also trigger _updateAddressFromBoundaryBox()
  }

// Updated _saveMap function to extract store names
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

    // Get all available stores and extract their names
    final stats = FMTC.FMTCRoot.stats;
    final availableStores = await stats.storesAvailable;
    final storeNames = availableStores.map((store) => store.storeName).toList();

    // Determine the store that contains the user-defined bounding box
    String? targetStore = await _findMatchingStore(_boundaryBox!, storeNames);

    if (targetStore == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('No matching region store found for this area.')),
      );
      return;
    }

    try {
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
          userAgentPackageName: 'com.example.app',
        ),
      );

      _tilesToDownload =
          await FMTC.FMTCStore(targetStore).download.check(downloadableRegion);
      print('Number of tiles to download: $_tilesToDownload');

      setState(() {
        _isDownloading = true;
        _showDownloadDialog = true;
        _downloadProgress = 0.0;
      });

      _downloadInstanceId = DateTime.now().millisecondsSinceEpoch;

      _downloadSubscription = FMTC.FMTCStore(targetStore)
          .download
          .startForeground(
            region: downloadableRegion,
            parallelThreads: 15,
            maxBufferLength: 100,
            skipExistingTiles: true,
            skipSeaTiles: true,
            maxReportInterval: Duration(seconds: 1),
            instanceId: _downloadInstanceId,
          )
          .listen((progress) {
        setState(() {
          _downloadProgress = progress.percentageProgress / 100;
        });

        if (progress.isComplete) {
          _saveStoreRegion(targetStore, _boundaryBox!);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Map download completed for $_selectedAddress')),
          );
          setState(() {
            _downloadProgress = 0.0;
            _isDownloading = false;
            _showDownloadDialog = false;
          });
          _downloadSubscription?.cancel();
        }
      });
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _showDownloadDialog = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save map: $e')),
      );
    }
  }

// Updated _findMatchingStore to check for null values
  // Updated _findMatchingStore with stricter containment checks
  Future<String?> _findMatchingStore(
      LatLngBounds userBounds, List<String> availableStoreNames) async {
    for (var storeName in availableStoreNames) {
      final md = FMTC.FMTCStore(storeName).metadata;
      final metadata = await md.read;

      // Safely parse metadata values, ensuring they are not null
      double? minLat = double.tryParse(metadata['minLat'] ?? '');
      double? maxLat = double.tryParse(metadata['maxLat'] ?? '');
      double? minLon = double.tryParse(metadata['minLon'] ?? '');
      double? maxLon = double.tryParse(metadata['maxLon'] ?? '');

      // Continue if any of the values are null
      if (minLat == null ||
          maxLat == null ||
          minLon == null ||
          maxLon == null) {
        continue;
      }

      // Log the bounding box for debugging
      print('Checking store: $storeName');
      print(
          'Store bounding box: north: $maxLat, south: $minLat, east: $maxLon, west: $minLon');
      print(
          'User bounding box: north: ${userBounds.north}, south: ${userBounds.south}, east: ${userBounds.east}, west: ${userBounds.west}');

      // Strictly check if the user's bounding box is completely within the store's bounding box
      bool isWithinBounds = userBounds.south >= minLat &&
          userBounds.north <= maxLat &&
          userBounds.west >= minLon &&
          userBounds.east <= maxLon;

      if (isWithinBounds) {
        print('Matching store found: $storeName');
        return storeName;
      }
    }
    print('No matching store found for user bounds.');
    return null;
  }

  void _cancelDownload() async {
    await FMTC.FMTCStore(_selectedAddress)
        .download
        .cancel(instanceId: _downloadInstanceId);

    _downloadSubscription?.cancel();
    setState(() {
      _isDownloading = false;
      _showDownloadDialog = false;
      _downloadProgress = 0.0;
    });
    final mgmt = FMTC.FMTCStore(_selectedAddress).manage;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Map download cancelled')),
    );
  }

  Widget _buildDownloadProgressDialog() {
    return AlertDialog(
      title: Text('Downloading Map'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _downloadProgress),
          SizedBox(height: 16),
          Text('${(_downloadProgress * 100).toStringAsFixed(2)}%'),
          Text(
              'Tiles: ${(_downloadProgress * _tilesToDownload).toInt()} / $_tilesToDownload'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _cancelDownload,
          child: Text('Cancel'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                    Expanded(
                      child: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                initialCenter: _center,
                                initialZoom: 17,
                                minZoom: 16,
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
        ),
        if (_showDownloadDialog)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: _buildDownloadProgressDialog(),
              ),
            ),
          ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: _buildMapInstructions(),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _mounted = false;
    _focusNode.dispose();
    _mapController.dispose();
    _downloadSubscription?.cancel();
    super.dispose();
  }
}

// // Automatic FlutterFlow imports
// import '/backend/schema/structs/index.dart';
// import '/backend/supabase/supabase.dart';
// import '/backend/sqlite/sqlite_manager.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/custom_code/widgets/index.dart'; // Imports other custom widgets
// import '/custom_code/actions/index.dart'; // Imports custom actions
// import '/flutter_flow/custom_functions.dart'; // Imports custom functions
// import 'package:flutter/material.dart';
// // Begin custom widget code
// // DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map/src/layer/marker_layer/marker_layer.dart' as fmap;
// import 'package:latlong2/latlong.dart' as ll;
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;
// import 'package:connectivity_plus/connectivity_plus.dart';

// class SearchableMapWidget extends StatefulWidget {
//   const SearchableMapWidget({
//     Key? key,
//     this.width,
//     this.height,
//     required this.accessToken,
//   }) : super(key: key);

//   final double? width;
//   final double? height;
//   final String accessToken;

//   @override
//   State<SearchableMapWidget> createState() => _SearchableMapWidgetState();
// }

// class _SearchableMapWidgetState extends State<SearchableMapWidget> {
//   final TextEditingController _typeAheadController = TextEditingController();
//   final MapController _mapController = MapController();
//   ll.LatLng _center = ll.LatLng(0, 0);
//   bool _isLoading = true;
//   LatLngBounds? _boundaryBox;
//   String _selectedAddress = '';
//   double _downloadProgress = 0.0;
//   bool _isDownloading = false;
//   final FocusNode _focusNode = FocusNode();
//   bool _mounted = true;
//   bool _hasInternet = true;
//   StreamSubscription? _downloadSubscription;
//   bool _showDownloadDialog = false;
//   int _tilesToDownload = 0;
//   Object _downloadInstanceId = 0;
//   bool _showMapInstructions = false;
//   Timer? _instructionsTimer;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_mounted) {
//         _checkInternetConnectivity();
//         _getCurrentLocation();
//       }
//     });
//     _mapController.mapEventStream.listen((event) {
//       if (event is MapEventMoveEnd && _mounted) {
//         _updateBoundaryBox();
//       }
//     });
//     Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
//   }

//   Future<void> _checkInternetConnectivity() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     _updateConnectionStatus(connectivityResult);
//   }

//   void _updateConnectionStatus(List<ConnectivityResult> results) {
//     if (results.isNotEmpty) {
//       setState(() {
//         _hasInternet =
//             results.any((result) => result != ConnectivityResult.none);
//       });
//     }
//   }

//   Widget _buildNoInternetMessage() {
//     return Center(
//       child: Container(
//         width: 300,
//         height: 300,
//         decoration: BoxDecoration(
//           color: Theme.of(context).scaffoldBackgroundColor,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.signal_wifi_off,
//                 size: 60,
//                 color: Colors.red,
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'No Internet Connection',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Please check your network settings and try again.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _saveStoreRegion(String storeName, LatLngBounds bounds) async {
//     final md = FMTC.FMTCStore(storeName).metadata;
//     await md.setBulk(kvs: {
//       'region_north': bounds.north.toString(),
//       'region_south': bounds.south.toString(),
//       'region_east': bounds.east.toString(),
//       'region_west': bounds.west.toString(),
//     });
//   }

//   void _startInstructionsTimer() {
//     _instructionsTimer?.cancel();
//     _instructionsTimer = Timer(Duration(seconds: 5), () {
//       if (_mounted) {
//         setState(() {
//           _showMapInstructions = false;
//         });
//       }
//     });
//   }

//   Widget _buildMapInstructions() {
//     return AnimatedOpacity(
//       opacity: _showMapInstructions ? 1.0 : 0.0,
//       duration: Duration(milliseconds: 500),
//       child: Container(
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.7),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.touch_app, color: Colors.white, size: 24),
//             SizedBox(height: 4),
//             Text(
//               'Swipe to move',
//               style: TextStyle(color: Colors.white, fontSize: 12),
//             ),
//             SizedBox(height: 8),
//             Icon(Icons.zoom_in, color: Colors.white, size: 24),
//             SizedBox(height: 4),
//             Text(
//               'Pinch-in to zoom.\nPinch-out to expand.',
//               style: TextStyle(color: Colors.white, fontSize: 12),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _updateBoundaryBox() {
//     if (!_mounted) return;
//     setState(() {
//       final bounds = _mapController.camera.visibleBounds;
//       final center = bounds.center;
//       final height = bounds.north - bounds.south;
//       final width = bounds.east - bounds.west;
//       _boundaryBox = LatLngBounds(
//         ll.LatLng(
//             center.latitude - height * 0.45, center.longitude - width * 0.45),
//         ll.LatLng(
//             center.latitude + height * 0.45, center.longitude + width * 0.45),
//       );

//       // Show instructions when the boundary box is first created
//       if (!_showMapInstructions) {
//         _showMapInstructions = true;
//         _startInstructionsTimer();
//       }
//     });
//     print("Bounding box updated: ${_boundaryBox?.toString()}");
//     _updateAddressFromBoundaryBox();
//   }

//   Future<void> _updateAddressFromBoundaryBox() async {
//     if (_boundaryBox == null) return;

//     final center = _boundaryBox!.center;
//     print("Updating address for center: ${center.toString()}");

//     final address = await reverseGeocoding(center.latitude, center.longitude);

//     print("Reverse geocoding result: $address");

//     setState(() {
//       _selectedAddress = address['formatted']!;
//       _typeAheadController.text = _selectedAddress;
//     });
//     print("Address updated to: $_selectedAddress");
//   }

//   Future<void> _getCurrentLocation() async {
//     if (!_mounted) return;

//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       if (_mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//       return;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         if (_mounted) {
//           setState(() {
//             _isLoading = false;
//           });
//         }
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       if (_mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//       return;
//     }

//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best,
//         forceAndroidLocationManager: true,
//       );

//       if (_mounted) {
//         setState(() {
//           _center = ll.LatLng(position.latitude, position.longitude);
//           _isLoading = false;
//         });

//         Map<String, dynamic> addressInfo = await fetchAddressFromCoordinates(
//           position.longitude,
//           position.latitude,
//         );

//         if (_mounted) {
//           String formattedAddress = _formatAddress(addressInfo);
//           setState(() {
//             _selectedAddress = formattedAddress;
//             _typeAheadController.text = formattedAddress;
//           });
//         }

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (_mounted) {
//             _mapController.move(_center, 17);
//             _updateBoundaryBox();
//           }
//         });
//       }
//     } catch (e) {
//       if (_mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<Map<String, String>> reverseGeocoding(double lat, double lon) async {
//     final String url =
//         'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&addressdetails=1&countrycodes=PH';

//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {'User-Agent': 'PCIC Tracking App'},
//       );

//       if (response.statusCode == 200) {
//         final Map data = json.decode(response.body);
//         final address = data['address'] as Map;

//         // Extract address components.
//         String street = address['road'] ?? '';
//         String barangayVillage = address['village'] ?? address['suburb'] ?? '';
//         String town = address['town'] ?? '';
//         String city = address['city'] ?? address['city_district'] ?? '';
//         String province = address['state'] ?? address['state_district'] ?? '';

//         // Format the address as "street, barangayVillage, town, city, province".
//         String formattedAddress = [
//           street,
//           barangayVillage,
//           town,
//           city,
//           province,
//         ].where((part) => part.isNotEmpty).join(', ');

//         // Default to 'Loading...' if the address cannot be determined.
//         if (formattedAddress.isEmpty) {
//           formattedAddress = 'Loading...';
//         }

//         // Print the raw JSON for debugging.
//         print('Reverse geocoding result: ${json.encode(data)}');

//         // Return the formatted address and additional details.
//         return {
//           'formatted': formattedAddress,
//           'barangayVillage': barangayVillage,
//           'buildingName': address['building'] ?? '',
//           'historic': address['historic'] ?? '',
//           'city': city,
//           'town': town,
//           'province': province,
//           'street': street,
//           'raw': json.encode(data),
//         };
//       } else {
//         print('Failed to fetch address: ${response.statusCode}');
//         return {'formatted': 'Unknown location', 'raw': ''};
//       }
//     } catch (e) {
//       print('Error fetching address: $e');
//       return {'formatted': 'Unknown location', 'raw': ''};
//     }
//   }

//   String _formatAddress(Map<String, dynamic> addressInfo) {
//     return addressInfo['formatted'] ?? 'Loading...';
//   }

//   void _refreshLocation() async {
//     setState(() {
//       _isLoading = true;
//     });
//     await _getCurrentLocation();
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   Future<List<Map<String, dynamic>>> forwardGeocoding(String query) async {
//     final String url =
//         'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=${widget.accessToken}&country=PH';
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final features = data['features'] as List;
//       return features.map((feature) {
//         return {
//           'place_name': feature['place_name'],
//           'coordinates': feature['geometry']['coordinates'],
//         };
//       }).toList();
//     } else {
//       throw Exception('Failed to load geocoding data');
//     }
//   }

//   void _moveMap(ll.LatLng newCenter) {
//     if (!_mounted) return;
//     setState(() {
//       _center = newCenter;
//     });
//     _mapController.move(newCenter, 17);
//     _updateBoundaryBox(); // This will also trigger _updateAddressFromBoundaryBox()
//   }

//   Future<void> _saveMap() async {
//     if (!_mounted) return;
//     _focusNode.unfocus();

//     await _checkInternetConnectivity();
//     if (!_hasInternet) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text('No internet connection. Unable to download map.')),
//       );
//       return;
//     }

//     if (_boundaryBox == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select an area to save the map.')),
//       );
//       return;
//     }

//     if (_selectedAddress.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text('Please select a location before saving the map.')),
//       );
//       return;
//     }

//     if (_isDownloading) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('A download is already in progress.')),
//       );
//       return;
//     }

//     final String storeName = sanitizeStoreName(_selectedAddress);

//     try {
//       await FMTC.FMTCStore(storeName).manage.create();

//       final region = FMTC.RectangleRegion(_boundaryBox!);
//       final downloadableRegion = region.toDownloadable(
//         minZoom: _mapController.camera.zoom.floor(),
//         maxZoom: (_mapController.camera.zoom + 2).ceil(),
//         options: TileLayer(
//           urlTemplate:
//               'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}@2x?access_token=${widget.accessToken}',
//           additionalOptions: {
//             'accessToken': widget.accessToken,
//             'id': 'mapbox/satellite-v9',
//           },
//           userAgentPackageName: 'com.example.app',
//         ),
//       );

//       _tilesToDownload =
//           await FMTC.FMTCStore(storeName).download.check(downloadableRegion);
//       print('Number of tiles to download: $_tilesToDownload');

//       setState(() {
//         _isDownloading = true;
//         _showDownloadDialog = true;
//         _downloadProgress = 0.0;
//       });

//       _downloadInstanceId = DateTime.now().millisecondsSinceEpoch;

//       _downloadSubscription = FMTC.FMTCStore(storeName)
//           .download
//           .startForeground(
//             region: downloadableRegion,
//             parallelThreads: 15,
//             maxBufferLength: 100,
//             skipExistingTiles: true,
//             skipSeaTiles: true,
//             maxReportInterval: Duration(seconds: 1),
//             instanceId: _downloadInstanceId,
//           )
//           .listen((progress) {
//         setState(() {
//           _downloadProgress = progress.percentageProgress / 100;
//         });

//         if (progress.isComplete) {
//           _saveStoreRegion(storeName, _boundaryBox!);
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text('Map download completed for $_selectedAddress')),
//           );
//           setState(() {
//             _downloadProgress = 0.0;
//             _isDownloading = false;
//             _showDownloadDialog = false;
//           });
//           _downloadSubscription?.cancel();
//         }
//       });
//     } catch (e) {
//       setState(() {
//         _isDownloading = false;
//         _showDownloadDialog = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to save map: $e')),
//       );
//     }
//   }

//   void _cancelDownload() async {
//     await FMTC.FMTCStore(_selectedAddress)
//         .download
//         .cancel(instanceId: _downloadInstanceId);

//     _downloadSubscription?.cancel();
//     setState(() {
//       _isDownloading = false;
//       _showDownloadDialog = false;
//       _downloadProgress = 0.0;
//     });
//     final mgmt = FMTC.FMTCStore(_selectedAddress).manage;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Map download cancelled')),
//     );
//   }

//   Widget _buildDownloadProgressDialog() {
//     return AlertDialog(
//       title: Text('Downloading Map'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           LinearProgressIndicator(value: _downloadProgress),
//           SizedBox(height: 16),
//           Text('${(_downloadProgress * 100).toStringAsFixed(2)}%'),
//           Text(
//               'Tiles: ${(_downloadProgress * _tilesToDownload).toInt()} / $_tilesToDownload'),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: _cancelDownload,
//           child: Text('Cancel'),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           width: widget.width,
//           height: widget.height,
//           child: !_hasInternet
//               ? Center(child: _buildNoInternetMessage())
//               : Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: TypeAheadField<Map<String, dynamic>>(
//                               controller: _typeAheadController,
//                               focusNode: _focusNode,
//                               suggestionsCallback: (pattern) async {
//                                 if (pattern.isEmpty) return [];
//                                 return await forwardGeocoding(pattern);
//                               },
//                               itemBuilder: (context, suggestion) {
//                                 return ListTile(
//                                     title: Text(suggestion['place_name']));
//                               },
//                               onSelected: (suggestion) {
//                                 setState(() {
//                                   _selectedAddress = suggestion['place_name'];
//                                   _typeAheadController.text = _selectedAddress;
//                                 });
//                                 final lon = suggestion['coordinates'][0];
//                                 final lat = suggestion['coordinates'][1];
//                                 _moveMap(ll.LatLng(lat, lon));
//                               },
//                             ),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.refresh),
//                             onPressed: _refreshLocation,
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.save),
//                             onPressed: _saveMap,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: _isLoading
//                           ? Center(child: CircularProgressIndicator())
//                           : FlutterMap(
//                               mapController: _mapController,
//                               options: MapOptions(
//                                 initialCenter: _center,
//                                 initialZoom: 17,
//                                 minZoom: 16,
//                                 maxZoom: 22,
//                               ),
//                               children: [
//                                 TileLayer(
//                                   urlTemplate:
//                                       'https://api.mapbox.com/styles/v1/mapbox/satellite-streets-v12/tiles/{z}/{x}/{y}?access_token={accessToken}',
//                                   additionalOptions: {
//                                     'accessToken': widget.accessToken,
//                                   },
//                                 ),
//                                 MarkerLayer(
//                                   markers: [
//                                     fmap.Marker(
//                                       width: 80.0,
//                                       height: 80.0,
//                                       point: _center,
//                                       child: Icon(
//                                         Icons.location_on,
//                                         color: Colors.red,
//                                         size: 40.0,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 PolygonLayer(
//                                   polygons: [
//                                     if (_boundaryBox != null)
//                                       Polygon(
//                                         points: [
//                                           _boundaryBox!.northWest,
//                                           _boundaryBox!.northEast,
//                                           _boundaryBox!.southEast,
//                                           _boundaryBox!.southWest,
//                                         ],
//                                         color: Colors.blue.withOpacity(0.2),
//                                         borderColor: Colors.blue,
//                                         borderStrokeWidth: 2,
//                                       ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                     ),
//                   ],
//                 ),
//         ),
//         if (_showDownloadDialog)
//           Positioned.fill(
//             child: Container(
//               color: Colors.black54,
//               child: Center(
//                 child: _buildDownloadProgressDialog(),
//               ),
//             ),
//           ),
//         Positioned(
//           bottom: 16,
//           left: 0,
//           right: 0,
//           child: Center(
//             child: _buildMapInstructions(),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _mounted = false;
//     _focusNode.dispose();
//     _mapController.dispose();
//     _downloadSubscription?.cancel();
//     super.dispose();
//   }
// }

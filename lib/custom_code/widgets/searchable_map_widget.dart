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

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart'
    as FMTC; // Alias for tile caching
import 'package:mapbox_search/mapbox_search.dart';
import 'package:latlong2/latlong.dart' as ll; // Alias for latlong2

class SearchableMapWidget extends StatefulWidget {
  const SearchableMapWidget({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<SearchableMapWidget> createState() => _SearchableMapWidgetState();
}

class _SearchableMapWidgetState extends State<SearchableMapWidget> {
  final MapController mapController = MapController();
  ll.LatLng? currentLocation;
  List<FMTC.TileProvider> tileProviders = [];
  FMTC.TileCaching? tileCaching;
  String? searchedAddress;

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _initializeSearch();
    _initializeTileCaching();
  }

  void _initializeMap() {
    // Replace 'YOUR_MAPBOX_ACCESS_TOKEN' with your actual Mapbox access token
    tileProviders.add(
      FMTC.NetworkTileProvider(
        urlTemplate:
            'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
        tileWidth: 256,
        tileHeight: 256,
        zoom: 0,
        maxZoom: 19,
        id: 'mapbox/streets-v11',
        accessToken: 'YOUR_MAPBOX_ACCESS_TOKEN',
      ),
    );
  }

  void _initializeSearch() {
    // Replace 'YOUR_MAPBOX_ACCESS_TOKEN' with your actual Mapbox access token
    MapboxSearch.initialize(accessToken: 'YOUR_MAPBOX_ACCESS_TOKEN');
  }

  void _initializeTileCaching() {
    // Choose appropriate path for tile caching
    final cachePath =
        '${(await getApplicationDocumentsDirectory()).path}/map_cache';

    tileCaching = FMTC.TileCaching(
      tileProvider: tileProviders.first,
      cachePath: cachePath,
    );
  }

  Future<void> _searchAddress(String address) async {
    try {
      final response = await MapboxSearch.search(address);
      final firstResult = response.features.first;
      final geometry = firstResult.geometry;
      final latitude = geometry.coordinates[1];
      final longitude = geometry.coordinates[0];

      setState(() {
        currentLocation = ll.LatLng(latitude, longitude);
        searchedAddress = address;
        mapController.move(currentLocation!, 13);
      });
    } catch (e) {
      print('Error searching address: $e');
    }
  }

  Future<void> _downloadMapTiles(ll.LatLng location) async {
    if (tileCaching != null && currentLocation != null) {
      final bounds = ll.LatLngBounds.fromPoints([
        location,
        location,
      ]);
      await tileCaching.downloadTiles(bounds, zoom: 13);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: ll.LatLng(51.5, -0.09), // Initial center
                zoom: 13.0,
                interactiveFlags: InteractiveFlag.all,
              ),
              children: [
                TileLayer(
                  tileProvider: tileProviders.first,
                ),
                currentLocation != null
                    ? MarkerLayer(
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: currentLocation!,
                            builder: (ctx) => Icon(Icons.location_pin),
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter address',
              ),
              onSubmitted: (value) {
                _searchAddress(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Visibility(
              visible: currentLocation != null,
              child: ElevatedButton(
                onPressed: () {
                  if (currentLocation != null) {
                    _downloadMapTiles(currentLocation!);
                  }
                },
                child: Text('Download Map Tiles for ${searchedAddress ?? ''}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

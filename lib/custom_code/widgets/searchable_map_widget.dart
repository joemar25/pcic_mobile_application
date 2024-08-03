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
  final String accessToken = 'YOUR_MAPBOX_ACCESS_TOKEN';
  final TextEditingController _typeAheadController = TextEditingController();

  Future<List<Map<String, dynamic>>> forwardGeocoding(String query) async {
    final String url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$accessToken';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TypeAheadField<Map<String, dynamic>>(
              suggestionsCallback: (pattern) async {
                if (pattern.isEmpty) {
                  return [];
                }
                return await forwardGeocoding(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion['place_name']),
                );
              },
              onSelected: (suggestion) {
                _typeAheadController.text = suggestion['place_name'];
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(suggestion['place_name']),
                    content: Text(
                        'Coordinates: ${suggestion['coordinates'][1]}, ${suggestion['coordinates'][0]}'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

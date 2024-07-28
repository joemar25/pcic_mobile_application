import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/auth/supabase_auth/auth_util.dart';

double? getLat(LatLng? latlng) {
  return latlng?.latitude;
}

double? getLng(LatLng? latlng) {
  return latlng?.longitude;
}

String? removePpirOnString(String? text) {
  // remove the PPIR on the string
  return text?.replaceAll('PPIR', '');
}

String? sentenceCaseWords(String? text) {
  // sentence case each what is in the text
  if (text == null || text.isEmpty) {
    return text;
  }
  final words = text.split(' ');
  final capitalizedWords = words.map((word) {
    if (word.isEmpty) {
      return word;
    }
    final firstLetter = word[0].toUpperCase();
    final restOfWord = word.substring(1).toLowerCase();
    return '$firstLetter$restOfWord';
  });
  return capitalizedWords.join(' ');
}

LatLng kalmanFilterAlgo(
  double latitude,
  double longitude,
) {
  double q = 0.0001; // Process noise covariance
  double r = 0.01; // Measurement noise covariance
  double p = 1.0; // Estimation error covariance
  double k = 0.0; // Kalman gain

  double xLat = latitude; // Initial state for latitude
  double xLng = longitude; // Initial state for longitude

  /// Kalman filter calculation for latitude
  p = p + q;
  k = p / (p + r);
  xLat = xLat + k * (latitude - xLat);
  p = (1 - k) * p;

  /// Kalman filter calculation for longitude
  p = p + q;
  k = p / (p + r);
  xLng = xLng + k * (longitude - xLng);
  p = (1 - k) * p;

  /// Return the filtered LatLng coordinates
  return LatLng(xLat, xLng);
}

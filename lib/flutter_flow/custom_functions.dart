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

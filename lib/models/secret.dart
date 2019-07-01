import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

class Secret {
  final String geocodeApiKey;
  final String googleMapsAPI;

  Secret({this.geocodeApiKey, this.googleMapsAPI});

  factory Secret.fromJson(Map<String, dynamic> m) {
    var jsonKey = Platform.isAndroid ? 'google_maps_android' : 'google_maps_ios';
    return Secret(
      geocodeApiKey: m['google_geocode_api'],
      googleMapsAPI: m['$jsonKey'],
    );
  }
}

class SecretLoader{

  static Future<Secret> load(String path) {
    return rootBundle.loadStructuredData<Secret>(path, (jsonStr) async {
      final secret = Secret.fromJson(jsonDecode(jsonStr));
      return secret;
    });
  }
  
}

import 'dart:convert';

import 'package:flutter/services.dart';

class Secret {
  final String geocodeApiKey;

  Secret({this.geocodeApiKey});

  factory Secret.fromJson(Map<String, dynamic> m) {
    return Secret(geocodeApiKey: m['google_geocode_api']);
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
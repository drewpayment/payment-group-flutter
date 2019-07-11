import 'package:flutter/material.dart';
import 'package:pay_track/models/secret.dart';

class StaticMapProvider extends StatefulWidget {
  final int height;
  final int width;

  StaticMapProvider({this.height, this.width});

  @override
  _StaticMapProviderState createState() => _StaticMapProviderState(height, width);
}

class _StaticMapProviderState extends State<StaticMapProvider> {
  int height;
  int width;
  String apiKey;
  Uri renderUrl;
  static const int defaultHeight = 200;
  static const int defaultWidth = 300;
  Map<String, String> defaultLocation = {
    'latitude': '37.4219999',
    'longitude': '-122.0862462'
  };

  _StaticMapProviderState(this.height, this.width) {
    if (height == null) {
      height = defaultHeight;
    }
    if (width == null) {
      width = defaultWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: null,
      future: _buildUrl(),
      builder: (context, AsyncSnapshot<String> snap) {
        if (snap.hasData && snap.data.isNotEmpty) {
          return Image.network(snap.data);
        }

        return Container();
      },
    );
  }

  Future<String> _buildUrl() async {
    var secret = await SecretLoader.load('secrets.json');
    apiKey = secret.geocodeApiKey;

    return Uri(
      scheme: 'https',
      host: 'maps.googleapis.com',
      port: 443,
      path: '/maps/api/staticmap',
      queryParameters: {
        'size': '${width}x$height',
        'center': '${defaultLocation['latitude']},${defaultLocation['longitude']}',
        'zoom': '4',
        'key': '$apiKey',
      },
    ).toString();    
  }

}
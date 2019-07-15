import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:pay_track/bloc/location_bloc.dart';
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
  static const int defaultHeight = 300;
  static const int defaultWidth = 500;
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
    return StreamBuilder(
      initialData: null,
      stream: locationBloc.stream,
      builder: (context, AsyncSnapshot<LocationData> snap) {
        if (snap.hasData) {
          var location = snap.data;
          return FutureBuilder(
            initialData: null,
            future: _buildUrl(location),
            builder: (context, AsyncSnapshot<String> snap) {
              if (snap.hasData && snap.data.isNotEmpty) {
                return Image.network(snap.data);
              }

              return Container();
            },
          );
        }
        return Container();
      }
    );
  }

  Future<String> _buildUrl(LocationData loc) async {
    var secret = await SecretLoader.load('secrets.json');
    apiKey = secret.geocodeApiKey;

    var latitude = loc.latitude;
    var longitude = loc.longitude;

    return Uri(
      scheme: 'https',
      host: 'maps.googleapis.com',
      port: 443,
      path: '/maps/api/staticmap',
      queryParameters: {
        'size': '${width}x$height',
        'center': '$latitude,$longitude',
        'zoom': '4',
        'key': '$apiKey',
      },
    ).toString();    
  }

}


import 'package:flutter/material.dart';
import 'package:pay_track/models/current_weather.dart';

class WeatherSummary extends StatelessWidget {
  final Weather weather;

  WeatherSummary(this.weather);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FittedBox(
                fit: BoxFit.fitHeight,
                child: Chip(
                  backgroundColor: Colors.grey.shade300,
                  label: Row(
                    children: <Widget>[
                      Icon(Icons.navigation),
                      Text('${weather.location.name}'),
                    ],
                  ),
                  padding: EdgeInsets.all(5),
                ),
              ),
              const SizedBox(height: 10),
              Text('${weather.current.tempF.toStringAsFixed(0)} \u00b0',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.network('http:${weather.current?.condition?.icon}',
                    width: 50,
                    height: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('${weather.current.condition.text}'),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _getWeatherImage(),
          ),
        ],
      ),
    );
  }

  Widget _getWeatherImage() {
    var asset = _getImageAsset();

    return Image(
      image: AssetImage(asset),
      alignment: Alignment.centerRight,
    );
  }

  String _getImageAsset() {
    final w = weather?.current;
    if (w == null) return null;

    if (w.precipIn > 0 && w.tempC < 3) {
      return 'assets/weather/snow.png';
    } 

    if (w.precipIn > 0) {
      return 'assets/weather/rain.png';
    }

    if (w.windMph > 10) {
      return 'assets/weather/windy.png';
    }

    if (w.cloud > 25) {
      return 'assets/weather/cloudy.png';
    }

    var lastDt = DateTime.tryParse(w.lastUpdated);
    var year = DateTime.now().year;
    if (lastDt.isAfter(DateTime(year, 12, 24)) && lastDt.isBefore(DateTime(year, 12, 26))) {
      return 'assets/weather/christmas.png';
    }

    return 'assets/weather/sunny.png';
  }
}
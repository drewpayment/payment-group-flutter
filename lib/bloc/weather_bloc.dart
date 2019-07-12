
import 'package:location/location.dart';
import 'package:pay_track/data/http.dart';
import 'package:pay_track/data/repository.dart';
import 'package:pay_track/models/current_weather.dart';
import 'package:pay_track/models/parsed_response.dart';
import 'package:pay_track/models/secret.dart';
import 'package:rxdart/rxdart.dart';

class WeatherBloc {
  final String apiBase = 'api.apixu.com';
  final String path = 'v1';
  String _key;
  CurrentWeather _weather;
  final _weatherFetcher = BehaviorSubject<CurrentWeather>();

  Stream<CurrentWeather> get stream => _weatherFetcher.stream;

  void fetchWeather() async {
    ParsedResponse<CurrentWeather> result = ParsedResponse(NO_INTERNET, null);
    await _loadApiKey();
    var loc = Location();
    var location = await loc.getLocation();
    var uri = Uri(
      scheme: 'http',
      host: apiBase,
      path: '$path/current.json',
      queryParameters: {
        'key': '$_key',
        'q': '${location.latitude},${location.longitude}'
      },
    );

    // make api call and store response
    var resp = await HttpClient.getUri(uri);
    result = ParsedResponse(resp.statusCode, null);

    if (result.isOk()) {
      _weather = CurrentWeather.fromJson(resp.data);
      _weatherFetcher.add(_weather);
    }
  }

  _loadApiKey() async {
    final secret = await SecretLoader.load('secrets.json');
    _key = secret.weatherApi;
  }

  dispose() {
    _weatherFetcher.close();
  }

  WeatherBloc.init() {
    fetchWeather();
  }

}

final weatherBloc = WeatherBloc.init();
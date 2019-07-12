

class CurrentWeather {
  String lastUpdated;
  int lastUpdatedEpoch;
  double tempC;
  double tempF;
  double feelsLikeC;
  double feelsLikeF;
  String conditionText;
  String conditionIcon;
  int conditionCode;
  double windMph;
  double windKph;
  int windDegree;
  String windDir;
  double pressureMb;
  double pressureIn;
  double precipMm;
  double precipIn;
  int humidity;
  int cloud;
  bool isDay;
  double uv;
  double gustMph;
  double gustKph;

  CurrentWeather({this.lastUpdated, this.lastUpdatedEpoch, this.tempC, this.tempF, this.feelsLikeC, this.feelsLikeF, this.conditionIcon,
    this.conditionText, this.conditionCode, this.windDegree, this.windDir, this.windKph, this.windMph, this.pressureIn, this.pressureMb,
    this.cloud, this.gustKph, this.gustMph, this.humidity, this.isDay, this.precipIn, this.precipMm, this.uv});

  factory CurrentWeather.fromJson(Map<String, dynamic> m) {
    return CurrentWeather(
      lastUpdated: m['last_updated'],
      lastUpdatedEpoch: m['last_updated_epoch'],
      tempC: m['temp_c'],
      tempF: m['temp_f'],
      feelsLikeC: m['feels_like_c'],
      feelsLikeF: m['feels_like_f'],
      conditionCode: m['condition_code'],
      conditionIcon: m['condition_icon'],
      conditionText: m['condition_text'],
      windDegree: m['wind_degree'],
      windDir: m['wind_dir'],
      windKph: m['wind_kph'],
      windMph: m['wind_mph'],
      pressureIn: m['pressure_in'],
      pressureMb: m['pressure_mb'],
      precipIn: m['precip_in'],
      precipMm: m['precip_mm'],
      humidity: m['humidity'],
      cloud: m['cloud'],
      isDay: m['is_day'] == 1,
      uv: m['uv'],
      gustKph: m['gust_kph'],
      gustMph: m['gust_mph']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'last_updated': lastUpdated,
      'last_updated_epoch': lastUpdatedEpoch,
      'temp_c': tempC,
      'temp_f': tempF,
      'feels_like_c': feelsLikeC,
      'feels_like_f': feelsLikeF,
      'condition_code': conditionCode,
      'condition_icon': conditionIcon,
      'condition_text': conditionText,
      'wind_degree': windDegree,
      'wind_dir': windDir,
      'wind_kph': windKph,
      'wind_mph': windMph,
      'pressure_in': pressureIn,
      'pressure_mb': pressureMb,
      'precip_in': precipIn,
      'precip_mm': precipMm,
      'humidity': humidity,
      'cloud': cloud,
      'is_day': isDay ? 1 : 0,
      'uv': uv,
      'gust_kph': gustKph,
      'gust_mph': gustMph,
    };
  }

}
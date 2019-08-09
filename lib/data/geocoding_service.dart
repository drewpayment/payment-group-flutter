import 'package:pay_track/data/http.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:pay_track/data/repository.dart';
import 'package:pay_track/models/geocode_response.dart';
import 'package:pay_track/models/parsed_response.dart';
import 'package:pay_track/models/secret.dart';

class GeocodingService {
  final container = kiwi.Container();
  final api = 'https://maps.googleapis.com/maps/api/geocode/json';
  final countryFilter = 'country:US';
  
  Future<ParsedResponse<GeocodeResponse>> getGeocode(String address) async {
    var result = ParsedResponse<GeocodeResponse>(NO_INTERNET, null);
    final url = await _buildUrl(address);
    var resp = await HttpClient.get(url);

    result = ParsedResponse(resp.statusCode, null, message: resp.statusMessage);

    if (result.isOk()) {
      final g = GeocodeResponse.fromJson(resp.data);
      if (g.status != GeocodeResponseStatus.ok 
        && g.status != GeocodeResponseStatus.zeroResults) return ParsedResponse(400, g, message: g.status);

      result = ParsedResponse(resp.statusCode, g, message: g.status);
    }

    return result;
  }

  Future<String> _buildUrl(String address) async {
    var transformedAddress = address.replaceAll(' ', '+');
    final secret = await SecretLoader.load('secrets.json');
    return '$api?address=$transformedAddress&components=$countryFilter&key=${secret.geocodeApiKey}';
  } 

}

class GeocodeResponseStatus {
  static const ok = 'OK';
  static const zeroResults = 'ZERO_RESULTS';
  static const overDailyLimit = 'OVER_DAILY_LIMIT';
  static const overQueryLimit = 'OVER_QUERY_LIMIT';
  static const requestDenied = 'REQUEST_DENIED';
  static const invalidRequest = 'INVALID_REQUEST';
  static const unknownError = 'UNKNOWN_ERROR';
}
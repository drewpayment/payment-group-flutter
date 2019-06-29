import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:location/location.dart' as gps;
import 'package:pay_track/data/database.dart';
import 'package:pay_track/data/http.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:pay_track/models/geocode_response.dart';
import 'package:pay_track/models/parsed_response.dart';
import 'package:pay_track/models/secret.dart';

final int NO_INTERNET = 404;

class Repository {
  static final Repository _repo = new Repository._internal();

  KnockDatabase database;

  static Repository get() {
    return _repo;
  }

  Repository._internal() {
    database = KnockDatabase.get();
  }

  Future<ParsedResponse<List<Knock>>> getKnocks() async {
    ParsedResponse<List<Knock>> result = ParsedResponse(NO_INTERNET, null);
    
    var zipCodeResp = await _reverseLookupZipCode();
    String zipCode;
    if (zipCodeResp.isOk()) {
      zipCode = zipCodeResp.body;
    }

    String url = '${HttpClient.url('dnc-contacts?zip=$zipCode')}';
    var response = await HttpClient.get<List<dynamic>>(url);    
    result = ParsedResponse(response.statusCode, null);

    if (result.isOk()) {
      result = ParsedResponse(result.statusCode, KnockList.fromJson(response.data).knocks);
    }

    return result;
  }

  Future<ParsedResponse<String>> _reverseLookupZipCode() async {
    var location = gps.Location();
    var currLocation = await location.getLocation();

    if (currLocation == null) {
      return ParsedResponse(NO_INTERNET, null, 
        message: 'Could not determine location. Please make sure GPS is enabled.'
      );
    }

    var lat = currLocation.latitude;
    var lng = currLocation.longitude;
    var secret = await SecretLoader.load('secrets.json');
    var gUrl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${secret.geocodeApiKey}';

    var gresp = await HttpClient.get(gUrl);
    ParsedResponse<GeocodeResponse> gres = ParsedResponse(gresp.statusCode, null);

    // failed to get the reverse address information
    if (gres.hasError) {
      return ParsedResponse(gres.statusCode, null);
    }

    gres = ParsedResponse<GeocodeResponse>(gresp.statusCode, gresp.data);

    return ParsedResponse(
      200,
      gres.body.results.first.addressComponents.firstWhere((c) => c.types.contains('postal_code')).longName
    );
  }

  Future<ParsedResponse<Knock>> saveKnock(Knock dto) async {
    ParsedResponse<Knock> result = ParsedResponse(NO_INTERNET, null);
    String uri = dto.dncContactId != null ? '${HttpClient.url('dnc-contacts/${dto.dncContactId}')}' : '${HttpClient.url('dnc-contacts')}';
    var payload = json.encode(dto.toMap());
    var response = await HttpClient.post(uri, data: payload);
    result = ParsedResponse(response.statusCode, null);

    if (result.isOk()) {
      result = ParsedResponse(result.statusCode, Knock.fromJson(response.data));
    }
    return result;
  }

  Future close() async {
    return database.close();
  }
}
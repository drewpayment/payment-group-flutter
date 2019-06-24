import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pay_track/data/database.dart';
import 'package:pay_track/data/http.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:pay_track/models/parsed_response.dart';

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
    String url = '${HttpClient.url('dnc-contacts')}';
    var response = await HttpClient.get<List<dynamic>>(url);    
    result = ParsedResponse(response.statusCode, null);

    if (result.isOk()) {
      result = ParsedResponse(result.statusCode, KnockList.fromJson(response.data).knocks);
    }

    return result;
  }

  Future<ParsedResponse<Knock>> saveKnock(Knock dto) async {
    ParsedResponse<Knock> result = ParsedResponse(NO_INTERNET, null);
    String uri = '${HttpClient.url('dnc-contacts')}';
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
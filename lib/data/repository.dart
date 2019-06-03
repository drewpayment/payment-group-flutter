import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pay_track/auth/auth.dart';
import 'package:pay_track/data/database.dart';
import 'package:pay_track/data/http.dart';
import 'package:pay_track/environment.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:http/http.dart' as http;
import 'package:pay_track/models/parsed_response.dart';
// https://github.com/Norbert515/BookSearch/tree/v3/lib/data

// use this to help create repository


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
    String url = '$oldapi/dnc-contacts';

    var response = await HttpClient.get<List<dynamic>>(url);
    result = ParsedResponse(response.statusCode, null);

    if (result.isOk()) {
      result = ParsedResponse(result.statusCode, KnockList.fromJson(response.data).knocks);
    }

    return result;
  }

  // Future updateKnock(Knock knock) async {
  //   database.updateKnock(knock);
  // }

  Future close() async {
    return database.close();
  }
}
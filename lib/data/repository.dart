import 'dart:async';
import 'dart:convert';

import 'package:pay_track/auth/auth.dart';
import 'package:pay_track/data/database.dart';
import 'package:pay_track/environment.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:http/http.dart' as http;
// https://github.com/Norbert515/BookSearch/tree/v3/lib/data

// use this to help create repository
class ParsedResponse<T> {
  ParsedResponse(this.statusCode, this.body);

  final int statusCode;
  final T body;

  bool isOk() {
    return statusCode >= 200 && statusCode <= 300;
  }
}

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
    String token = Auth.idToken;
    var user = await Auth.fireBaseUser();
    String uid = user.uid;
    String url = '$api/dnc-contacts?fbid=$uid';

    http.Response response = await http.get(url, headers: {
        'Authorization': 'Bearer $token'
      })
      .catchError((resp) {});

    if (response == null) {
      return new ParsedResponse(NO_INTERNET, []);
    }

    if (response.statusCode >= 400) {
      return new ParsedResponse(response.statusCode, null);
    }

    print(response.statusCode);
    List<dynamic> list = json.decode(response.body);

    Map<String, Knock> networkKnocks = {};

    for(dynamic jsonKnock in list) {
      Knock knock = new Knock(
        dncContactId: jsonKnock['dncContactId'],
        clientId: jsonKnock['clientId'],
        firstName: jsonKnock['firstName'],
        lastName: jsonKnock['lastName'],
        description: jsonKnock['description'],
        address: jsonKnock['address'],
        addressCont: jsonKnock['addressCont'],
        city: jsonKnock['city'],
        state: jsonKnock['state'],
        zip: jsonKnock['zip'],
        lat: double.tryParse(jsonKnock['lat']) ?? 0,
        long: double.tryParse(jsonKnock['long']) ?? 0
      );

      networkKnocks[knock.dncContactId.toString()] = knock;
    }

    // List<Knock> databaseKnock = await database.getKnocks([]..addAll(networkKnocks.keys));
    // for(Knock knock in databaseKnock) {
    //   networkKnocks[knock.dncContactId.toString()] = knock;
    // }

    return new ParsedResponse(response.statusCode, []..addAll(networkKnocks.values));
  }

  // Future updateKnock(Knock knock) async {
  //   database.updateKnock(knock);
  // }

  Future close() async {
    return database.close();
  }
}
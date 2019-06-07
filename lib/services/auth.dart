import 'dart:async';
import 'package:dio/dio.dart';
import 'package:pay_track/data/http.dart';
import 'package:pay_track/data/repository.dart';
import 'package:pay_track/models/auth_response.dart';
import 'package:pay_track/models/parsed_response.dart';
import 'package:pay_track/models/user.dart';

class Auth {
  static String _token;
  static User _user;

  static User get user => _user;

  static set user(User value) {
    if (value == null) return;
    _user = value;
  }

  static Future<ParsedResponse<AuthResponse>> signIn(String username, String password) async {
    ParsedResponse<AuthResponse> result = ParsedResponse(NO_INTERNET, null);
    var url = '${HttpClient.url('authenticate')}';
    var resp = await HttpClient.post(url, 
      data: {
        'username': username,
        'password': password
      }
    );

    result = ParsedResponse(resp.statusCode, null);

    if (result.isOk()) {
      result = ParsedResponse<AuthResponse>(result.statusCode, AuthResponse.fromJson(resp.data));
      _user = result.body.user;
      _token = result.body.token;

      await _setInterceptorToken();
    }

    return result;
  }

  static bool isSignedIn() {
    return _user != null && _token != null;
  }

  static _setInterceptorToken() async {
    HttpClient.addInterceptor(InterceptorsWrapper(
      onRequest: (RequestOptions options) {
        options.headers.addAll({
          'authorization': 'Bearer $_token'
        });
        return options;
      },
    ));
  }

  static Future<bool> signOut() {
    var comp = Completer<bool>();
    _user = null;
    _token = null;
    comp.complete(true);
    return comp.future;
  }

}
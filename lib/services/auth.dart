import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pay_track/data/http.dart';
import 'package:pay_track/data/repository.dart';
import 'package:pay_track/models/auth_response.dart';
import 'package:pay_track/models/parsed_response.dart';
import 'package:pay_track/models/user.dart';
import 'package:pay_track/utils/storage_keys.dart';
import 'package:rxdart/rxdart.dart';

class Auth {
  static String _token;
  static User _user;
  static DateTime _tokenExpires;
  static Stream _authTimerSub;

  static PublishSubject<bool> _isAuthenticated$ = PublishSubject<bool>()..add(false);
  static Stream<bool> get isAuthenticated => _isAuthenticated$;

  static User get user => _user;
  static bool get hasActiveToken => _token != null && _tokenExpires != null;

  static set user(User value) {
    if (value == null) return;
    _user = value;
  }

  static Future<bool> hasTokenAuthentication() async {
    if (hasActiveToken) {
      return true;
    }

    final storage = FlutterSecureStorage();
    var store = await storage.readAll();

    _token = store[StorageKeys.TOKEN];
    _tokenExpires = DateTime.tryParse(store[StorageKeys.TOKEN_EXP]);

    if (_token != null && _tokenExpires != null && DateTime.now().isBefore(_tokenExpires)) {
      return true;
    }

    var signedOut = await Auth.signOut();

    if (signedOut) {
      return false;
    }
  }

  static Future<ParsedResponse<AuthResponse>> signIn(String username, String password) async {
    ParsedResponse<AuthResponse> result = ParsedResponse(NO_INTERNET, null);
    var url = '${HttpClient.url('authenticate')}';

    Response resp;
    try {
      resp = await HttpClient.post(url, 
        data: {
          'username': username,
          'password': password
        },
      );
    } on DioError catch(e) {
      if (e?.response?.statusCode == 401) {
        result = ParsedResponse(401, null, message: 'Unauthorized. Please try again.');
      } else {
        result = ParsedResponse(e?.response?.statusCode ?? 400, null, message: e?.message); 
      }
      return result;
    }

    result = ParsedResponse(resp.statusCode, null);

    if (result.isOk()) {
      result = ParsedResponse<AuthResponse>(result.statusCode, AuthResponse.fromJson(resp.data));
      _user = result.body.user;
      _token = result.body.token;
      _tokenExpires = DateTime.now().add(const Duration(days: 7));

      _isAuthenticated$.sink.add(true);

      final storage = FlutterSecureStorage();

      try {
        await storage.write(key: StorageKeys.TOKEN, value: _token);
        await storage.write(key: StorageKeys.TOKEN_EXP, value: _tokenExpires.millisecondsSinceEpoch.toString());
      } on PlatformException catch(e) {
        print(e.message);
      }

      _authenticationTimer();

      await _setInterceptorToken();
    }

    return result;
  }

  static void _authenticationTimer() {
    if (_authTimerSub == null) {
      var future = Future.delayed(const Duration(seconds: 30));
      _authTimerSub = future.asStream();
      _authTimerSub.asBroadcastStream().listen((Null) => _authenticationTimerHandler(_authTimerSub));
    }
  }

  static void _authenticationTimerHandler(Stream sub) {
    sub.listen((Null) async {
      if (_tokenExpires == null) {
        final storage = FlutterSecureStorage();
        var expMSSinceEpoch = await storage.read(key: StorageKeys.TOKEN_EXP);
        _tokenExpires = DateTime.tryParse('$expMSSinceEpoch');
      }
      
      if (DateTime.now().isAfter(_tokenExpires)) {
        Auth.signOut();
      }
    });
  }

  static bool isSignedIn() {
    return _user != null && _token != null && _tokenExpires != null;
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
    _isAuthenticated$.sink.add(false);

    comp.complete(true);
    return comp.future;
  }

  static void dispose() {
    _isAuthenticated$.close();
  }

}
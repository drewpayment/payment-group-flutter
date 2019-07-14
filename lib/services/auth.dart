import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pay_track/bloc/user_bloc.dart';
import 'package:pay_track/data/http.dart';
import 'package:pay_track/data/repository.dart';
import 'package:pay_track/models/auth_response.dart';
import 'package:pay_track/models/parsed_response.dart';
import 'package:pay_track/models/user.dart';
import 'package:pay_track/utils/storage_keys.dart';
import 'package:rxdart/rxdart.dart';

class Auth {
  static String _token;
  static DateTime _tokenExpires;
  static Stream _authTimerSub;
  static Timer _timer;

  static PublishSubject<bool> _isAuthenticated$ = PublishSubject<bool>()..add(false);
  static Stream<bool> get isAuthenticated => _isAuthenticated$.asBroadcastStream();

  static bool get hasActiveToken => _token != null && _tokenExpires != null;

  static Future<bool> hasTokenAuthentication() async {
    final storage = FlutterSecureStorage();
    var store = await storage.readAll();

    if (hasActiveToken) {
      return true;
    }

    _token = store[StorageKeys.TOKEN];
    _tokenExpires = DateTime.tryParse(store[StorageKeys.TOKEN_EXP]);

    if (_token != null && _tokenExpires != null && DateTime.now().isBefore(_tokenExpires)) {
      return true;
    }

    var signedOut = await Auth.signOut();

    if (signedOut) {
      return false;
    }

    return false;
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
      userBloc.setUser(result.body.user);
      _token = result.body.token;
      _tokenExpires = DateTime.now().add(const Duration(days: 7));

      _isAuthenticated$.sink.add(true);

      final storage = FlutterSecureStorage();

      try {
        await storage.write(key: StorageKeys.USER, value: jsonEncode(resp.data['user']));
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
    _timer = Timer(const Duration(seconds: 30), () async {
      final storage = FlutterSecureStorage();
      var expMSSinceEpoch = await storage.read(key: StorageKeys.TOKEN_EXP);
      _tokenExpires = DateTime.tryParse('$expMSSinceEpoch');
    });

    // if (_authTimerSub == null) {
    //   var future = Future.delayed(const Duration(seconds: 30));
    //   _authTimerSub = future.asStream();
    //   _authTimerSub.asBroadcastStream().listen((Null) => _authenticationTimerHandler(_authTimerSub));
    // }
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

  static void restoreStorage() async {
    final storage = FlutterSecureStorage();
    var store = await storage.readAll();

    var token = store[StorageKeys.TOKEN];
    var tokenExpiration = store[StorageKeys.TOKEN_EXP];
    var user = store[StorageKeys.USER];

    if (token != null) {
      _token = token;
    }

    if (tokenExpiration != null) {
      _tokenExpires = DateTime.tryParse(tokenExpiration);
    }

    if (user != null) {
      var u = User.fromJson(jsonDecode(user));
      userBloc.setUser(u);
    }
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
    userBloc.clear();
    _token = null;
    _isAuthenticated$.sink.add(false);
    _timer.cancel();

    comp.complete(true);
    return comp.future;
  }

  static void dispose() {
    _isAuthenticated$.close();
  }

}
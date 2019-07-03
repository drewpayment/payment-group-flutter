import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pay_track/models/user.dart';

class HttpClient {
  static User _user;
  static Dio _dio;
  static String _baseUrl;

  static User get user => _user;
  static String get baseUrl => _baseUrl;

  static set user(User user) {
    if (user == null) return;
    _user = user;
  }

  static String url(String path) {
    return '$_baseUrl/$path';
  }

  static _parseAndDecode(String response) {
    return jsonDecode(response);
  }
  
  static parseJson(String text) {
    return compute(_parseAndDecode, text);
  }

  static init(String url) {
    _baseUrl = url;

    if (_dio == null) _dio = Dio();
    (_dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;

    addInterceptor(InterceptorsWrapper(
      onError: (DioError err) {
        print(err.message);
      },
    ));
  }

  static addInterceptor(InterceptorsWrapper interceptor) {
    _dio.interceptors.add(interceptor);
  }

  static clear() {
    _dio.clear();
  }

  static Future<Response<T>> delete<T>(String path, {data, Map<String, dynamic> queryParameters, Options options, CancelToken cancelToken}) {
    return _dio.delete(path, 
      data: data, 
      queryParameters: queryParameters, 
      options: options, 
      cancelToken: cancelToken
    );
  }

  static Future<Response<T>> deleteUri<T>(Uri uri, {data, Options options, CancelToken cancelToken}) {
    return _dio.deleteUri(uri,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static Future<Response> download(String urlPath, savePath, {onReceiveProgress, Map<String, dynamic> queryParameters, CancelToken cancelToken, lengthHeader = HttpHeaders.contentLengthHeader, data, Options options}) {
    return _dio.download(urlPath, savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      lengthHeader: lengthHeader,
      data: data,
      options: options,
    );
  }

  static Future<Response> downloadUri(Uri uri, savePath, {onReceiveProgress, CancelToken cancelToken, lengthHeader = HttpHeaders.contentLengthHeader, data, Options options}) {
    return _dio.downloadUri(uri, savePath, 
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      lengthHeader: lengthHeader,
      data: data,
      options: options,
    );
  }

  static Future<Response<T>> get<T>(String path, {Map<String, dynamic> queryParameters, Options options, CancelToken cancelToken, onReceiveProgress}) {
    return _dio.get<T>(path, 
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response<T>> getUri<T>(Uri uri, {Options options, CancelToken cancelToken, onReceiveProgress}) {
    return _dio.getUri(uri, 
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response<T>> head<T>(String path, {data, Map<String, dynamic> queryParameters, Options options, CancelToken cancelToken}) {
    return _dio.head(path, 
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static Future<Response<T>> headUri<T>(Uri uri, {data, Options options, CancelToken cancelToken}) {
    return _dio.headUri<T>(uri,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static Interceptors get interceptors => _dio.interceptors;

  static lock() {
    _dio.lock();
  }

  static Future<Response<T>> patch<T>(String path, {data, Map<String, dynamic> queryParameters, Options options, CancelToken cancelToken, onSendProgress, onReceiveProgress}) {
    return _dio.patch<T>(path, 
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken, 
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response<T>> patchUri<T>(Uri uri, {data, Options options, CancelToken cancelToken, onSendProgress, onReceiveProgress}) {
    return _dio.patchUri<T>(uri,
      data: data,
      options: options, 
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response<T>> post<T>(String path, {data, Map<dynamic, dynamic> queryParameters, Options options, CancelToken cancelToken, onSendProgress, onReceiveProgress}) {
    return _dio.post<T>(path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response<T>> postUri<T>(Uri uri, {data, Options options, CancelToken cancelToken, onSendProgress, onReceiveProgress}) {
    return _dio.postUri<T>(uri,
      data: data,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response<T>> put<T>(String path, {data, Map<String, dynamic> queryParameters, Options options, CancelToken cancelToken, onSendProgress, onReceiveProgress}) {
    return _dio.put<T>(path, 
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response<T>> putUri<T>(Uri uri, {data, Options options, CancelToken cancelToken, onSendProgress, onReceiveProgress}) {
    return _dio.putUri<T>(uri,
      data: data,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response<T>> reject<T>(err) {
    return _dio.reject<T>(err);
  }

  static Future<Response<T>> request<T>(String path, {data, Map<String, dynamic> queryParameters, CancelToken cancelToken, Options options, onSendProgress, onReceiveProgress}) {
    return _dio.request<T>(path,
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response<T>> requestUri<T>(Uri uri, {data, CancelToken cancelToken, Options options, onSendProgress, onReceiveProgress}) {
    return _dio.requestUri<T>(uri,
      data: data,
      cancelToken: cancelToken,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response<T>> resolve<T>(response) {
    return _dio.resolve<T>(response);
  }

  static unlock() {
    _dio.unlock();
  }


}
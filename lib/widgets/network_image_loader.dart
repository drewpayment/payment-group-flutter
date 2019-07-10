

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pay_track/data/http.dart';

class NetworkImageLoader {
  String url; 
  Map<String, String> headers;

  NetworkImageLoader(this.url, {this.headers});
  
  Future<Uint8List> load() async {
    final Uri resolved = Uri.base.resolve(this.url);
    final Response<Uint8List> response = await HttpClient.get(this.url, 
      options: Options(
        responseType: ResponseType.bytes,
      ) 
    );
    if (response.data == null || response.statusCode != 200) 
      throw new Exception('HTTP request failed, status code: ${response.statusCode}, $resolved');
    
    final Uint8List bytes = response.data;
    if (bytes.lengthInBytes == 0)
      throw new Exception('NetworkImage is an empty file: $resolved');
    return bytes;
  }
}
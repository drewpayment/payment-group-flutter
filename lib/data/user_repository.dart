import 'package:dio/dio.dart';
import 'package:pay_track/data/http.dart';
import 'package:pay_track/models/parsed_response.dart';
import 'package:pay_track/models/user.dart';

class UserRepository {

  Future<ParsedResponse<User>> getUser() async {
    ParsedResponse result;
    var url = '${HttpClient.url('users')}';
    var resp = await HttpClient.get<Response<Map<String, dynamic>>>(url);

    result = ParsedResponse(resp.statusCode, resp.data);

    if (result.isOk()) {
      result = ParsedResponse<User>(result.statusCode, User.fromJson(result.body));
    }

    return result;
  }

}
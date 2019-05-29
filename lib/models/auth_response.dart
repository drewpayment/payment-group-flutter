import 'package:pay_track/models/user.dart';

class AuthResponse {
  String token; 
  User user; 

  AuthResponse({
    this.token,
    this.user
  });

  factory AuthResponse.fromJson(Map<String, dynamic> j) {
    return AuthResponse(
      token: j['token'],
      user: User.fromJson(j['user']),
    );
  }
}
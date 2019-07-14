

import 'package:pay_track/models/user.dart';
import 'package:rxdart/subjects.dart';

class UserBloc {

  User _user;
  final userFetcher = BehaviorSubject<User>();
  Stream<User> get stream => userFetcher.stream;

  User get user => _user;

  void setUser(User user) {
    _user = user;
    userFetcher.add(_user);
  }

  void clear() {
    _user = null;
    userFetcher.add(_user);
  }

  void dispose() {
    userFetcher.close();
  }

}

final userBloc = UserBloc();
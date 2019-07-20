import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:pay_track/models/user.dart';
import 'package:rxdart/subjects.dart';

class UserBloc {
  final _container = kiwi.Container();
  User _user;
  final userFetcher = BehaviorSubject<User>();
  Stream<User> get stream => userFetcher.stream;

  User get user => _user;

  void setUser(User user) {
    _user = user;
    userFetcher.add(_user);

    if (exists<User>()) {
      try {
        _container.unregister('user');
      } catch(err) {
        // we don't give a shit about this error
      }
    }
    
    _container.registerFactory<User, User>((c) => _user);
  }

  void clear() {
    _user = null;
    userFetcher.add(_user);
  }

  void dispose() {
    userFetcher.close();
  }

  bool exists<T>() {
    final type = _container.resolve<T>();
    return type != null;
  }

}

final userBloc = UserBloc();
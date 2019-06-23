

import 'package:rxdart/subjects.dart';

class RouteBloc {

  int _selectedRouteIndex = 0;
  final _selectedRoute = BehaviorSubject<int>();

  Stream<int> get selectedRoute => _selectedRoute.stream;

  RouteBloc() {
    _selectedRoute.sink.add(_selectedRouteIndex);
  }

  void setRoute(int value) {
    _selectedRouteIndex = value;
    _selectedRoute.sink.add(_selectedRouteIndex);
  }

  dispose() {
    if (!_selectedRoute.isClosed) {
      _selectedRoute.close();
    }
  }

}

final routeBloc = RouteBloc();
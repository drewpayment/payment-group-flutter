

import 'package:location/location.dart';
import 'package:rxdart/subjects.dart';

class LocationBloc {

  LocationData _location;
  final location = Location();
  final locationFetcher = BehaviorSubject<LocationData>();
  Stream<LocationData> get stream => locationFetcher.stream;

  init() async {
    _location = await location.getLocation();
    locationFetcher.add(_location);
  }

  dispose() {
    locationFetcher.close();
  }

}

final locationBloc = LocationBloc();
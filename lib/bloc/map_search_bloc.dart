import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart' as g;
import 'package:location/location.dart';
import 'package:pay_track/models/secret.dart';
import 'package:rxdart/rxdart.dart';

class MapSearchBloc {
  LatLng _center;
  Secret _secrets;
  g.GoogleMapsGeocoding _places;

  final _controller = BehaviorSubject<List<g.GeocodingResult>>();
  void Function(List<g.GeocodingResult>) get push => _controller.add;
  Stream<List<g.GeocodingResult>> get stream => _controller.asBroadcastStream();

  void searchPlaces(String searchText) async {
    var response = await _places.searchByAddress(
      searchText,
      components: <g.Component>[
        g.Component('country', 'US'),
      ],
    );

    if (response.isOkay && !response.hasNoResults) {
      mapSearchBloc.push(response.results);
    } else if (response.isInvalid) {
      print('Uhhh.... ${response.errorMessage}');
    } else {
      print('Status: ${response.status}');
      print('# of Results: ${response.results.length}');
    }
  }

  void loadMaps() async {
    _secrets = await SecretLoader.load('secrets.json');
    _center = await getUserLocation();
    _places = g.GoogleMapsGeocoding(apiKey: _secrets.geocodeApiKey);
  }

  Future<LatLng> getUserLocation() async {
    var location = Location();
    LocationData currentLocation;
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      // blackbox this error for now, dang it. 
    }

    if (currentLocation == null) {
      return null;
    }

    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }

  void dispose() {
    _controller?.close();
  }
   
}

final mapSearchBloc = MapSearchBloc();
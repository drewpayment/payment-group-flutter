import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pay_track/data/geocoding_service.dart';
import 'package:pay_track/data/repository.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:pay_track/models/parsed_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class KnockBloc {
  final container = kiwi.Container();
  GeocodingService geoService;
  List<Knock> _knocks;
  final _knockRepo = Repository.get();
  final _knockFetcher = BehaviorSubject<List<Knock>>();

  Function(List<Knock>) get changeKnocks => _knockFetcher.sink.add;

  Set<Marker> _markers;
  final _markerFetcher = BehaviorSubject<Set<Marker>>();

  Stream<Set<Marker>> get markerStream => _markerFetcher.stream; 
  Stream<List<Knock>> get knocksStream => _knockFetcher.stream;

  Set<Marker> get markers => _markers;
  List<Knock> get knocks => _knocks;

  GoogleMapController mapController;

  KnockBloc() {
    geoService = container<GeocodingService>();
    fetchAllKnocks();
  }

  void fetchAllKnocks() async {
    var knocksResp = await _knockRepo.getKnocks();
    if (knocksResp.isOk()) {
      _knocks = knocksResp.body;
      filterKnocksByBoundary();
    }
  }

  Future<ParsedResponse<Knock>> saveKnock(Knock knock) async {
    final id = knock.dncContactId ?? 0;
    var result = ParsedResponse<Knock>(NO_INTERNET, null, message: 'Initalization error. Please restart the app.');
    final knockLatLng = await _getGeocodeResponse(knock);
    
    // If we couldn't find lat/lng then we aren't going to be able to save the contact 
    // for use with the map
    if (!knockLatLng.isOk()) {
      return knockLatLng;
    }

    var resp = await _knockRepo.saveKnock(knockLatLng.body);

    if (resp.isOk()) {
      final updatedKnock = resp.body;
      result = ParsedResponse<Knock>(resp.statusCode, updatedKnock);

      if (id > 0) {
        for(var i = 0; i < _knocks.length; i++) {
          if (_knocks[i].dncContactId == updatedKnock.dncContactId) {
            _knocks[i] = updatedKnock;
          }
        }
      } else {
        _knocks.add(updatedKnock);
      }

      changeKnocks(_knocks);
    } else {
      result = ParsedResponse<Knock>(resp.statusCode, null, message: resp.message);
    }

    return result;
  }

  ///
  /// Makes call to Google Geocoding API to get the lat/lng coords for the 
  /// knock that the user is trying to save. This will get the information needed 
  /// to store it, but will also keep us from having to do this check in the api 
  /// and validate all of this information from there and should shorten api calls. 
  ///
  Future<ParsedResponse<Knock>> _getGeocodeResponse(Knock knock) async {
    var result = ParsedResponse<Knock>(NO_INTERNET, null);
    var addr = StringBuffer();
    addr.write('${knock.address}+');
    if (knock.addressCont != null) addr.write('${knock.addressCont}+');
    addr.write('${knock.city}+');
    addr.write('${knock.state}+');
    addr.write('${knock.zip}');
    final address = addr.toString();
    final gps = await geoService.getGeocode(address)..mergeStatus(result);

    if (result.isOk()) {
      final g = gps.body;

      // google api returns an invalid result or error
      if (g.status != GeocodeResponseStatus.ok) {
        final errorMessage = _buildGeocodingErrorMessage(g.status);
        return ParsedResponse<Knock>(gps.statusCode, knock, message: errorMessage);
      }
        
      final loc = g.results?.first?.geometry?.location;
      knock.lat = loc?.lat;
      knock.long = loc?.lng;
      result = ParsedResponse<Knock>(gps.statusCode, knock, message: g.status);
    } 

    return result;
  }

  String _buildGeocodingErrorMessage(String geocodeStatus) {
    String errorMessage;
    switch(geocodeStatus) {
      case GeocodeResponseStatus.invalidRequest: {
        errorMessage = 'Address component missing, please try again.';
      }
      break;
      case GeocodeResponseStatus.zeroResults: {
        errorMessage = 'Were unable to find coordinates for that address.';
      }
      break;
      case GeocodeResponseStatus.requestDenied:
      case GeocodeResponseStatus.unknownError:
      case GeocodeResponseStatus.overQueryLimit:
      case GeocodeResponseStatus.overDailyLimit:
      default: {
        errorMessage = 'Fatal error. Could not make request. Please contact support.';
      }
      break;
    }
    return errorMessage;
  }

  void _fetchMarkers(List<Knock> knocks) async {
    var marks = Set<Marker>();
    knocks.forEach((k) {
      marks.add(Marker(
        markerId: MarkerId(k.dncContactId.toString()),
        position: LatLng(k.lat, k.long),
        infoWindow: InfoWindow(
          title: '${k.address}',
          snippet: k.firstName != null ? '${k.firstName} ${k.lastName}' : '${k.description}',
        ),
      ));
    });
    _markers = marks;
    _markerFetcher.add(_markers);
  }

  void filterKnocksByBoundary() async {
    var filtered = List<Knock>();

    if (mapController != null) {
      final mapBounds = await mapController.getVisibleRegion();

      for (var i = 0; i < knocks.length; i++) {
        final kn = knocks[i];
        var pos = LatLng(kn.lat, kn.long);
        if (mapBounds.contains(pos)) {
          filtered.add(kn);
        }
      }
    } else {
      filtered = knocks;
    }

    _fetchMarkers(filtered);

    _knockFetcher.add(filtered);
  }

  void moveCameraPosition(LatLng target) {
    if (mapController != null) {
      mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: target)));
    }
  }

  void dispose() {
    _knockFetcher?.close();
    _markerFetcher?.close();
  }

}

final bloc = KnockBloc();
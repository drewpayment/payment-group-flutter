
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pay_track/data/repository.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:rxdart/rxdart.dart';

class KnockBloc {

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
    fetchAllKnocks();
  }

  void fetchAllKnocks() async {
    var knocksResp = await _knockRepo.getKnocks();
    if (knocksResp.isOk()) {
      _knocks = knocksResp.body;
      filterKnocksByBoundary();
    }
  }

  Future<Knock> saveKnock(Knock knock) async {
    var resp = await _knockRepo.saveKnock(knock);
    if (resp.isOk()) {
      final updatedKnock = resp.body;

      if (knock.dncContactId != null && knock.dncContactId > 0) {
        for(var i = 0; i < _knocks.length; i++) {
          if (_knocks[i].dncContactId == updatedKnock.dncContactId) {
            _knocks[i] = updatedKnock;
          }
        }
      } else {
        _knocks.add(updatedKnock);
      }

      changeKnocks(_knocks);

      return updatedKnock;
    } 
    return null;
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
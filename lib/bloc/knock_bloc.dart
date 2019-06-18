
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pay_track/data/repository.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:rxdart/rxdart.dart';

class KnockBloc {

  List<Knock> _knocks;
  final _knockRepo = Repository.get();
  final _knockFetcher = ReplaySubject<List<Knock>>(maxSize: 1);

  Set<Marker> _markers;
  final _markerFetcher = PublishSubject<Set<Marker>>();

  Stream<Set<Marker>> get markerStream => _markerFetcher.stream; 
  Stream<List<Knock>> get knocksStream => _knockFetcher.stream;

  Set<Marker> get markers => _markers;
  List<Knock> get knocks => _knocks;

  KnockBloc() {
    fetchAllKnocks();
  }

  void fetchAllKnocks() async {
    var knocksResp = await _knockRepo.getKnocks();
    if (knocksResp.isOk()) {
      _knocks = knocksResp.body;
      _knockFetcher.add(_knocks);
    }
  }

  void _fetchMarkers(List<Knock> knocks) async {
    var marks = Set<Marker>();
    knocks.forEach((k) {
      marks.add(Marker(
        markerId: MarkerId(k.dncContactId.toString()),
        position: LatLng(k.lat, k.long),
        infoWindow: InfoWindow(
          title: '${k.address}',
          snippet: '${k.description}',
        ),
      ));
    });
    _markers = marks;
    _markerFetcher.add(_markers);
  }

  void filterKnocksByBoundary(LatLngBounds bounds) async {
    var filtered = List<Knock>();

    knocksStream.take(1).listen((knocks) {
      knocks.forEach((kn) {
        var pos = LatLng(kn.lat, kn.long);

        if (bounds.contains(pos)) {
          filtered.add(kn);
        }
      });

      _fetchMarkers(filtered);

      _knockFetcher.add(filtered);
    });

    // _knocks.forEach((kn) {
    //   var pos = LatLng(kn.lat, kn.long);

    //   if (bounds.contains(pos)) {
    //     filtered.add(kn);
    //   }
    // });

    // _fetchMarkers(filtered);

    // _knockFetcher.add(filtered);
  }

  dispose() => _knockFetcher.close();

}

final bloc = KnockBloc();
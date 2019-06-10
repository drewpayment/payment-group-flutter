
import 'package:pay_track/data/repository.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:rxdart/rxdart.dart';

class KnockBloc {

  final _knockRepo = Repository.get();
  final _knockFetcher = PublishSubject<List<Knock>>();

  Stream<List<Knock>> get allKnocks => _knockFetcher.stream;

  void fetchAllKnocks() async {
    var knocksResp = await _knockRepo.getKnocks();
    if (knocksResp.isOk()) {
      _knockFetcher.add(knocksResp.body);
    }
  }

  dispose() => _knockFetcher.close();

}

final bloc = KnockBloc();
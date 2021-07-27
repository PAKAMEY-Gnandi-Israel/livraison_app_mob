
import 'package:livraison_mobile/api_service/repository.dart';
import 'package:livraison_mobile/models/Colis.dart';

import 'package:rxdart/rxdart.dart';
class ColisBloc {
  Repository _repository = Repository();

  //Create a PublicSubject object responsible to add the data which is got from
  // the server in the form of WeatherResponse object and pass it to the UI screen as a stream.
  final _ColisFetcher = PublishSubject<Colis>();


  Observable<Colis> get colis => _ColisFetcher.stream;

  fetchColis() async {
      Colis ColisResp = await _repository.fetchAllColis();
    _ColisFetcher.sink.add(ColisResp);
  }

  dispose() {
    //Close the Consultation fetcher
    _ColisFetcher.close();
  }
}

final colisBloc =ColisBloc();
import 'package:livraison_mobile/api_service/repository.dart';
import 'package:livraison_mobile/models/Utilisateur.dart';

import 'package:rxdart/rxdart.dart';

class UserBloc {
  Repository _repository = Repository();

  //Create a PublicSubject object responsible to add the data which is got from
  // the server in the form of WeatherResponse object and pass it to the UI screen as a stream.
  final _UserFetcher = PublishSubject<User>();


  Observable<User> get user => _UserFetcher.stream;

  fetchUser() async {
    User UserResp = await _repository.fetchUser();
    _UserFetcher.sink.add(UserResp);
  }

  dispose() {
    //Close the Consultation fetcher
    _UserFetcher.close();
  }
}

final userBloc =UserBloc();
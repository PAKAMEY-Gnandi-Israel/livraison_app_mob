import 'package:livraison_mobile/api_service/service.dart';
import 'package:livraison_mobile/models/Colis.dart';
import 'package:livraison_mobile/models/Utilisateur.dart';


class Repository {
  SpringServices appApiProvider = SpringServices();



  Future<User> fetchUser() => appApiProvider.getUser();


}
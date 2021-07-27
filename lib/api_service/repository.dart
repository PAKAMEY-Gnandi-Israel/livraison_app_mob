import 'package:livraison_mobile/api_service/service.dart';
import 'package:livraison_mobile/models/Colis.dart';

class Repository {
  SpringServices appApiProvider = SpringServices();

  Future<Colis> fetchAllColis() => appApiProvider.fetchColis();

 
}
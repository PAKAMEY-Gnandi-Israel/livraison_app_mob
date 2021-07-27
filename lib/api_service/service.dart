


import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:livraison_mobile/models/Colis.dart';

class SpringServices{

var url = "";

  Future<http.Response> updateColisStatut(String statut) {
    return http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'statut': statut,
      }),
    );
  }
Future<Colis> fetchColis() async {


  var response = await http.get(url);

  print(response.body.toString());

  if (response.statusCode == 200) {
    final jsonresponse = json.decode(response.body)[0];
    return Colis.fromJson(jsonresponse);
  }
  else
  {

// If that call was not successful, throw an error.
    throw Exception('Impossible de charger les colis');

  }
}
Future<Colis> getColis(int id) async{
  final response = await http.get('$url/colis/$id');

  if (response.statusCode == 200) {
    final jsonresponse = json.decode(response.body)[0];
    return Colis.fromJson(jsonresponse);
  }else
  {

// If that call was not successful, throw an error.
    throw Exception('Impossible de charger les  information sur le colis');

  }
}


}

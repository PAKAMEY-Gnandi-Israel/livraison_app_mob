


import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:livraison_mobile/models/Colis.dart';
import 'package:livraison_mobile/models/Utilisateur.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SpringServices{

  var url = "https://livraison-springboot-api.herokuapp.com";

  final storage = new FlutterSecureStorage();
  Future<http.Response> updateColisStatut(String statut, String titre) async{
    final jwt = await  storage.read(key: "jwt");
    return http.put(
      '$url/api/livraison/updateColisStatus',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${jwt}',
      },
      body: jsonEncode(<String, String>{
        'titre': titre,
        'statut': statut
      }),
    );
  }
  Future<http.Response> updateUser(String nom, String prenom, String email) async{
    final jwt = await  storage.read(key: "jwt");
    return http.put(
      '$url/api/livraison/utilisateur',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${jwt}',
      },
      body: jsonEncode(<String, String>{
        'nom': nom,
        'prenom': prenom,
        'email':email
      }),
    );
  }
  Future <List<Colis>> getAllColis() async{
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id') ?? 0;
    final jwt = await  storage.read(key: "jwt");
    print("go $id");
    final response = await http.get('$url/api/livraison/notUserColis/$id',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${jwt}',
        });

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new Colis.fromJson(data)).toList();

    }else
    {

// If that call was not successful, throw an error.
      throw Exception('Impossible de charger les  colis');

    }
  }

  Future<List<Colis>> getUserColis() async{
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id') ?? 0;
    final jwt = await  storage.read(key: "jwt");
    final response = await http.get('$url/api/livraison/userColis/$id',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${jwt}',
        });

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new Colis.fromJson(data)).toList();
    }else
    {

// If that call was not successful, throw an error.
      throw Exception('Impossible de charger les  colis livrés');

    }
  }

  Future<List<Colis>> getLivreurColis() async{
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id') ?? 0;
    final jwt = await  storage.read(key: "jwt");

    final response = await http.get('$url/api/livraison/livreurColis/$id',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${jwt}',
        });

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new Colis.fromJson(data)).toList();
    }else
    {

// If that call was not successful, throw an error.
      throw Exception('Impossible de charger les  colis livrés');

    }
  }

  Future<Colis> getColis(String titre) async{

    final jwt = await  storage.read(key: "jwt");
    final response = await http.get('$url/api/livraison/getOneColis/$titre',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwt',
        });

    if (response.statusCode == 200) {
      final jsonresponse = json.decode(response.body)[0];
      return Colis.fromJson(jsonresponse);
    }else
    {

// If that call was not successful, throw an error.
      throw Exception('Impossible de charger les  colis livrés');

    }
  }
  Future<User> getUser() async{
    final prefs = await SharedPreferences.getInstance();
    final jwt = await  storage.read(key: "jwt");
    final id = prefs.getInt('id') ?? 0;
    print("go $id");
    print("go $jwt");

    final response = await http.get('$url/api/utilisateur/getOneUser/$id',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwt',
        });

    if (response.statusCode == 200) {
      final jsonresponse = json.decode(response.body);
      return User.fromJson(jsonresponse);
    }else
    {

// If that call was not successful, throw an error.
      throw Exception('Impossible de charger vos informations');

    }
  }
  Future <String> saveP(int montant , String titre) async {
    final jwt = await  storage.read(key: "jwt");
    final email = await  storage.read(key: "email");
    var res = await http.post(url,
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer ${jwt}',},
        body: json.encode({'montant': montant,'email': email, 'titre': titre}));


    if(res.statusCode ==400){
      return'Il existe déjà un Colis de ce titre.';
    }

  }


}

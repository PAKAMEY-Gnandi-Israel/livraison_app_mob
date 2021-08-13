import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class User {
  int id;
  String nom;
  String prenom;
  String email;
  String password;


  User(this.id, this.nom, this.prenom, this.email, this.password);

  User.fromJson(Map<String, dynamic> parsedJson) {
    id= parsedJson['id'];
    nom= parsedJson['nom'];
    prenom = parsedJson['prenom'];
    email = parsedJson['email'];
    password = parsedJson['password'];

  }


  Map<String, dynamic> toJson() => {

  };
}

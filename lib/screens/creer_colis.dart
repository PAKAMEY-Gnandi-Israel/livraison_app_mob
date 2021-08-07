import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:livraison_mobile/screens/home.dart';
import 'package:livraison_mobile/screens/suivi_colis.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;

import 'gesliv.dart';

class CreerColis extends StatefulWidget {
  @override
  _CreerColisState createState() => _CreerColisState();
}

class _CreerColisState extends State<CreerColis> {

  final storage = new FlutterSecureStorage();
  String authorName, title, desc;
  String initValue="Selectionner la date échéante de livraison";
  bool isDateSelected= false;
  DateTime Date; // instance of DateTime
  String DateInString="Votre échéance de livraison";
  File selectedImage;
  File selectedImage2;
  bool _isLoading = false;
  bool _registerFormLoading = false;

  final url = 'https://livraison-springboot-api.herokuapp.com';
  double  prix ;
  String titre ="";
  String description="";
  String adresse_recup ="";
  String adresse_liv ="";

  String code_sec ="";
  String statut="en attente d'acceptation";
  double longueur;
  double largeur;
  double hauteur;
  double poids;

  var downloadUrl;
  var downloadUrl2;

  Future<void> _alertDialogBuilder( String error)async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text("Erreur"),
            content: Container(
              child:Text(error) ,
            ),
            actions: [
              FlatButton(onPressed:() {Navigator.pop(context);}, child:Text("Fermer"))
            ],
          );
        }
    );
  }
  Future<void> _alertDialogBuilder2( String Notif)async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text("Notification"),
            content: Container(
              child:Text(Notif) ,
            ),
            actions: [
              FlatButton(onPressed:() {Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SuiviColis(titre:titre)
                ),
              );}, child:Text("Fermer"))
            ],
          );
        }
    );
  }

  void _submitForm() async{
    //chargement oui
    setState(() {

      _registerFormLoading = true;

    }

    );

    //creation du compte
    // si le texte n'est pas nulle on a une erreur
    String _createAccountFeedback = await save();
    if( _createAccountFeedback !=null){
      _alertDialogBuilder(_createAccountFeedback);
      //chargement non
      setState(() {
        _registerFormLoading =false;

      });


    }else{
      _alertDialogBuilder2("Votre Colis a été bien créé");
    }
  }
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var image2 = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
      selectedImage2 = image2;
    });
  }

  Future <String> save() async {
    final jwt = await  storage.read(key: "jwt");
    print("this is jwt $jwt");
    String email = await  storage.read(key: "email");
    print("this is jwt $email");
    var res = await http.post('$url/api/livraison/saveColis',
        headers: <String, String> {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'},
        body: json.encode({'prix': prix,'titre': titre, 'description': description,'code_sec': code_sec, 'adresse_recup': adresse_recup, 'adresse_liv': adresse_liv, 'statut': statut, 'longueur': longueur,'largeur': largeur,'hauteur': hauteur,'poids': poids,'image_av': downloadUrl, 'image_ap':downloadUrl2 , 'date_echeance':DateInString,'email':email}));
    print("this is jwt $longueur");
    print("this is jwt $largeur");
    print("this is jwt $poids");
    if(res.statusCode ==400){
      return'Il existe déjà un Colis de ce titre.';
    }
    if(res.statusCode ==500){
      return'erreur serveur.';
    }

  }
  uploadColis() async {
    if (selectedImage2 != null && selectedImage != null) {
      setState(() {
        _isLoading = true;
      });



      /// uploading image to firebase storage
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("colisImages")
          .child("${randomAlphaNumeric(9)}.jpg");

      final StorageUploadTask task = firebaseStorageRef.putFile(selectedImage);
      final StorageUploadTask task2 = firebaseStorageRef.putFile(selectedImage2);
// je prends l'URL là et je le mets dans ma base de donnée
      downloadUrl = await (await task.onComplete).ref.getDownloadURL();
      downloadUrl2 = await (await task2.onComplete).ref.getDownloadURL();
      print("this is url $downloadUrl");
      print("this is url $downloadUrl2");
//code for uploading

      _submitForm();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Votre ",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "Colis",
              style: TextStyle(fontSize: 22, color: Colors.blue),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 5.0,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              uploadColis();
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.file_upload)),
          )
        ],
      ),
      body: _isLoading
          ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              TextField(
                textAlign:TextAlign.center,
                decoration: InputDecoration(hintText: "Image  avant l\'emballage"),
                readOnly: true,
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: selectedImage != null
                      ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(
                        selectedImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                      : Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    width: MediaQuery.of(context).size.width,
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.black45,
                    ),
                  )),

              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(hintText: "Titre"),
                        onChanged: (val) {
                          titre = val;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "Prix \F\C\F\A"),
                        onChanged: (val) {
                          prix = double.parse( val) ;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "Description"),
                        onChanged: (val) {
                          description = val;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "code secret"),
                        onChanged: (val) {
                          code_sec = val;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "Longueur \c\m"),
                        onChanged: (val) {
                          longueur =  double.parse( val);
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "Largeur \c\m "),
                        onChanged: (val) {
                          largeur = double.parse( val);
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "Hauteur \c\m"),
                        onChanged: (val) {
                          hauteur =double.parse( val) ;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "Poids \g"),
                        onChanged: (val) {
                          poids = double.parse( val) ;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "Point de récupération"),
                        onChanged: (val) {
                          adresse_recup = val;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "Adresse de livraison"),
                        onChanged: (val) {
                          adresse_liv = val;
                        },
                      ), SizedBox(
                        height: 8,
                      ), TextField(
                        decoration: InputDecoration(hintText: "${DateInString}"),
                        readOnly: true,
                      ),
                      GestureDetector(
                          child: new Icon(Icons.calendar_today),
                          onTap: ()async{
                            final datePick= await showDatePicker(
                                context: context,
                                initialDate: new DateTime.now(),
                                firstDate: new DateTime(1900),
                                lastDate: new DateTime(2100)
                            );
                            if(datePick!=null && datePick!=Date){
                              setState(() {
                                Date=datePick;
                                isDateSelected=true;

                                // put it here
                                DateInString = "${Date.day}/${Date.month}/${Date.year}"; // 08/14/2019

                              });
                            }
                          }
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "Image du colis après l\'emballage"),
                        readOnly: true,
                      ),

                      GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: selectedImage2 != null
                              ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(
                                selectedImage2,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                              : Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),

                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6)),
                            width: MediaQuery.of(context).size.width,
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.black45,
                            ),
                          )),



                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


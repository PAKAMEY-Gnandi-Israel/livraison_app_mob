


import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:livraison_mobile/api_service/service.dart';
import 'package:livraison_mobile/models/Colis.dart';
import 'package:livraison_mobile/screens/gesliv.dart';
import 'package:livraison_mobile/widgets/image_swipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants2.dart';

class ProductPage extends StatefulWidget {
  final String productTitle;
  final String image_ap;
  ProductPage({Key key, this.productTitle, this.image_ap}) : super(key: key);
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  var titre;

  var description;

  var adresse_recup;

  var adresse_liv;
  String code_sec="" ;

  var prix;
  var id;

  int count= 0;
  var largeur;
  var longueur;
  var hauteur;
var enginU;
  var enginC;
  var poids;
  var url = "https://livraison-springboot-api.herokuapp.com";
  Future<void> _alertDialogBuilder22( String error)async{

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text("Alerte"),
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
  final storage = new FlutterSecureStorage();
  Future<Colis> getColis(String titre) async{

    final jwt = await  storage.read(key: "jwt");
     enginU = await  storage.read(key: "engin");
    final response = await http.get('$url/api/livraison/getOneColis/$titre',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwt',
        });

    if (response.statusCode == 200) {
      final jsonresponse = json.decode(response.body);
      print("go $jsonresponse");
      return Colis.fromJson(jsonresponse);
    }else
    {

// If that call was not successful, throw an error.
      throw Exception('Impossible de charger les  colis livrés');

    }
  }


  Future <Colis> futureData;
  SpringServices service;
  @override
  void initState() {
    super.initState();
    futureData = getColis(widget.productTitle );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body:
      Stack(
          children: [
            FutureBuilder<Colis>(
              future:futureData,
              builder: (context, AsyncSnapshot<Colis> snapshot){
                if(snapshot.hasError){
                  return Scaffold(
                    body: Center(
                      child: Text("Error : ${snapshot.error}"),
                    ),
                  );
                }
                if(snapshot.hasData){

                  Colis Data = snapshot.data;
                  description= Data.description;
                  titre = Data.titre;
                  prix = Data.prix;
                  largeur = Data.largeur;
                  longueur = Data.longueur;
                  poids = Data.poids;
                  hauteur = Data.hauteur;
                  enginC = Data.engin;
                  adresse_liv = Data.adresse_liv;
                  adresse_recup = Data.adresse_recup;
                  print("go $titre");

                  print("go ${snapshot.data.image_ap}");
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: ListView(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20,top: 20),
                            child: InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(Icons.arrow_back_ios)),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Card(
                            elevation: 2,
                            child: Hero(
                              tag: titre,
                              child: Container(
                                height: 400,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: NetworkImage("${widget.image_ap}"),fit: BoxFit.cover)
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Titre :",style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5
                                ),),
                                SizedBox(width: 20,),
                                Flexible(
                                  child: Text(titre,style: TextStyle(
                                      fontSize: 16,
                                      height: 1.5
                                  ),),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Prix:",style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5
                                ),),
                                SizedBox(width: 20,),
                                Flexible(
                                    child: Row(children:
                                    <Widget>[
                                      Text(" $prix FCFA",style: TextStyle(
                                          fontSize: 16,height: 1.5
                                      ),),

                                    ],)
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Adresse de récupération :",style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5
                                ),),
                                SizedBox(width: 20,),
                                Flexible(
                                  child: Text(adresse_recup,style: TextStyle(
                                      fontSize: 16,
                                      height: 1.5
                                  ),),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Adresse de livraison :",style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5
                                ),),
                                SizedBox(width: 20,),
                                Flexible(
                                  child: Text(adresse_liv,style: TextStyle(
                                      fontSize: 16,
                                      height: 1.5
                                  ),),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Poids:",style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5
                                ),),
                                SizedBox(width: 20,),
                                Flexible(
                                  child: Text(" $poids g",style: TextStyle(
                                      fontSize: 16,
                                      height: 1.5
                                  ),),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Hauteur :",style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5
                                ),),
                                SizedBox(width: 20,),
                                Flexible(
                                  child: Text(" $hauteur cm",style: TextStyle(
                                      fontSize: 16,
                                      height: 1.5
                                  ),),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Largeur:",style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5
                                ),),
                                SizedBox(width: 20,),
                                Flexible(
                                  child: Text(" $largeur cm",style: TextStyle(
                                      fontSize: 16,
                                      height: 1.5
                                  ),),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Longueur :",style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5
                                ),),

                                Flexible(
                                  child: Text(" $longueur cm",style: TextStyle(
                                      fontSize: 16,
                                      height: 1.5
                                  ),),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Engin requis:",style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5
                                ),),
                                SizedBox(width: 20,),
                                Flexible(
                                  child: Text(" $enginC",style: TextStyle(
                                      fontSize: 16,
                                      height: 1.5
                                  ),),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),

                            child: GestureDetector(
                              onTap:() async{
if(enginC != enginU) {
  _alertDialogBuilder22("Votre engin ne correspont pas à l'engin requis : $enginC");
}else{
  Navigator.push(context, MaterialPageRoute(
    builder: (context) =>
        GesColis(titre: widget.productTitle,),
  ));
}
                              },
                              child: Container(
                                height: 30.0,
                                width: 10,
                                margin: EdgeInsets.only(
                                  left: 16.0,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12.0)
                                ),
                                alignment: Alignment.center,
                                child: Text("Accepter",

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                  );
                }

                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),]
      ),


    );

  }

}


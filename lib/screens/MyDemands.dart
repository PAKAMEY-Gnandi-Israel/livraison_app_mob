import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:livraison_mobile/models/Colis.dart';
import 'package:livraison_mobile/screens/ProductPage.dart';

import 'package:http/http.dart' as http;
import 'package:livraison_mobile/screens/suivi_colis.dart';
import 'package:livraison_mobile/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'EndSuivi.dart';
import 'home.dart';
class DemandPage extends StatefulWidget {
  @override
  _DemandPageState createState() => _DemandPageState();
}

class _DemandPageState extends State<DemandPage> {
  @override
  // Title List Here
  GlobalKey<ScaffoldState> _scaffoldKey;
  var titre;

  var description;

  var adresse_recup;

  var adresse_liv;

  var image_ap;

  var id;

  var hauteur;

  var poids;

  var prix;
  final storage = new FlutterSecureStorage();
  var url = "https://livraison-springboot-api.herokuapp.com";
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
      throw Exception('Impossible de charger les  Vos demandes');

    }
  }

  Future <List<Colis>> futureData;

  @override
  void initState() {
    GlobalKey<ScaffoldState> _scaffoldKey;
    super.initState();
    futureData = getUserColis();
  }
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width * 0.6;

    return  Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Mes ",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "Demandes",
              style: TextStyle(fontSize: 22, color: Colors.blue),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 5.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Home()
              ),
            );
          },
        ),
      ),
      body: RefreshIndicator(
        child: FutureBuilder  <List<Colis>> (
            future:futureData,

            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {


                List<Colis> data = snapshot.data;

                return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          print("vvvvvvvv ${data[index].titre}");
                          // This Will Call When User Click On ListView Item
                          showDialogFunc(context, data[index].titre ,data[index].description, data[index].image_ap);
                        },
                        // Card Which Holds Layout Of ListView Item
                        child: Card(
                          child: Row(
                            children: <Widget>[

                              Container(
                                width: 100,
                                height: 100,
                                child: Image.network("${data[index].image_ap}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "${data[index].titre}",
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: width,
                                      child: Text(

                                        "${data[index].prix} \F\C\F\A",
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.grey[500]),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });

              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              print(snapshot.hasData.toString());
              return Center(child: CircularProgressIndicator());
            }),
        onRefresh: () {
          return Future.delayed(
            Duration(seconds: 1),
                () {

              setState(() {
                futureData = getUserColis();
              });

              // showing snackbar
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: const Text('la page a été raffraichie'),
                ),
              );
            },
          );
        },
      ),
    );



  }
}

showDialogFunc(context, titre, desc,img) {
  return showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: Material(
                type: MaterialType.transparency,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(15),
                    height: 320,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network("$img" ,

                              width: 100,
                              height: 100,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            titre,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            // width: 200,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                desc,
                                maxLines: 3,
                                style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          CustomBtn(
                              text: "Suivre",
                              onPressed: () {

                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      EndSuivi(titre: titre),
                                ));
                              })
                        ]))));

      });


}
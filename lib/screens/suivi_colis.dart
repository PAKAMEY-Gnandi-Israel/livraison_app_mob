
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:livraison_mobile/api_service/service.dart';
import 'package:livraison_mobile/models/Colis.dart';

import 'package:progress_timeline/progress_timeline.dart';
import 'package:http/http.dart' as http;

import 'package:mobx/mobx.dart';
import 'package:ussd/ussd.dart';

import 'MyDemands.dart';
import 'home.dart';
class SuiviColis extends StatefulWidget {
  SuiviColis({Key key, this.title, this.titre}) : super(key: key);
  String title = "Suivi du colis" ;
  final String titre;

  @override
  _SuiviColisState createState() => _SuiviColisState();
}

class _SuiviColisState extends State<SuiviColis> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  ProgressTimeline screenProgress;
  final storage = new FlutterSecureStorage();
  final url = 'https://livraison-springboot-api.herokuapp.com';
  @observable
  String newStatut="";
  SpringServices service;
  String typep="";
  SingleState statutSingle;
Timer timer;
  Timer timer2;
  String statutActuel ;
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
                    builder: (context) => Home()
                ),
              );}, child:Text("Fermer"))
            ],
          );
        }
    );
  }
  Future<void> launchUssd(String ussdCode) async {
    Ussd.runUssd(ussdCode).then((v) => {_alertDialogBuilder2( "Votre paiement est passé avec succès.Merci de la confiance")});
  }

  bool _obscure_code_agent = true;
  bool _obscure_code_parking = true;
  final montantController = TextEditingController();
  final numLivreurController = TextEditingController();
  final codeAgentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String select;
double montantt;


  Future<Colis> getColis(String titre) async{

    final jwt = await  storage.read(key: "jwt");
    var response = await http.get('$url/api/livraison/getOneColis/$titre',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwt',
        });

    if (response.statusCode == 200) {
      print("gogogogo");
      final jsonresponse = json.decode(response.body);
      var data = Colis.fromJson(jsonresponse);
      print("go ${data.statut }");
      newStatut = data.statut;
      montantt = data.prix;
      print("gogo $newStatut");
      return Colis.fromJson(jsonresponse);

    }

  }
  List<SingleState> allStages = [
    SingleState(stateTitle: "Acceptee"),
    SingleState(stateTitle: "Colis pris"),
    SingleState(stateTitle: "En route"),
    SingleState(stateTitle: "Colis remis"),
    SingleState(stateTitle: "Fin",),
  ];

  @override
  void initState() {
    screenProgress = new ProgressTimeline(
      states: allStages,
      iconSize: 35,

    );

    super.initState();

    timer2 = Timer.periodic(Duration(seconds: 4), (Timer t) =>returSt());
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => checkForNewUpdate());

  }

void checkForNewUpdate() async {
  getColis(widget.titre);


  print("lol $newStatut");
  print("Dodo $statutActuel");
  if (newStatut == statutActuel  ) {
    screenProgress.state.gotoNextStage();
  }
}
  String returSt()  {

        statutSingle = allStages.elementAt(
            screenProgress.state.currentStageIndex);
        statutActuel = statutSingle.stateTitle;
        print("11 $statutActuel");
   return statutActuel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor:Colors.blueGrey,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DemandPage()
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(

        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(

                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: screenProgress,
              ),
            SizedBox(
              height: 90,
            ),
            FlatButton(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Payer",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              color: Colors.green,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Positioned(
                              right: -40.0,
                              top: -40.0,
                              child: InkResponse(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: CircleAvatar(
                                  child: Icon(Icons.close),
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[

                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      readOnly: true,
                                      keyboardType: TextInputType.number,
                                      controller: montantController,

                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.attach_money),


                                        ),
                                        labelText: "Montant",
                                        prefixIcon: Icon(Icons.attach_money),
                                        hintText: '$montantt',
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                      ),

                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.phone,
                                      controller: numLivreurController,

                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.settings_cell),


                                        ),
                                        labelText: "numéro du destinataire",
                                        prefixIcon: Icon(Icons.settings_cell),
                                        hintText: 'numéro du destinataire',
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Veillez remplir ce champ';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),



                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: codeAgentController,
                                      obscureText: _obscure_code_agent,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: _obscure_code_agent ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                                          onPressed: () => {
                                            setState(() {
                                              _obscure_code_agent = !_obscure_code_agent;
                                            })
                                          },
                                        ),
                                        labelText: "Code secret",
                                        prefixIcon: Icon(Icons.lock),
                                        hintText: 'Code Secret',
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Veillez remplir ce champ';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        RaisedButton(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.black)),
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _formKey.currentState.save();
                                              typep ="Tmoney";
                                              launchUssd(
                                                  "*145*1*${montantt.toString()} *${numLivreurController.text}*2*${codeAgentController
                                                      .text}#");
                                            }

                                            service.saveP(montantt,typep, widget.titre);
                                            },

                                          child:
                                          Image.asset(
                                            "assets/images/tmoney.jpg",
                                            width: 53.0,
                                          ),

                                        ),
                                        RaisedButton(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.black)),
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _formKey.currentState.save();
                                              typep ="Flooz";
                                              launchUssd(
                                                  "*155*1*1*"+numLivreurController.text+"*${montantController.text}*" +
                                                      codeAgentController
                                                          .text + "#");
                                              service.saveP(montantt,typep, widget.titre);
                                            }},
                                          child:
                                          Image.asset(
                                            "assets/images/flooz.jpg",
                                            width: 63.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                // screenProgress.gotoNextStage();
              },
            ),
            SizedBox(
              height: 50,
            ),

            SizedBox(
              height: 50,
            ),
            FlatButton(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Annuler",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              color: Colors.green,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              onPressed: () {
                screenProgress.failCurrentStage();
              },
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}





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

  SingleState statutSingle;

  String statutActuel;
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


  @computed
  Future<String> getColis(String titre) async{

    final jwt = await  storage.read(key: "jwt");
    final response = await http.get('$url/api/livraison/getOneColis/$titre',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${jwt}',
        });

    if (response.statusCode == 200) {
      final jsonresponse = json.decode(response.body)[0];
      var data = Colis.fromJson(jsonresponse);
      newStatut = data.statut;
      return Future.value(newStatut);
    }

  }
  List<SingleState> allStages = [
    SingleState(stateTitle: "en attente d'acceptation"),
    SingleState(stateTitle: "acceptée"),
    SingleState(stateTitle: "Colis récupéré"),
    SingleState(stateTitle: "En route"),
    SingleState(stateTitle: "Colis Livré"),
    SingleState(stateTitle: "Mission terminée",),
  ];

  @override
  void initState() {
    screenProgress = new ProgressTimeline(
      states: allStages,
      iconSize: 35,

    );
    super.initState();
    setState(() {
      _scaffoldKey = GlobalKey();
      const oneSecond = const Duration(seconds: 5);
      new Timer.periodic(oneSecond, (Timer t) => setState((){}));
      statutSingle = allStages.elementAt(
          screenProgress.state.currentStageIndex);
      statutActuel = statutSingle.stateTitle;
      if(newStatut.compareTo(statutActuel)==0){
        screenProgress.state.gotoNextStage();
      };
    });
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
            RefreshIndicator(
              onRefresh: () {
                return Future.delayed(
                  Duration(seconds: 1),
                      () {

                    setState(() {
                     getColis(widget.titre);
                     const oneSecond = const Duration(seconds: 5);
                     new Timer.periodic(oneSecond, (Timer t) => setState((){}));
                     statutSingle = allStages.elementAt(
                         screenProgress.state.currentStageIndex);
                     statutActuel = statutSingle.stateTitle;
                     if(newStatut.compareTo(statutActuel)==0) {
                       screenProgress.state.gotoNextStage();
                     }
                    });

                    // showing snackbar
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: const Text('le suivi a été raffraichi'),
                      ),
                    );
                  },
                );
              },
              child: Padding(

                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: screenProgress,
              ),
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
                                      keyboardType: TextInputType.number,
                                      controller: montantController,

                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.attach_money),


                                        ),
                                        labelText: "Montant",
                                        prefixIcon: Icon(Icons.attach_money),
                                        hintText: 'Montant',
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
                                              launchUssd(
                                                  "*145*1*${montantController.text} *${numLivreurController.text}*2*${codeAgentController
                                                      .text}#");
                                            }

                                            service.saveP(int.parse(montantController.text), widget.titre);},

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
                                              launchUssd(
                                                  "*155*1*1*"+numLivreurController.text+"*${montantController.text}*" +
                                                      codeAgentController
                                                          .text + "#");
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




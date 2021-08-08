
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:livraison_mobile/api_service/service.dart';
import 'package:livraison_mobile/screens/ColisLivrePage.dart';
import 'package:livraison_mobile/widgets/CustomBtn2.dart';
import 'package:progress_timeline/progress_timeline.dart';
import 'package:http/http.dart' as http;
import 'DemandPage.dart';


class GesColis extends StatefulWidget {
  GesColis({Key key, this.title, this.titre}) : super(key: key);
  String title = "Suivi du colis" ;
  final String titre;
  @override
  _GesColisState createState() => _GesColisState();
}
bool _registerFormLoading = false;
class _GesColisState extends State<GesColis> {
  var url = "https://livraison-springboot-api.herokuapp.com";

  final storage = new FlutterSecureStorage();
  Future<http.Response> updateColisStatut(String statut, String titre) async{
    final jwt = await  storage.read(key: "jwt");
    var res = await http.put(
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

  Future<String> updateColisLivreur(String titre) async{
    final jwt = await  storage.read(key: "jwt");
    final email = await  storage.read(key: "email");
    var res = await http.put(
      '$url/api/livraison/updateColisLivreur',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${jwt}',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'titre': titre

      }),
    );
    if(res.statusCode==400){
      return "Une erreur s'est produite veuillez patienter";
    }
    else if(res.statusCode==500){
      return "Une erreur s'est produite veuillez patienter";
    }

  }
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
                    builder: (context) => ColisLivre()
                ),
              );}, child:Text("Fermer"))
            ],
          );
        }
    );
  }

  void _submit() async{
    //chargement oui
    setState(() {

      _registerFormLoading = true;

    }

    );

    //creation du compte
    // si le texte n'est pas nulle on a une erreur
    String _SubFeedback = await updateColisLivreur(widget.titre);
    if( _SubFeedback !=null){
      _alertDialogBuilder(_SubFeedback);
      //chargement non
      setState(() {
        _registerFormLoading =false;

      });


    }else{
      _alertDialogBuilder2("Livraison terminée avec succès");
    }
  }


  ProgressTimeline screenProgress;
  SpringServices springServices;
  SingleState statutSingle;

  String statut;
  List<SingleState> allStages = [
    SingleState(stateTitle: "Acceptee"),
    SingleState(stateTitle: "Colis pris"),
    SingleState(stateTitle: "En route"),
    SingleState(stateTitle: "Colis remis"),
    SingleState(stateTitle: "Fin",),
  ];

  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 60;
  bool _isButtonDisabled=false;
  bool _isButton2Disabled=false;
  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(
          2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60)
          .toString()
          .padLeft(2, '0')}';

  @override
  void initState() {
    screenProgress = new ProgressTimeline(
      states: allStages,
      iconSize: 35,


    );
    super.initState();
  }

  bool countDownComplete = false;

  startTimeout([int milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          setState(() {
            countDownComplete = true;
          });
          timer.cancel();
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
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
                  _isButton2Disabled ? "Livraison terminée" :    "Passez à l'étape suivante",
                  style: _isButton2Disabled ? TextStyle(
                      fontSize: 20, color: Colors.grey) : TextStyle(
                      fontSize: 20, color: Colors.white),
                ),
                ),
              color: Colors.blueGrey,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              onPressed: () {
                screenProgress.gotoNextStage();
                setState(() {
                  statutSingle = allStages.elementAt(
                      screenProgress.state.currentStageIndex -1);
                  statut = statutSingle.stateTitle;
                  if (statut == "Acceptee"){
                    _isButtonDisabled=true;
                  }
                  if (statut == "Fin"){
                    _isButton2Disabled=true;
                  }
                  print("go $statut");
                  updateColisStatut( statut,widget.titre);
                });


              },
            ),
            SizedBox(
              height: 50,
            ),
            FlatButton(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  _isButtonDisabled ? "Livraison lancée" : "Annuler",
                  style: _isButtonDisabled ? TextStyle(
                      fontSize: 20, color: Colors.grey) : TextStyle(
                      fontSize: 20, color: Colors.white),
                ),
              ),
              color: Colors.blueGrey,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              onPressed: () {
                if (_isButtonDisabled){
                  return null;
                }else{
                  screenProgress.gotoPreviousStage();
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => DemandPage()));
                }


              },
            ),
            SizedBox(
              height: 50,
            ),
            CustomBtn2(
              text: "Mission terminée",
              onPressed: () {
                _submit();
              },
              isLoading: _registerFormLoading,
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

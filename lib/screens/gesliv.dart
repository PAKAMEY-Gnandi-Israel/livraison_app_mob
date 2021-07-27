
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livraison_mobile/api_service/service.dart';
import 'package:progress_timeline/progress_timeline.dart';

import 'home.dart';
class GesColis extends StatefulWidget {
  GesColis({Key key, this.title, this.titre}) : super(key: key);
  String title = "Suivi du colis" ;
  final String titre;
  @override
  _GesColisState createState() => _GesColisState();
}

class _GesColisState extends State<GesColis> {
  ProgressTimeline screenProgress;
SpringServices springServices;
  SingleState statutSingle;
  String statut;
  List<SingleState> allStages = [
    SingleState(stateTitle: " acceptée"),
    SingleState(stateTitle: "Colis récupéré"),
    SingleState(stateTitle: "En route"),
    SingleState(stateTitle: "Colis Livré"),
    SingleState(stateTitle: "Mission terminée"),
  ];

  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 60;
  bool _isButtonDisabled=false;
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
            onPressed: () {},
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
                    "Passez à l'étape suivante",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                color: Colors.blueGrey,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
                onPressed: () {
                  screenProgress.gotoNextStage();
                  statutSingle = allStages.elementAt(
                      screenProgress.state.currentStageIndex);
                  statut = statutSingle.stateTitle;
                  springServices.updateColisStatut( statut);
                },
              ),
              SizedBox(
                height: 50,
              ),
              FlatButton(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    _isButtonDisabled ? "Livraison lancé" : "Annuler",
                    style: _isButtonDisabled ? TextStyle(
                        fontSize: 20, color: Colors.grey) : TextStyle(
                        fontSize: 20, color: Colors.white),
                  ),
                ),
                color: Colors.blueGrey,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
                onPressed: () {
                  if (countDownComplete || statut == "Colis récupéré") {
                    _isButtonDisabled = true;
                  }
                  screenProgress.gotoPreviousStage();
                },
              ),
              SizedBox(
                height: 50,
              ),
              FlatButton(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Mission terminé",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                color: Colors.green,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Home(),
                      ));
                },
              )
            ],
          ),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      );
    }
  }


import 'package:flutter/material.dart';
import 'package:progress_timeline/progress_timeline.dart';
class SuiviColis extends StatefulWidget {
  SuiviColis({Key key, this.title, this.titre}) : super(key: key);
   String title = "Suivi du colis" ;
  final String titre;
  @override
  _SuiviColisState createState() => _SuiviColisState();
}

class _SuiviColisState extends State<SuiviColis> {
  ProgressTimeline screenProgress;

  List<SingleState> allStages = [
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
          onPressed: () {},
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
                screenProgress.gotoNextStage();
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
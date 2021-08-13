
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livraison_mobile/bloc/navigation_bloc/navigation_bloc.dart';

import 'package:livraison_mobile/screens/gesliv.dart';

import 'package:livraison_mobile/widgets/navigation_drawer_widget.dart';

import 'ColisLivrePage.dart';
import 'DemandPage.dart';

class HomeLiv extends StatelessWidget with NavigationStates {

  final globalKey = GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        drawer: NavigationDrawerWidget(),
        backgroundColor: Colors.white,
        body: SafeArea(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () => globalKey.currentState.openDrawer(),
                          child: Icon(
                            Icons.menu, color: Colors.black, size: 52.0,)),


                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Text(
                    "Bienvenue,en Mode Livreur ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20.0,
                      children: <Widget>[

                        SizedBox(
                          width: 160.0,
                          height: 160.0,
                          child: Card(
                            color: Colors.blueGrey,
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: GestureDetector(
                              onTap: () => {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ColisLivre()))
                              },
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/images/note.png",
                                          width: 63.0,
                                        ),

                                        Text(
                                          "Missions éffectuées ",
                                          style: TextStyle(color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 160.0,

                          child: Card(
                            color: Colors.white,
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: GestureDetector(
                              onTap: () => {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => DemandPage()))
                              },
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/images/historique.png",
                                          width: 64.0,
                                        ),

                                        Text(
                                          "requêtes de livraison ",
                                          style: TextStyle(color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 160.0,
                          height: 160.0,
                          child: Card(
                            color: Colors.white,
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: GestureDetector(
                              onTap: () => {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => GesColis()))
                              },
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/images/yes.png",
                                          width: 63.0,
                                        ),

                                        Text(
                                          "Gestion de la livraison",
                                          style: TextStyle(color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                )
              ],
            )));
  }

}
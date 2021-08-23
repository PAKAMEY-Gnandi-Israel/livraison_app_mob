
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livraison_mobile/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:livraison_mobile/screens/adresse_map.dart';

import 'package:livraison_mobile/screens/creer_colis.dart';
import 'package:livraison_mobile/screens/gesliv.dart';
import 'package:livraison_mobile/screens/profile_page.dart';
import 'package:livraison_mobile/screens/suivi_colis.dart';
import 'package:livraison_mobile/widgets/navigation_drawer_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'MyDemands.dart';

class Home extends StatelessWidget with NavigationStates {

  final globalKey = GlobalKey<ScaffoldState>();
  void launchWhatsApp(
      {@required int phone,
        @required String message,
      }) async {
    String url() {
      if (Platform.isAndroid) {
        // add the [https]
        return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
      } else {
        // add the [https]
        return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        drawer: NavigationDrawerWidget(),
        backgroundColor: Colors.white,
        body: SafeArea(

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () { globalKey.currentState.openDrawer() ;},
                            child: Icon(Icons.menu, color: Colors.black,size: 52.0,)),

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Text(
                      "Bienvenue,en Mode Client ",
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
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                              child: GestureDetector(
                                onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => MapView()))},
                                child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/calendar.png",
                                            width: 63.0,
                                          ),

                                          Text(
                                            "creer une mission",
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
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
                              color: Colors.blueGrey,
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                              child: GestureDetector(
                                onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => SuiviColis()))},
                                child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/todo.png",
                                            width: 62.0,
                                          ),
                                          SizedBox(
                                            height: 1.0,
                                          ),
                                          Text(
                                            "Suivi de mission",
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
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
                            child: Center(

                              child: Card(
                                color: Colors.blueGrey,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                child: GestureDetector(
                                  onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => DemandPage()))},
                                  child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,right:8.0,left: 8.0 ),
                                        child: Column(
                                          children: <Widget>[
                                            Image.asset(
                                              "assets/images/note.png",
                                              width: 63.0,
                                            ),

                                            Text(
                                              "Mes Demandes  ",
                                              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20.0),
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
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
    backgroundColor: Colors.green,
    hoverColor: Colors.green,
    child: const Icon(Icons.call),
    onPressed: () {
    launchWhatsApp(phone: 91021414, message: 'Bonjour Assistance Easy-Go Easy-Come , je rencontres un souci avec votre plateforme');
    },
    ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blueGrey,
        shape: CircularNotchedRectangle(),
    notchMargin: 4.0,
    child: new Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,

    ),
    ),
    );

  }
}
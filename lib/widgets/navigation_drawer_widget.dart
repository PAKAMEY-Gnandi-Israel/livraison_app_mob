import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:livraison_mobile/screens/EditProfilePage.dart';
import 'package:livraison_mobile/screens/ModeLiv.dart';
import 'package:livraison_mobile/screens/home.dart';
import 'package:livraison_mobile/screens/signin_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawerWidget extends StatefulWidget {
  @override
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  final storage = new FlutterSecureStorage();

  String email = '';
  String name = '';


  @override
  void initState() {
    super.initState();
    _loadvar();
  }
  void _loadvar() async {
    final emails = await  storage.read(key: "email");
    final noms = await  storage.read(key: "nom");
    setState(() {
      email = (emails ??"votreEmail@serveurmsg.com");
      name= (noms ??"votreNom");
    });
  }

  @override
  Widget build(BuildContext context) {




    final urlImage =
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80';

    return Drawer(
      child: Material(
        color: Colors.blueGrey,
        child: ListView(
          children: <Widget>[
            buildHeader(

              name: name,
              email: email,
              /*  onClicked: () =>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>EditProfilePage()
              )),*/
            ),
            Container(
              padding: padding,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Mode Livreur',
                    icon: Icons.delivery_dining,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Mode Client',
                    icon: Icons.supervised_user_circle_sharp,
                    onClicked: () => selectedItem(context, 1),
                  ),

                  const SizedBox(height: 24),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap:  ()  async {
                      final prefs = await SharedPreferences.getInstance();

                      await storage.deleteAll();
                      await await prefs.clear();
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SignInPage(),
                          ));
                    },
                    child: buildMenuItem(
                        text: 'Se déconnecter',
                        icon: Icons.exit_to_app
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({

    String name,
    String email,
    VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [

              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              Spacer(),
              CircleAvatar(
                radius: 24,
                backgroundColor: Color.fromRGBO(30, 60, 168, 1),
                child: Icon(Icons.add_comment_outlined, color: Colors.white),
              )
            ],
          ),
        ),
      );

  Widget buildMenuItem({
    String text,
    IconData icon,
    VoidCallback  onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomeLiv(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Home(),
        ));
        break;
    }
  }
}
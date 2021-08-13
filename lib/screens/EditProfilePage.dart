/*
import 'package:flutter/material.dart';
import 'package:livraison_mobile/api_service/service.dart';
import 'package:livraison_mobile/widgets/bt_widget.dart';
import 'package:livraison_mobile/widgets/txtWidget.dart';

import '../constants2.dart';


class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  var nom;
  var prenom;
  var email;

  String Nom ="";
  String Prenom ="";

  String Adresse ="";
  String Tel ="";

  String Email ="";
  SpringServices springServices;
  @override
  Widget build(BuildContext context) {
    userBloc.fetchUser();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xff555555),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:
          StreamBuilder(
              stream: userBloc.user,
              builder: (context, AsyncSnapshot<User> snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error : ${snapshot.error}"),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  User Data = snapshot.data;
                  nom=Data.nom;
                  ListView(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      physics: BouncingScrollPhysics(),
                      children: [

                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                        color: Colors.white10
                    ),
                      accountName: Padding(  padding: const EdgeInsets.only(left: 17.0 , right: 10.0),
                          child: Text( "$nom" ,style: Constants.regularDarkText)),

                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        child: Text("${nom[0]}" ,
                          style: Constants.Text,),

                      )
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: 'Nom',
                    text: Data.nom,
                    onChanged: (name) {
                      Nom = name;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: 'Prenom',
                    text: Data.prenom,
                    onChanged: (firstname) {
                      Prenom = firstname;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: 'Email',
                    text: Data.email,
                    onChanged: (email) {
                      Email = email;
                    },
                  ),
                  const SizedBox(height: 24),
                  ButtonWidget(
                    text: 'Modifier',
                    onClicked: () {

                      springServices.updateUser(Nom,Prenom,Email);
                    },
                  ),
                  const SizedBox(height: 24),
                  ]);
                }
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              })
    );


  }
}*/
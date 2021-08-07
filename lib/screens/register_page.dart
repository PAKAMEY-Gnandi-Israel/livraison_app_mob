import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

import 'package:livraison_mobile/constants2.dart';
import 'package:livraison_mobile/screens/screen.dart';

import 'package:livraison_mobile/widgets/custom_button.dart';
import '../widgets/widget.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisibility = true;
  bool _agreedToTOS = false;
  List gender=["Masculin","Feminin"];

  String initValue="Select your Birth Date";
  bool isDateSelected= false;
  DateTime birthDate; // instance of DateTime
  String birthDateInString ="Votre date de naissance";

  String select;
  String _registerNom ="";
  String _registerPrenom ="";
  String _registerAdresse ="";
  String _registerTel ="";

  String _registerEmail ="";
  String _registerPassword="";
  String _registerSituation ="";
  bool _registerFormLoading = false;
  final url = 'https://livraison-springboot-api.herokuapp.com/api/auth/signup';

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
                    builder: (context) => SignInPage()
                ),
              );}, child:Text("Fermer"))
            ],
          );
        }
    );
  }
  Future <String> save() async {
    var res = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'nom': _registerNom, 'prenom': _registerPrenom, 'email': _registerEmail, 'adresse': _registerAdresse, 'password': _registerPassword,'situation_pro': _registerSituation,'sexe': select,'birthday': birthDateInString,'num_tel': _registerTel }));


    if(res.statusCode ==400){
      return'Il existe déjà un Compte pour ce mail.';
    }

  }
  void _submitForm() async{
    //chargement oui
    setState(() {

      _registerFormLoading = true;

    }

    );

    //creation du compte
    // si le texte n'est pas nulle on a une erreur
    String _createAccountFeedback = await save();
    if( _createAccountFeedback !=null){
      _alertDialogBuilder(_createAccountFeedback);
      //chargement non
      setState(() {
        _registerFormLoading =false;

      });


    }else{
      _alertDialogBuilder2("Votre Compte a été bien créé");
    }
  }


  Future<void> _UseCondition( String Notif)async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text("Condition d'utilisation"),
            content: Container(
              child:SingleChildScrollView(child: Text(Notif)) ,
            ),
            actions: [
              FlatButton(onPressed:() {_setAgreedToTOS(!_agreedToTOS);Navigator.pop(context);}, child:Text("Lu et approuvé"))

            ],
          );
        }
    );
  }


  @override
  void initState() {
    super.initState();
    birthDateInString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image(
            width: 24,
            color: Colors.black,
            image: Svg('assets/images/back_arrow.svg'),
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rejoindre",
                            style: kHeadline,

                          ),
                          Text(
                            "Creer enfin votre compte.",
                            style: kBodyText2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "vous avez un Compte? ",
                                  style: kBodyText,
                                ),
                                Text(
                                  " Se connecter",
                                  style: kBodyText.copyWith(
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          MyTextField(
                            hintText: 'Nom',
                            inputType: TextInputType.name,
                            onChanged:(value){
                              _registerNom = value;
                            },
                          ),
                          MyTextField(
                            hintText: 'Prenom',
                            inputType: TextInputType.text,
                            onChanged:(value){
                              _registerPrenom = value;
                            },
                          ),
                          MyTextField(
                            hintText: 'adresse',
                            inputType: TextInputType.text,
                            onChanged:(value){
                              _registerAdresse = value;
                            },
                          ),
                          MyTextField(
                            hintText: 'situation professionelle',
                            inputType: TextInputType.text,
                            onChanged:(value){
                              _registerSituation= value;
                            },
                          ),
                          Row(
                            children: <Widget>[
                              addRadioButton(0, 'Masculin'),
                              addRadioButton(1, 'Feminin'),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ), TextField(
                            decoration: InputDecoration(hintText:"${birthDateInString}"),
                            readOnly: true,
                          ),
                          GestureDetector(
                              child: new Icon(Icons.calendar_today),
                              onTap: ()async{
                                final datePick= await showDatePicker(
                                    context: context,
                                    initialDate: new DateTime.now(),
                                    firstDate: new DateTime(1900),
                                    lastDate: new DateTime(2100)
                                );
                                if(datePick!=null && datePick!=birthDate){
                                  setState(() {
                                    birthDate=datePick;
                                    isDateSelected=true;

                                    // put it here
                                    birthDateInString = "${birthDate.day}/${birthDate.month}/${birthDate.year}"; // 08/14/2019

                                  });
                                }
                              }
                          ),
                          MyTextField(
                            hintText: 'Email',
                            inputType: TextInputType.emailAddress,
                            onChanged:(value){
                              _registerEmail = value;
                            },
                          ),
                          MyTextField(
                            hintText: 'Phone',
                            inputType: TextInputType.phone,
                            onChanged:(value){
                              _registerTel = value;
                            },
                          ),
                          MyPasswordField(
                            isPasswordVisible: passwordVisibility,
                            onTap: () {
                              setState(() {
                                passwordVisibility = !passwordVisibility;
                              });

                            },
                            onChanged:(value){
                              _registerPassword = value;
                            },
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: _agreedToTOS,
                            onChanged: _setAgreedToTOS,
                          ),
                          GestureDetector(
                            onTap: () => _UseCondition(Constants.CGU),
                            child: const Text(
                              'J\'accepte les termes et \n les conditions d\'utilisations',
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomBtn(
                      text: "S'enregistrer",
                      onPressed: () {
                        _submitForm();
                      },
                      isLoading: _registerFormLoading,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });

  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value){
            setState(() {
              print(value);
              select=value;
            });
          },
        ),
        Text(title)
      ],
    );
  }
}


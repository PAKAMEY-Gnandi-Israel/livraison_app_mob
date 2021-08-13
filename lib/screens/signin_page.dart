import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:livraison_mobile/screens/home.dart';

import 'package:livraison_mobile/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'screen.dart';

import '../widgets/widget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final url = 'https://livraison-springboot-api.herokuapp.com/api/auth/connexion';
  bool isPasswordVisible = true;
  String _signinEmail ="";
  String _signinPassword="";
  final storage = new FlutterSecureStorage();

  bool _registerFormLoading = false;
// set value

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


// set value



  Future <String> signin() async {
    final prefs = await SharedPreferences.getInstance();
    var res = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': _signinEmail , 'password':_signinPassword }));
    var  data = json.decode(res.body);
    if(res.statusCode ==404){
      return'votre email est incorrect.';
    }
    else if(res.statusCode ==401){
      return'votre mot de passe est incorrect.';
    }
    else if(res.statusCode ==200){

      prefs.setInt('id', data['id']);
      int id  = prefs.getInt("id");
      await storage.write(key: 'email', value: data['email']);
      await storage.write(key: 'engin', value: data['enginU']);
      await storage.write(key: 'nom', value: data['nom']);
      await storage.write(key: 'jwt', value: data['accessToken']);
      print("go $id");
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
    String _SigninAccountFeedback = await signin();
    if( _SigninAccountFeedback !=null){
      _alertDialogBuilder(_SigninAccountFeedback);
      //chargement non
      setState(() {
        _registerFormLoading =false;

      });


    }else{
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Home()
        ),
      );
    }
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white30,
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
        //to make page scrollable
        child: CustomScrollView(
          reverse: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bon retour.",
                            style: kHeadline,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Vous nous avez manqué!",
                            style: kBodyText2,
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          MyTextField(
                            hintText: ' email ',
                            inputType: TextInputType.text,
                            onChanged:(value){
                              _signinEmail = value;
                            },
                          ),
                          MyPasswordField(
                            isPasswordVisible: isPasswordVisible,
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            onChanged:(value){
                              _signinPassword = value;
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Vous avez déjà un compte? ",
                          style: kBodyText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => RegisterPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Créer',
                            style: kBodyText.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomBtn(
                      text: "Se connecter",
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
}

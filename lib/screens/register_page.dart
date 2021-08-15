
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:livraison_mobile/constants2.dart';
import 'package:livraison_mobile/screens/screen.dart';
import 'dart:io';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:livraison_mobile/widgets/custom_button.dart';
import 'package:random_string/random_string.dart';
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
  final _formKey = GlobalKey<FormState>();
  String initValue="Select your Birth Date";
  bool isDateSelected= false;
  DateTime birthDate; // instance of DateTime
  String birthDateInString ="Votre date de naissance";

  String select;
  String _registerNom ="";
  String _registerPrenom ="";
  String _registerAdresse ="";
  String _registerTel ="";
  String _registerEngin ="";
  String _registerEmail ="";
  String _registerPassword="";
  String _registerSituation ="";
  bool _registerFormLoading = false;
  File selectedImage;
  String dropdownValue = 'Moto';

  // To show Selected Item in Text.
  String holder = '' ;
  List <String> enginreq= [
    'Moto',
    'Voiture',
    'Pick up',
    'Camion',
  ] ;
  void getDropDownItem(){

    setState(() {
      holder = dropdownValue ;
    });
  }
  var downloadUrl;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);


    setState(() {
      selectedImage = image;

    });
  }
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
  Future<void> _alertDialogBuilder22( String error)async{

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text("Alerte"),
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
  Future <String> save() async {
    var res = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'nom': _registerNom, 'prenom': _registerPrenom, 'email': _registerEmail, 'adresse': _registerAdresse, 'password': _registerPassword,'situation_pro': _registerSituation,'sexe': select,'birthday': birthDateInString,'num_tel': _registerTel,'enginU': holder,'img_carte': downloadUrl   }));


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
  uploadUser() async {
    if (selectedImage != null && selectedImage != null) {
      setState(() {
        _registerFormLoading = true;
      });



      /// uploading image to firebase storage
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("carteGrise")
          .child("${randomAlphaNumeric(9)}.jpg");

      final StorageUploadTask task = firebaseStorageRef.putFile(selectedImage);

// je prends l'URL là et je le mets dans ma base de donnée
      downloadUrl = await (await task.onComplete).ref.getDownloadURL();

      print("this is url $downloadUrl");
//code for uploading

      _submitForm();
    } else {}
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
                child: Form(
                  key: _formKey,
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
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Veillez remplir ce champ';
                                }
                                return null;
                              },
                            ),
                            MyTextField(
                              hintText: 'Prenom',
                              inputType: TextInputType.text,
                              onChanged:(value){
                                _registerPrenom = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Veillez remplir ce champ';
                                }
                                return null;
                              },
                            ),
                            MyTextField(
                              hintText: 'adresse',
                              inputType: TextInputType.text,
                              onChanged:(value){
                                _registerAdresse = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Veillez remplir ce champ';
                                }
                                return null;
                              },
                            ),
                            MyTextField(
                              hintText: ' profession',
                              inputType: TextInputType.text,
                              onChanged:(value){
                                _registerSituation= value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Veillez remplir ce champ';
                                }
                                return null;
                              },
                            ),
                            TextField(
                              decoration: InputDecoration(hintText: "Sélectionner votre engin"),
                              readOnly: true,
                            ),

                            DropdownButton<String>(
                              value:dropdownValue,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black45, fontSize: 18),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String data) {
                                setState(() {
                               dropdownValue = data;
                               getDropDownItem();

                                });
                              },
                              items: enginreq.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),

                            ),
                            TextField(
                              decoration: InputDecoration(hintText: "Image de la Carte grise de l'engin"),
                              readOnly: true,
                            ),

                            GestureDetector(
                                onTap: () {
                                  getImage();
                                },
                                child: selectedImage != null
                                    ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  height: 170,
                                  width: MediaQuery.of(context).size.width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.file(
                                      selectedImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                                    : Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16),

                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6)),
                                  width: MediaQuery.of(context).size.width,
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.black45,
                                  ),
                                )),
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
                                      locale : const Locale("fr","FR"),
                                      initialDate: new DateTime.now(),
                                      firstDate: new DateTime(1900),
                                      lastDate: new DateTime(2100),
                                      builder: (BuildContext context, Widget child) {
                                    return Theme(
                                      data: ThemeData.dark(),
                                      child: child,
                                    );
                                  }
                                  );
                                  if(datePick!=null && datePick!=birthDate){
                                    setState(() {
                                      birthDate=datePick;
                                      isDateSelected=true;
                                     if( birthDate.year >=2010 && birthDate.year<=2021 ){
                                _alertDialogBuilder22("Votre Date de naissance est incorrecte");
                                     }
                                     else {
                                       // put it here
                                       birthDateInString =
                                       "${birthDate.day}/${birthDate
                                           .month}/${birthDate
                                           .year}"; // 08/14/2019
                                     }
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
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Veillez remplir ce champ';
                                }
                                return null;
                              },
                            ),
                            MyTextField(
                              hintText: 'Phone',
                              inputType: TextInputType.phone,
                              onChanged:(value){
                                _registerTel = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Veillez remplir ce champ';
                                }
                                return null;
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
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Veillez remplir ce champ';
                                }
                                return null;
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



import 'dart:io';
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instantchilling/Screens/register_page.dart';
import 'package:instantchilling/constants.dart';
import 'package:instantchilling/services/firebase_service.dart';
import 'package:instantchilling/widgets/CustomHome.dart';
import 'package:instantchilling/widgets/Product_restriction.dart';
import 'package:instantchilling/widgets/custom_action_bar.dart';
import 'package:instantchilling/widgets/image_swipe.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login_page.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  ProductPage({Key key, this.productId}) : super(key: key);
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  Future _addToCart(){
    return  _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .set({"size":1});
  }
  Future _addToSaved() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Saved")
        .doc(widget.productId)
        .set({"size": 0});
  }


  final SnackBar _snackBar = SnackBar(content: Text(" Whatsapp n'est pas installé sur votre telephone"),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            FutureBuilder(
              future: _firebaseServices.productsRef.doc(widget.productId).get(),
              builder: (context,snapshot){
                if(snapshot.hasError){
                  return Scaffold(
                    body: Center(
                      child: Text("Error : ${snapshot.error}"),
                    ),
                  );
                }
                if(snapshot.connectionState == ConnectionState.done){
                  Map<String ,dynamic> documentData = snapshot.data.data();
                  List imageList = documentData['images'];

                  return SafeArea(
                    child: ListView(
                      padding: EdgeInsets.all(5),
                      children: [
                        ImageSwipe(
                          imageList: imageList,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(

                            top: 24.0,
                            left: 24.0,
                            right: 24.0,
                            bottom: 2.0,
                          ),
                          child: Text( "${documentData['name']}",
                            style: Constants.bolHeading,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 24.0,
                          ),
                          child: Text("${documentData['price'] } \F\C\F\A",
                            style: Constants.IzzyText,),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 24.0
                          ),
                          child: Text("Description" ,
                            style: Constants.regularDarkText, ),
                        ),  Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 24.0,
                          ),
                          child: Text(
                            "${documentData['desc']}",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 100.0),

                          child: GestureDetector(
                            onTap:() async{

                              var phone = "+22891021414";
                              var texte =  "Je suis intéresseé par ce jeu du nom de ${documentData['name']}. \n \n Description: ${documentData['desc']}. \n \n Prix: ${documentData['price'] } \F\C\F\A \n \n image: ${documentData['images'][0].toString()}&token=d19c5455-b87c-4537-a6ab-71b2ddb651a6"
                              ;

                              var whatsappUrl ="whatsapp://send?phone=$phone&text=$texte";
                              await canLaunch(whatsappUrl)? launch(whatsappUrl): Scaffold.of(context).showSnackBar(_snackBar);
                            },
                            child: Container(
                              height: 65.0,
                              margin: EdgeInsets.only(
                                left: 16.0,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0)
                              ),
                              alignment: Alignment.center,
                              child: Text("Reserver",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }

                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
            CustomHome(
              hasTitle: false,
              hasBackArrow:true,
              hasBackground: false,
            ),
          ]
      ),
    );
  }
}
*/
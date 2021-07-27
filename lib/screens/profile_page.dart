
import 'package:flutter/material.dart';
import 'package:livraison_mobile/widgets/custom_text.dart';
import 'package:livraison_mobile/widgets/my_password_field.dart';
import 'package:livraison_mobile/widgets/my_text_field.dart';

import '../constants2.dart';

class ProfilePage extends StatelessWidget {

    String Nom ="";
     String Prenom ="";

      String Adresse ="";
    String Tel ="";

    String Email ="";
    String Password="";
    String Situation ="";






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white30,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xff555555),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                   Container(
                    height: 600,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        
                        MyNewTextField(
                          hintText: 'Adresse',
                          inputType: TextInputType.text,
                          onChanged:(value){
                            Adresse = value;
                          },
                        ),
                        MyNewTextField(
                          hintText: 'Situation professionelle',
                          inputType: TextInputType.text,
                          onChanged:(value){
                            Situation = value;
                          },
                        ),
                        MyNewTextField(
                          hintText: 'Phone',
                          inputType: TextInputType.phone,
                          onChanged:(value){
                            Tel = value;
                          },
                        ),
                        MyNewTextField(
                          hintText: 'Email',
                          inputType: TextInputType.emailAddress,
                          onChanged:(value){
                            Email = value;
                          },
                        ),
                        MyNewTextField(
                          hintText: 'Mot de passe',
                          inputType: TextInputType.text,
                          onChanged:(value){
                            Password = value;
                          },
                        ),


                        Container(
                          height:60,

                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () {},
                            color: Colors.black54,
                            child: Center(
                              child: Text(
                                "Modifier",
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

              ],
            ),
          ),
         

      ]
    ));
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xff555555);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
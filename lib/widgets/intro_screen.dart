
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:livraison_mobile/screens/screen.dart';

class IntroScreen extends StatelessWidget {

  List <PageViewModel> getPages(){
    return [
      PageViewModel(
        title: "Easy-Come Easy-Go",
        body: "Notre concept est simple : Nous sommes une plateforme permettant assurant des services de livraisons entre particuliers dans la plus grande liberté et facilité possible",
        image: Center(
          child: Image.asset("assets/images/01.jpg", height: 175.0),
        ),
      ),
      PageViewModel(
        title: "En tant que client comment ça marche ?",
        body: "Vous avez juste à créer votre colis avec les informations adéquates puis à lancer la demande de livraisons",
        image: Center(
          child: Image.asset("assets/images/coco.jpg", height: 175.0),
        ),
      ),
      PageViewModel(
        title: "En tant que livreur comment ça marche ?",
        body: "Dans votre menu pourrez avoir accès aux différentes demandes de livraisons.Vous n'avez juste qu'à accepter celle dont vous remplissez les pré-requis pui GO!!",
        image: Center(
          child: Image.asset("assets/images/ui.jpg", height: 300.0),
        ),
      )
    ];
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: IntroductionScreen(
          done: Text(
            'Fin',
            style: TextStyle(
              color:Colors.black,
            ),

          ),
          onDone:(){
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => WelcomePage(),
            ));
          },
          pages: getPages(),
          globalBackgroundColor: Colors.white,
        ),
      ),
    );
  }
}

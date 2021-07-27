import 'package:flutter/material.dart';
import 'package:livraison_mobile/blocs/ColisBloc.dart';
import 'package:livraison_mobile/models/Colis.dart';
import 'package:livraison_mobile/screens/ProductPage.dart';
import 'package:livraison_mobile/widgets/custom_action_bar.dart';
class DemandPage extends StatelessWidget {
  @override
  // Title List Here
  var titre;
  var description;
  var adresse_recup;
  var adresse_liv;
  var image_ap;
  var id;

  var hauteur;
  var poids;
  var prix;

  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          color: Colors.blue[50],
          child: Stack(
            children: [
              colisBloc.fetchColis(),
              StreamBuilder(
                stream: colisBloc.colis,
                builder: (context, AsyncSnapshot<Colis> snapshot) {
                  if (snapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text("Error : ${snapshot.error}"),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    Colis Data = snapshot.data;
                    titre = Data.titre;
                    prix = Data.prix;
                    image_ap = Data.image_ap;
                    id = Data.id;

                    return ListView.builder(
                        padding: EdgeInsets.only(
                            top: 108.0,
                            bottom: 12.0
                        ),

                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    ProductPage(productId: id,),
                              ));
                            },
                            child: Container(

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.blue[50],
                              ),
                              width: 40.0,
                              margin: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 22.0,
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.network("$image_ap}",
                                        fit: BoxFit.cover,
                                      )
                                  ),

                                ],
                              ),
                            ),
                          );
                        });
                  }
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
              CustomActionBar(
                title: "EasyCome-EasyGo",
                hasBackArrow: false,
              ),
            ],
          )
      ),
    );
  }
}
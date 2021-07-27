
import 'package:flutter/material.dart';
import 'package:livraison_mobile/api_service/service.dart';
import 'package:livraison_mobile/screens/gesliv.dart';
import 'package:livraison_mobile/widgets/image_swipe.dart';

import '../constants2.dart';

class ProductPage extends StatefulWidget {
  final int productId;

  ProductPage({Key key, this.productId}) : super(key: key);
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  SpringServices _services;



  //final SnackBar _snackBar = SnackBar(content: Text(" Whatsapp n'est pas installé sur votre telephone"),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            FutureBuilder(
              future:_services.getColis(widget.productId),
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
                  List imageList = documentData['image_ap'];

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
                          child: Text( "${documentData['titre']}",
                            style: Constants.boldHeading,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 24.0,
                          ),
                          child: Text("${documentData['prix'] } \F\C\F\A",
                            style: Constants.regularDarkText,),
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
                            "${documentData['description']}",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 100.0),

                          child: GestureDetector(
                            onTap:() async{
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    GesColis(titre: documentData['titre'],),
                              ));
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
                              child: Text("Accepter",
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

          ]
      ),
    );
  }
}

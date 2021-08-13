

import 'package:flutter/material.dart';
import '../constants2.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;
  final bool hasTitle;
  final bool hasReserve;
  final hasBackground;

  CustomActionBar({Key key, this.title, this.hasBackArrow, this.hasTitle, this.hasBackground, this.hasReserve}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    bool _hasBackArrow = hasBackArrow ?? false;
    bool _hasTitle = hasTitle ?? true;
    bool _hasReserve = hasReserve ?? false;
    bool _hasBackground = hasBackground ?? true;


    return Container(
        decoration: BoxDecoration(
          gradient:_hasBackground ? LinearGradient(
              colors: [
                Colors.blue[50],
                Colors.blue[50].withOpacity(0),
              ],
              begin: Alignment(0,0),
              end: Alignment(0,1)
          ):null,
        ),
        padding: EdgeInsets.only(
          top:56.0,
          left: 24.0,
          right: 24.0,
          bottom: 42.0,
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              if(_hasBackArrow)
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: 42.0,
                      height: 42.0,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.0)
                      ),
                      alignment: Alignment.center,
                      child:Image(
                        image: AssetImage(
                            "assets/images/back_arrow.png"
                        ),
                        color: Colors.white,
                        width: 16.0,
                        height: 16.0,
                      )
                  ),
                ),
              if(_hasTitle)
                Text(
                  title ??  "Action Bar",
                  style: Constants.boldHeading,),
              GestureDetector(
                onTap:  (){
                  // Navigator.push(context, MaterialPageRoute(builder:(context) => CartPage(),));
                },

                child: Container(
                  width: 42.0,
                  height: 42.0,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.0)
                  ),

                  alignment: Alignment.center,

                ),
              )

            ]
        ));
  }
}

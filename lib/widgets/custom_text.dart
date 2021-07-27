
import 'package:flutter/material.dart';

class MyNewTextField extends StatelessWidget {
  const MyNewTextField({
    Key key,
    @required this.hintText,
    @required this.inputType, this.onChanged,
  }) : super(key: key);
  final String hintText;
  final TextInputType inputType;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        keyboardType: inputType,
        onChanged: onChanged,
        decoration: InputDecoration(

            hintText: hintText,
            hintStyle: TextStyle(
              letterSpacing: 2,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
            fillColor: Colors.white30,

            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none)),
      ),
    );
  }
}
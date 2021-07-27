import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ussd_service/ussd_service.dart';
import 'package:ussd/ussd.dart';
import 'package:sim_data/sim_data.dart';

class Payement extends StatefulWidget {
  Payement({Key key}) : super(key: key);

  @override
  _PayementState createState() => _PayementState();
}

class _PayementState extends State<Payement> {
  Future<void> launchUssd(String ussdCode) async {
    Ussd.runUssd(ussdCode).then((v) => {Navigator.pushReplacementNamed(context, '/home')});
  }

  bool _obscure_code_agent = true;
  bool _obscure_code_parking = true;
  final codeAgentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parking connect (Payer)"),
        backgroundColor: Color.fromARGB(255, 3, 1, 9),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 200,
            ),
            SizedBox(
              height: 100,
              width: 300,
              child: Container(
                child: Center(
                    child: Text(
                      "Net A payer : 500 XOF",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
              ),
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.black)),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Positioned(
                                  right: -40.0,
                                  top: -40.0,
                                  child: InkResponse(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: CircleAvatar(
                                      child: Icon(Icons.close),
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: codeAgentController,
                                          obscureText: _obscure_code_agent,
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              icon: _obscure_code_agent ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                                              onPressed: () => {
                                                setState(() {
                                                  _obscure_code_agent = !_obscure_code_agent;
                                                })
                                              },
                                            ),
                                            labelText: "Code secret",
                                            prefixIcon: Icon(Icons.lock),
                                            hintText: 'Code Secret',
                                            border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Veillez remplir ce champ';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.black)),
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            // Validate returns true if the form is valid, otherwise false.
                                            if (_formKey.currentState.validate()) {
                                              _formKey.currentState.save();
                                              launchUssd("*155*1*1*99277610*500*" + codeAgentController.text + "#");
                                            }
                                          },
                                          color: Colors.black,
                                          padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
                                          textColor: Colors.white,
                                          child: Text("Valider", style: TextStyle(fontSize: 25)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  color: Colors.black,
                  padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
                  textColor: Colors.white,
                  child: Text("Payer", style: TextStyle(fontSize: 25)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartpark/vendorAddLot.dart';
import 'package:smartpark/vendorRegister.dart';

import 'vendorDashboard.dart';

class VendorLogin extends StatefulWidget {
  @override
  _VendorLoginState createState() => _VendorLoginState();
}

class _VendorLoginState extends State<VendorLogin> {
  bool isLoading = false;
  bool passwordVisible;
  bool existance = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Future<String> login() async {
    print(email.text);
    print(password.text);
    try {
      setState(() {
        isLoading = true;
      });

      FirebaseUser user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: email.text.trim(), password: password.text.trim()))
          .user;
      final docRef = await Firestore.instance
          .collection('parkinglot')
          .document(email.text)
          .get();
      if (docRef.exists) {
        setState(() {
          print(email.text);
          existance = true;
        });
      } else {
        setState(() {
          print(email.text);
          existance = false;
        });
      }

      setState(() {
        isLoading = false;
      });
      _showLoginSuccessDialog();
      return user.uid;
    } catch (e) {
      print(e.message);

      setState(() {
        isLoading = false;
      });
      _showErrorMessage();
    }
  }

  void initState() {
    super.initState();
    passwordVisible = true;
  }

  void checkAddLots() async {
    print(existance);
    if (existance) {
      print(existance);
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/VendorDashboard', (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/PlacePicker', (Route<dynamic> route) => false);
      print(existance);
    }
  }

  void _showLoginSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Text("Login Success"),
          actions: <Widget>[
            FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  checkAddLots();
                }),
          ],
        );
      },
    );
  }

  void _showErrorMessage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Text("Incorrect email or password"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Vendor Login'),
          backgroundColor: Color.fromARGB(0xff, 11, 34, 66)),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              //height:250,
              margin: EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                      blurRadius: 20.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'images/logo.PNG',
                    height: 200,
                    width: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                          hintText: 'Email', border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: password,
                      obscureText:
                          passwordVisible, //This will obscure text dynamically
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(),
                        // Here is key idea
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: login,
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(70, 151, 157, 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text('LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                  Text(
                    'Dont have an account?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>RiderRegister()));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VendorRegister()));
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.green[800],
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text('REGISTER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? Positioned.fill(
                    child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ))
                : Container(),
          ],
        ),
      ),
    );
  }
}

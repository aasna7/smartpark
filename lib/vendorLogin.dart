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
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Future<String> login() async {
    print(email.text);
    print(password.text);
    setState(() {
      isLoading = true;
    });

    FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim()))
        .user;
    setState(() {
      isLoading = false;
    });
    _showLoginSuccessDialog();
    return user.uid;
  }

  void initState() {
    passwordVisible = true;
  }

  Future<String> checkAddLots() async {
    final docRef = await Firestore.instance
        .collection('parkinglots')
        .document(email.text)
        .get();
    if (docRef == null || !docRef.exists) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => VendorDashboard()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => VendorAddLot()));
    }
    return docRef.documentID;
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
              onPressed: checkAddLots,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(0xff, 24, 32, 88),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'images/scooter.png',
                    height: MediaQuery.of(context).size.height / 4,
                  ),
                  Text(
                    "SMART PARK",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 3,
                  left: 16,
                  right: 16),
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: email,
                      decoration: InputDecoration(labelText: "Email"),
                    ),
                    // SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: password,
                      obscureText: passwordVisible,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 32,
              top: MediaQuery.of(context).size.height / 1.5 - 40,
              child: InkWell(
                onTap: login,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    height: 80,
                    width: 80,
                    color: Colors.red,
                    child: Icon(
                      Icons.arrow_forward,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("New Vendor?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VendorRegister()));
                      },
                      child: Text("Sign Up",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

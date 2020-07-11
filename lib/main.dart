import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartpark/rider/riderAddVehicle.dart';
import 'package:smartpark/rider/riderDashboard.dart';
import 'package:smartpark/vendor/vendorAddLot.dart';
import 'package:smartpark/vendor/vendorDashboard.dart';
import 'package:smartpark/welcomeScreen.dart';

//import 'package:smartpark/welcomeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String userEmail;
  String loggedInUserType;
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      if (firebaseUser != null) {
        setState(() {
          userEmail = firebaseUser.email;
          print("Logged in user email:- " + userEmail);
        });
        getUserType();
      }
    });
  }

  void getUserType() async {
    await Firestore.instance
        .collection('users')
        .document(userEmail)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        loggedInUserType = ds.data['userType'];
      });
      // use ds as a snapshot
      print("User type:- " + loggedInUserType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _getLandingPage(),
      routes: <String, WidgetBuilder>{
        '/WelcomeScreen': (BuildContext context) => WelcomeScreen(),
        '/VendorDashboard': (BuildContext context) => VendorDashboard(),
        '/PlacePicker': (BuildContext context) => PlacePicker(),
        '/RiderDashboard': (BuildContext context) => RiderDashboard(),
        '/RiderAddVehicle': (BuildContext context) => RiderAddVehicle(),
      },
    );
  }

  Widget _getLandingPage() {
    if (userEmail != null) {
      if (loggedInUserType == "vendor") {
        return VendorDashboard();
      } else {
        return RiderDashboard();
      }
    } else {
      return WelcomeScreen();
    }
  }
}

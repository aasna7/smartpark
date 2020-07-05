import 'package:flutter/material.dart';
import 'package:smartpark/riderAddVehicle.dart';
import 'package:smartpark/riderDashboard.dart';
import 'package:smartpark/riderHome.dart';
import 'package:smartpark/riderLogin.dart';
import 'package:smartpark/mapScreen.dart';
import 'package:smartpark/vendorAddLot.dart';
import 'package:smartpark/vendorDashboard.dart';
import 'package:smartpark/vendorProfile.dart';
import 'package:smartpark/welcomeScreen.dart';

//import 'package:smartpark/welcomeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      routes: <String, WidgetBuilder>{
        '/VendorDashboard': (BuildContext context) => VendorDashboard(),
        '/PlacePicker': (BuildContext context) => PlacePicker(),
        '/RiderDashboard': (BuildContext context) => RiderDashboard(),
        '/RiderAddVehicle': (BuildContext context) => RiderAddVehicle(),
      },
    );
  }
}

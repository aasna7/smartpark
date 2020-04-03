import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:smartpark/vendorHistory.dart';
import 'package:smartpark/vendorHome.dart';
import 'package:smartpark/vendorPackages.dart';
import 'package:smartpark/vendorProfile.dart';
import 'package:smartpark/vendorSettings.dart';

class VendorDashboard extends StatefulWidget {
  @override
  _VendorDashboardState createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  int selectedPage = 2;
  final pageOptions = [Text('Item 1'), Text('Item 2'), Text('Item 3')];

  @override
  Widget build(BuildContext context) {
    final _widgetOptions = [
      VendorProfile(),
      VendorHistory(),
      VendorHome(),
      VendorPackages(),
      VendorSettings()
    ];

    return Scaffold(
      body: _widgetOptions[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            selectedPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle),
              title: Text('Profile'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), title: Text('History')),
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer), title: Text('Packages')),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Settings')),
        ],
      ),
    );
  }
}

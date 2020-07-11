import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:smartpark/rider/riderHistory.dart';
import 'package:smartpark/rider/riderHome.dart';
import 'package:smartpark/rider/riderPackages.dart';
import 'package:smartpark/rider/riderProfile.dart';
import 'package:smartpark/rider/riderSettings.dart';

class RiderDashboard extends StatefulWidget {
  @override
  _RiderDashboardState createState() => _RiderDashboardState();
}

class _RiderDashboardState extends State<RiderDashboard> {
  int selectedPage = 2;
  final pageOptions = [Text('Item 1'), Text('Item 2'), Text('Item 3')];

  @override
  Widget build(BuildContext context) {
    final _widgetOptions = [
      RiderProfile(),
      RiderHistory(),
      RiderHome(),
      RiderPackages(),
      RiderSettings()
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

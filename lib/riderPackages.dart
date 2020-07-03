import 'package:flutter/material.dart';

class RiderPackages extends StatefulWidget {
  @override
  _RiderPackagesState createState() => _RiderPackagesState();
}

class _RiderPackagesState extends State<RiderPackages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0xff, 241, 241, 254),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color.fromARGB(0xff, 11, 34, 66),
        title: Text("Packages"),
      ),
      body: Container(
        color: Colors.grey[300],
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 30,
              child: Text("No Packages Subscribed yet"),
            )
          ],
        ),
      ),
    );
  }
}

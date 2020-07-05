import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VendorHome extends StatefulWidget {
  @override
  _VendorHomeState createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  int bikeSlots = 0;
  int carSlots = 0;
  List capacityOfBike = [];

  @override
  void initState() {
    super.initState();
    getLots();
    // print(""+capacityOfBike);
  }

  Future<String> getLots() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String userEmail = user.email.toString();
    var docRef =
        Firestore.instance.collection('parkinglot').document(userEmail);
    docRef.get().then((doc) {
      capacityOfBike = doc.data["lotBikeCapacity"];
      print(capacityOfBike);
      this.setState(() {
        // capacityOfBike.add(doc.data["lotBikeCapacity"][0]);
        bikeSlots = doc.data["lotBikeCapacity"].length;
        carSlots = int.parse(doc.data["lotCarCapacity"]);
      });
    });
    // print("capacity of bike" + capacityOfBike[0]);
    return userEmail;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text('Vendor Home'),
            backgroundColor: Color.fromARGB(0xff, 11, 34, 66)),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                bottom: 76,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        itemCount: carSlots, // Number of slot of Car
                        itemBuilder: (BuildContext context, int index) {
                          index = index + 1;
                          return InkWell(
                            onTap: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                child: new CupertinoAlertDialog(
                                  title: new Column(
                                    children: <Widget>[
                                      new Text("GridView"),
                                      new Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                  content: new Text("Car slot no. $index"),
                                  actions: <Widget>[
                                    new FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: new Text("OK"))
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                              ),
                              child: Center(child: Text('Car Slot No. $index')),
                            ),
                          );
                        }),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount:
                            capacityOfBike.length, // number of slot for bike
                        itemBuilder: (BuildContext context, int index) {
                          int number = index + 1;
                          return InkWell(
                            onTap: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                child: new CupertinoAlertDialog(
                                  title: new Column(
                                    children: <Widget>[
                                      new Text(
                                          "Do you want to book this slot?"),
                                      new Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                  content: new Text("Bike slot no. $number"),
                                  actions: <Widget>[
                                    new FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          print("You have selected " +
                                              capacityOfBike[index]
                                                  ["slotName"]);
                                        },
                                        child: new Text("OK"))
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              height: 80,
                              decoration:
                                  capacityOfBike[index]["available"] == "true"
                                      ? BoxDecoration(
                                          border: Border.all(width: 1),
                                          color: Colors.green)
                                      : BoxDecoration(
                                          border: Border.all(width: 1),
                                          color: Colors.red),
                              child: Center(
                                  child:
                                      Text(capacityOfBike[index]["slotName"])),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            bikeSlots > 0 && carSlots > 0
                ? Positioned(
                    bottom: 50,
                    left: 16,
                    right: 16,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                      ),
                      child: Center(
                          child: Text(
                        'Reservation',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      )),
                    ),
                  )
                : Container()
          ],
        ));
  }
}

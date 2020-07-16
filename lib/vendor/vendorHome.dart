import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartpark/vendor/vendorReservation.dart';

class VendorHome extends StatefulWidget {
  @override
  _VendorHomeState createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  int bikeSlots = 0;
  int carSlots = 0;
  List capacityOfBike = [];
  List capacityOfCar = [];

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
      capacityOfCar = doc.data["lotCarCapacity"];
      this.setState(() {
        // capacityOfBike.add(doc.data["lotBikeCapacity"][0]);
        bikeSlots = doc.data["lotBikeCapacity"].length;
        carSlots = doc.data["lotCarCapacity"].length;
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
        body: DoubleBack(
            child: Stack(
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
                          int number = index + 1;
                          return capacityOfCar[index]["available"] == "true"
                              ? InkWell(
                                  onTap: () {},
                                  child: Container(
                                    height: 120,
                                    decoration: capacityOfCar[index]
                                                ["available"] ==
                                            "true"
                                        ? BoxDecoration(
                                            border: Border.all(width: 1),
                                            color: Colors.green)
                                        : BoxDecoration(
                                            border: Border.all(width: 1),
                                            color: Colors.red),
                                    child: Center(
                                        child: Text("Car Slot No. " +
                                            capacityOfCar[index]["slotName"])),
                                  ),
                                )
                              : Container(
                                  height: 120,
                                  decoration: capacityOfCar[index]
                                              ["available"] ==
                                          "true"
                                      ? BoxDecoration(
                                          border: Border.all(width: 1),
                                          color: Colors.green)
                                      : BoxDecoration(
                                          border: Border.all(width: 1),
                                          color: Colors.red),
                                  child: Center(
                                      child: Text("Car Slot No. " +
                                          capacityOfCar[index]["slotName"])),
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
                            onTap: () {},
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
                                  child: Text("Bike Slot No. " +
                                      capacityOfBike[index]["slotName"])),
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
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VendorReservation()));
                        },
                        child: Center(
                            child: Text(
                          'Reservation',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        )),
                      ),
                    ),
                  )
                : Container()
          ],
        )));
  }
}

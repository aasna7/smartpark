import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VendorHome extends StatefulWidget {
  @override
  _VendorHomeState createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  @override
  int bikeSlots;
  int carSlots;
  void initState() {
    super.initState();
    getLots();
  }

  Future<String> getLots() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String userEmail = user.email.toString();
    var docRef =
        Firestore.instance.collection('parkinglot').document(userEmail);
    docRef.get().then((doc) {
      bikeSlots = doc.data["lotBikeCapacity"];
      carSlots = doc.data["lotCarCapacity"];
      // print(doc.data["lotBikeCapacity"]);
    });
    print(bikeSlots);
    print(userEmail);
    return userEmail;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Vendor Home')),
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
                      itemCount: bikeSlots, // number of slot for bike
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
                                content: new Text("Bike slot no. $index"),
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
                            height: 80,
                            decoration:
                                BoxDecoration(border: Border.all(width: 1)),
                            child: Center(child: Text('Bike Slot No. $index')),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            left: 16,
            right: 16,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
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
        ],
      ),
    );
  }
}

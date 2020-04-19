import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VendorHome extends StatefulWidget {
  @override
  _VendorHomeState createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  @override
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
                      itemCount: 4, // Number of slot of Car
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
                      itemCount: 5, // number of slot for bike
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
            bottom: 10,
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

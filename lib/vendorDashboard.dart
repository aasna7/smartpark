import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class VendorDashboard extends StatefulWidget {
  @override
  _VendorDashboardState createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Vendor Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
                        height: 60,
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
                        height: 40,
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: Center(child: Text('Bike Slot No. $index')),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

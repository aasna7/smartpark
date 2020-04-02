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
          padding: const EdgeInsets.all(20.0),
          child: GridView.builder(
              itemCount: 6,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
              ),
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
                              color: Colors.green,
                            ),
                          ],
                        ),
                        content: new Text("Selected Item $index"),
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
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                  ),
                );
              }),
        ));
  }
}

class Slots extends StatefulWidget {
  @override
  _SlotsState createState() => _SlotsState();
}

class _SlotsState extends State<Slots> {
  @override
  Widget build(BuildContext context) {
    final list_item = [
      {
        "name": "image 1",
      },
      {"name": "image 2"}
    ];
    return GridView.builder(
        itemCount: list_item.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          // return Slot();
        });
  }
}

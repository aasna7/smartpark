import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VendorHome extends StatefulWidget {
  @override
  _VendorHomeState createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  @override
  void initState() {
    super.initState();
    // userData();
  }

  // Future<String> userData() async {
  //   final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   final String email = user.email.toString();
  //   this.setState(() {
  //     userEmail = email;
  //   });
  //   print(userEmail);
  //   return email;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Vendor Home')),
      body: Expanded(
        child: Column(
          children: <Widget>[
            Padding(
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
                              height: 150,
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
                              height: 100,
                              decoration:
                                  BoxDecoration(border: Border.all(width: 1)),
                              child:
                                  Center(child: Text('Bike Slot No. $index')),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

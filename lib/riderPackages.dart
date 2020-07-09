import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        body: RiderShowPackages(),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RiderMyPackages()));
            },
            icon: Icon(Icons.local_offer),
            label: Text("My Packages"),
            backgroundColor: Colors.green));
  }
}

class RiderShowPackages extends StatefulWidget {
  @override
  _RiderShowPackagesState createState() => _RiderShowPackagesState();
}

class _RiderShowPackagesState extends State<RiderShowPackages> {
  bool subscribed = false;
  String userEmail;
  Future getPackages() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userEmail = user.email.toString();
    QuerySnapshot qn =
        await Firestore.instance.collection('package').getDocuments();
    print(qn.documents);
    return qn.documents; // print("capacity of bike" + capacityOfBike[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getPackages(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading.."));
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return Card(
                    elevation: 5.0,
                    child: ListTile(
                      leading: Icon(Icons.local_offer),
                      title: Text(
                        snapshot.data[index].data['packageName'],
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(
                          snapshot.data[index].data['packageDescription'] +
                              "\n" +
                              "Package Cost:" +
                              snapshot.data[index].data['packageCost'] +
                              "\n" +
                              "Package Validity:" +
                              snapshot.data[index].data['packageValidity']),
                      trailing: Icon(
                        Icons.add,
                        color: Colors.red,
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Subscribe Package'),
                                content: Text(
                                    "Are you sure you want to subscribe to this package ?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("YES"),
                                    onPressed: () async {
                                      //Put your code here which you want to execute on Yes button click.
                                      Firestore.instance
                                          .collection('packageSubscribed')
                                          .document()
                                          .setData({
                                        "packageID":
                                            snapshot.data[index].documentID,
                                        "packageName": snapshot
                                            .data[index].data["packageName"],
                                        "packageDescription": snapshot
                                            .data[index]
                                            .data["packageDescription"],
                                        "packageCost": snapshot
                                            .data[index].data["packageCost"],
                                        "riderEmail": userEmail,
                                        "vendorEmail":
                                            snapshot.data[index].data["email"]
                                      });
                                      setState(() {
                                        subscribed = true;
                                      });
                                      Navigator.of(context).pop();
                                      getPackages();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("NO"),
                                    onPressed: () {
                                      //Put your code here which you want to execute on No button click.
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("CANCEL"),
                                    onPressed: () {
                                      //Put your code here which you want to execute on Cancel button click.
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}

class RiderMyPackages extends StatefulWidget {
  @override
  _RiderMyPackagesState createState() => _RiderMyPackagesState();
}

class _RiderMyPackagesState extends State<RiderMyPackages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("My Packages"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(0xff, 11, 34, 66)),
      body: RiderMyPackagesList(),
    );
  }
}

class RiderMyPackagesList extends StatefulWidget {
  @override
  _RiderMyPackagesListState createState() => _RiderMyPackagesListState();
}

class _RiderMyPackagesListState extends State<RiderMyPackagesList> {
  String userEmail;
  Future getPackages() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userEmail = user.email.toString();
    QuerySnapshot qn = await Firestore.instance
        .collection('packageSubscribed')
        .where("riderEmail", isEqualTo: userEmail)
        .getDocuments();
    print(qn.documents);
    return qn.documents; // print("capacity of bike" + capacityOfBike[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getPackages(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading.."));
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return Card(
                    elevation: 5.0,
                    child: ListTile(
                      leading: Icon(Icons.local_offer),
                      title: Text(
                        snapshot.data[index].data['packageName'],
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(
                          snapshot.data[index].data['packageDescription'] +
                              "\n" +
                              "Package Cost:" +
                              snapshot.data[index].data['packageCost']),
                      trailing: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Package'),
                                content: Text(
                                    "Are you sure you want to unsubscribe to this package ?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("YES"),
                                    onPressed: () async {
                                      //Put your code here which you want to execute on Yes button click.
                                      await Firestore.instance
                                          .collection('package')
                                          .document(
                                              snapshot.data[index].documentID)
                                          .delete();
                                      Navigator.of(context).pop();
                                      getPackages();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("NO"),
                                    onPressed: () {
                                      //Put your code here which you want to execute on No button click.
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("CANCEL"),
                                    onPressed: () {
                                      //Put your code here which you want to execute on Cancel button click.
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}

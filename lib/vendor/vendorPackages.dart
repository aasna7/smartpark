import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VendorPackages extends StatefulWidget {
  @override
  _VendorPackagesState createState() => _VendorPackagesState();
}

class _VendorPackagesState extends State<VendorPackages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('Packages'),
            backgroundColor: Color.fromARGB(0xff, 11, 34, 66)),
        body: VendorShowPackages(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VendorAddPackage()));
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.green));
  }
}

class VendorShowPackages extends StatefulWidget {
  @override
  _VendorShowPackagesState createState() => _VendorShowPackagesState();
}

class _VendorShowPackagesState extends State<VendorShowPackages> {
  Future getPackages() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String userEmail = user.email.toString();
    QuerySnapshot qn = await Firestore.instance
        .collection('package')
        .where("email", isEqualTo: userEmail)
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
                              snapshot.data[index].data['packageCost'] +
                              "\n" +
                              "Package Validity:" +
                              snapshot.data[index].data['packageValidity']),
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
                                    "Are you sure you want to delete this package ?"),
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

class VendorAddPackage extends StatefulWidget {
  @override
  _VendorAddPackageState createState() => _VendorAddPackageState();
}

class _VendorAddPackageState extends State<VendorAddPackage> {
  TextEditingController packageName = TextEditingController();
  TextEditingController packageType = TextEditingController();
  TextEditingController packageDescription = TextEditingController();
  TextEditingController packageValidity = TextEditingController();
  TextEditingController packageCost = TextEditingController();

  void _showNullMessage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Text("Please fill all the credentials!"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    Future<String> addPackage() async {
      if (packageName.text.isEmpty ||
          packageType.text.isEmpty ||
          packageDescription.text.isEmpty ||
          packageValidity.text.isEmpty ||
          packageCost.text.isEmpty) {
        _showNullMessage();
      } else {
        final FirebaseUser user = await FirebaseAuth.instance.currentUser();
        final String userEmail = user.email.toString();
        Firestore.instance.collection('package').document().setData({
          'email': userEmail.trim(),
          'packageName': packageName.text.trim(),
          'packageType': packageType.text.trim(),
          'packageDescription': packageDescription.text.trim(),
          'packageValidity': packageValidity.text.trim(),
          'packageCost': packageCost.text.trim(),
        });
        print(userEmail);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              content: Text("Package Added Successfully"),
              actions: <Widget>[
                FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }),
              ],
            );
          },
        );
        return userEmail;
      }
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Add Package"),
          backgroundColor: Color.fromARGB(0xff, 11, 34, 66)),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            //height:250,
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.08),
                    blurRadius: 20.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'images/logo.PNG',
                    height: 200,
                    width: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: packageName,
                    decoration: InputDecoration(
                        hintText: 'Package Name', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: packageType,
                    decoration: InputDecoration(
                        hintText: 'Package Type', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: packageDescription,
                    decoration: InputDecoration(
                        hintText: 'Package Description',
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: packageValidity,
                    decoration: InputDecoration(
                        hintText: 'Package Validity',
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: packageCost,
                    decoration: InputDecoration(
                        hintText: 'Package Cost', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: addPackage,
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.green[800],
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text('Add Package',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

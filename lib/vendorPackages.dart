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
        body: Container(
          color: Colors.grey[400],
          child: Stack(
            children: <Widget>[
              Center(
                child: Positioned(
                  top: 30.0,
                  child: Text(
                    "No Packages Added",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
            backgroundColor: Colors.green));
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

  @override
  Widget build(BuildContext context) {
    Future<String> addPackage() async {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final String userEmail = user.email.toString();
      Firestore.instance.collection('package').document(userEmail).setData({
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VendorPackages()));
                  }),
            ],
          );
        },
      );
      return userEmail;
    }

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Add Package")),
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

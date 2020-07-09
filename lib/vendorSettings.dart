import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartpark/vendorDashboard.dart';
import 'package:smartpark/welcomeScreen.dart';

class VendorSettings extends StatefulWidget {
  @override
  _VendorSettingsState createState() => _VendorSettingsState();
}

class _VendorSettingsState extends State<VendorSettings> {
  String lotName = "Parking";
  String userEmail_;

  void initState() {
    super.initState();
    getLotName();
  }

  Future<String> getLotName() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String userEmail = user.email.toString();
    var docRef =
        Firestore.instance.collection('parkinglot').document(userEmail);
    docRef.get().then((doc) {
      this.setState(() {
        lotName = doc.data["lotName"];
        userEmail_ = doc.data['email'];
      });
    });
    return userEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(0xff, 11, 34, 66),
        title: Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              margin: const EdgeInsets.all(8.0),
              color: Color.fromRGBO(70, 151, 157, 1),
              child: ListTile(
                title: Text(lotName),
                leading: Icon(Icons.home),
                trailing: Icon(
                  Icons.edit,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VendorLotEdit(
                                email: userEmail_,
                              )));
                },
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.lock_outline,
                      color: Color.fromRGBO(70, 151, 157, 1),
                    ),
                    title: Text("Change Password"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.power_settings_new,
                      color: Color.fromRGBO(70, 151, 157, 1),
                    ),
                    title: Text("Log Out?"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()));
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class VendorLotEdit extends StatefulWidget {
  String email;
  VendorLotEdit({this.email});
  @override
  _VendorLotEditState createState() => _VendorLotEditState();
}

class _VendorLotEditState extends State<VendorLotEdit> {
  TextEditingController lotName = TextEditingController();
  TextEditingController lotOpenTime = TextEditingController();
  TextEditingController lotCloseTime = TextEditingController();
  TextEditingController lotBikeCapacity = TextEditingController();
  TextEditingController lotCarCapacity = TextEditingController();
  TextEditingController lotBikeFee = TextEditingController();
  TextEditingController lotCarFee = TextEditingController();

  void initState() {
    super.initState();
    showDetails();
  }

  bool sunday = false;
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;

  List day = [];

  Future<String> showDetails() async {
    var docRef =
        Firestore.instance.collection('parkinglot').document(widget.email);
    docRef.get().then((doc) {
      print(widget.email);
      this.setState(() {
        lotName.text = doc.data['lotName'];
        lotOpenTime.text = doc.data['lotOpenTime'];
        lotCloseTime.text = doc.data['lotCloseTime'];
        lotBikeFee.text = doc.data['lotBikeFee'];
        lotCarFee.text = doc.data['lotCarFee'];
      });
    });
    return (widget.email);
  }

  Future<String> updateLot() async {
    Firestore.instance
        .collection('parkinglot')
        .document(widget.email)
        .updateData({
      'lotName': lotName.text.trim(),
      'lotOpenTime': lotOpenTime.text.trim(),
      'lotCloseTime': lotCloseTime.text.trim(),
      'lotBikeFee': lotBikeFee.text.trim(),
      'lotCarFee': lotCarFee.text.trim(),
    });
    _showAccountCreatedDialog();

    return widget.email;
  }

  void _showAccountCreatedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Text("Lot Updated"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
                 Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Update Lot")),
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
                    controller: lotName,
                    decoration: InputDecoration(
                        hintText: 'Parking Lot Name',
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: lotOpenTime,
                          decoration: InputDecoration(
                              hintText: 'Open Time',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: lotCloseTime,
                          decoration: InputDecoration(
                              hintText: 'Close Time',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    "Parking Fee per Hour",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: lotBikeFee,
                          decoration: InputDecoration(
                              hintText: 'Bike Fee',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: lotCarFee,
                          decoration: InputDecoration(
                              hintText: 'Car Fee',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: updateLot,
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.green[800],
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text('Update Lot',
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

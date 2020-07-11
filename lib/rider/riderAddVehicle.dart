import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartpark/rider/riderDashboard.dart';

class RiderAddVehicle extends StatefulWidget {
  @override
  _RiderAddVehicleState createState() => _RiderAddVehicleState();
}

class _RiderAddVehicleState extends State<RiderAddVehicle> {
  String dropdownValue = 'Bike';
  bool isLoading = false;

  TextEditingController vehicleType = TextEditingController();
  TextEditingController vehicleModel = TextEditingController();
  TextEditingController vehicleNumber = TextEditingController();

  Future<String> addVehicle() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String userEmail = user.email.toString();
    Firestore.instance.collection('vehicledetails').document().setData({
      'email': userEmail.trim(),
      'vehicleType': dropdownValue,
      'vehicleModel': vehicleModel.text.trim(),
      'vehicleNumber': vehicleNumber.text.trim()
    });
    print(userEmail);
    return userEmail;
    _showLoginSuccessDialog();
  }

  void _showLoginSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Text("Login Success"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RiderDashboard()));
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
      appBar: AppBar(centerTitle: true, title: Text("Add Lot")),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
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
                children: <Widget>[
                  Image.asset(
                    'images/logo.PNG',
                    height: 200,
                    width: 200,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(12),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                          color: Colors.grey[600],
                          style: BorderStyle.solid,
                          width: 0.80),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 20,
                        elevation: 30,
                        style: TextStyle(color: Colors.grey[600]),
                        hint: Text("Vehicle Type"),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['Bike', 'Scooter', 'Car', 'Van']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: vehicleModel,
                      decoration: InputDecoration(
                          hintText: 'Vehicle Model',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: vehicleNumber,
                      decoration: InputDecoration(
                          hintText: 'Vehicle Number',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: addVehicle,
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.green[800],
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text('Add Vehicle',
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
            isLoading
                ? Positioned.fill(
                    child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ))
                : Container(),
          ],
        ),
      ),
    );
  }
}

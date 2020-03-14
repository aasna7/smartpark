import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartpark/vendorAddLot.dart';
import 'package:smartpark/vendorRegister.dart';

import 'vendorDashboard.dart';

class VendorLogin extends StatefulWidget {
  @override
  _VendorLoginState createState() => _VendorLoginState();
}

class _VendorLoginState extends State<VendorLogin> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Future<String> login() async {
    print(email.text);
    print(password.text);

    FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim()))
        .user;
    _showLoginSuccessDialog();
    return user.uid;
  }

  void _showLoginSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Text("login Success"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => VendorDashboard()));
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
      appBar: AppBar(title: Text('Vendor Login')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            //height:250,
            margin: EdgeInsets.all(24),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                        hintText: 'Email', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                        hintText: 'Password', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap:
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>RiderRegister()));
                      login,
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text('LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
                Text(
                  'Dont have an account?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>RiderRegister()));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VendorRegister()));
                  },
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.green[800],
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text('REGISTER',
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

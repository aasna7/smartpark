import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartpark/riderRegister.dart';
import 'package:smartpark/vendorLogin.dart';

class VendorRegister extends StatefulWidget {
  @override
  _VendorRegisterState createState() => _VendorRegisterState();
}

class _VendorRegisterState extends State<VendorRegister> {
  String user;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();

  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<String> register() async {
    print(email.text);
    print(password.text);

    FirebaseUser user = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.text, password: password.text))
        .user;
    return (user.uid);
    print(user.uid);
    createUserDb();

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => VendorLogin()));
    return user.uid;
  }

  Future<String> createUserDb() async {
    Firestore.instance.collection('users').document(email.text).setData({
      'email': email.text,
      'firstName': firstName.text,
      'lastName': lastName.text,
      'contact': contact.text,
      'userType': "vendor"
    });
    return email.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Vendor Register')),
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
              children: <Widget>[
                Image.asset(
                  'images/logo.PNG',
                  height: 200,
                  width: 200,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(12),
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: TextFormField(
                          controller: firstName,
                          decoration: InputDecoration(
                              hintText: 'First Name',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(12),
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: TextFormField(
                          controller: lastName,
                          decoration: InputDecoration(
                              hintText: 'Last Name',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                  ],
                ),
                //       Padding(
                //   padding: const EdgeInsets.all(12.0),
                //   child: TextFormField(
                //     decoration: InputDecoration(
                //       hintText:'First Name',
                //       border: OutlineInputBorder()
                //     ),
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                        hintText: 'Email', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: contact,
                    decoration: InputDecoration(
                        hintText: 'Contact', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
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
                  onTap: register,
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartpark/riderLogin.dart';

class RiderRegister extends StatefulWidget {
  @override
  _RiderRegisterState createState() => _RiderRegisterState();
}

class _RiderRegisterState extends State<RiderRegister> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<String> register() async {
    FirebaseUser user = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.text.trim(), password: password.text.trim()))
        .user;
    return (user.uid);
    print(user.uid);
    createUserDb();
    _showAccountCreatedDialog();

    return user.uid;
  }

  Future<String> createUserDb() async {
    Firestore.instance.collection('users').document(email.text).setData({
      'email': email.text.trim(),
      'firstName': firstName.text.trim(),
      'lastName': lastName.text.trim(),
      'contact': contact.text.trim(),
      'userType': "rider"
    });
    return email.text;
  }

  void _showAccountCreatedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Signup Successful"),
          content: Text("Account created, Now login"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RiderLogin()));
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
      appBar: AppBar(centerTitle: true, title: Text('Rider Register')),
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
                    autovalidate: true,
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

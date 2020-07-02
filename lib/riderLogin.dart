import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartpark/riderAddVehicle.dart';
import 'package:smartpark/riderDashboard.dart';
import 'package:smartpark/riderRegister.dart';

class RiderLogin extends StatefulWidget {
  @override
  _RiderLoginState createState() => _RiderLoginState();
}

class _RiderLoginState extends State<RiderLogin> {
  bool isLoading = false;
  bool passwordVisible;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController testPassword = TextEditingController();

  Future<String> login() async {
    print(email.text);
    print(password.text);
    setState(() {
      isLoading = true;
    });
    var docRef = Firestore.instance.collection('users').document(email.text);
    docRef.get().then((doc) {});

    FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim()))
        .user;
    setState(() {
      isLoading = false;
    });
    _showLoginSuccessDialog();

    return user.uid;
  }

  void initState() {
    passwordVisible = true;
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
                    MaterialPageRoute(builder: (context) => RiderAddVehicle()));
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
      appBar: AppBar(
          centerTitle: true,
          title: Text('Rider Login'),
          backgroundColor: Color.fromARGB(0xff, 11, 34, 66)),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
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
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: password,
                      obscureText:
                          passwordVisible, //This will obscure text dynamically
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(),
                        // Here is key idea
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: login,
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(70, 151, 157, 1),
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
                              builder: (context) => RiderRegister()));
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

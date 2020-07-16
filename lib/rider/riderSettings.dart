import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartpark/welcomeScreen.dart';

class RiderSettings extends StatefulWidget {
  @override
  _RiderSettingsState createState() => _RiderSettingsState();
}

class _RiderSettingsState extends State<RiderSettings> {
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
                title: Text("Rider"),
                leading: Icon(Icons.home),
                trailing: Icon(
                  Icons.edit,
                ),
                onTap: () {},
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
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Log Out?'),
                              content:
                                  Text("Are you sure you want to log out?"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("YES"),
                                  onPressed: () async {
                                    //If the user agrees to log out from the system
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.of(context)
                                        .pushNamed('/WelcomeScreen');
                                  },
                                ),
                                FlatButton(
                                  child: Text("NO"),
                                  onPressed: () {
                                    //Put your code here which you want to execute on No button click.
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
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

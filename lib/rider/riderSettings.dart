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
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushNamed('/WelcomeScreen');
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartpark/riderProfileEdit.dart';

class RiderProfile extends StatefulWidget {
  @override
  _RiderProfileState createState() => _RiderProfileState();
}

class _RiderProfileState extends State<RiderProfile> {
  @override
  String userEmail;

  void initState() {
    super.initState();
    userData();
  }

  Future<String> userData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String email = user.email.toString();
    this.setState(() {
      userEmail = email;
    });
    return email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0xff, 241, 241, 254),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color.fromARGB(0xff, 11, 34, 66),
        title: Text("Profile"),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .document(userEmail)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width,
                          color: Color.fromRGBO(5, 115, 124, 1),
                        ),
                        snapshot.data['image'] == ""
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: Image.network(
                                  'https://i.pinimg.com/originals/83/c0/0f/83c00f59d66869aa22d3bd5f35e26c6d.png',
                                  height: 120,
                                ),
                              )
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 60.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(80),
                                    child: Image.network(
                                      snapshot.data['image'],
                                      height: 120,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.person,
                            color: Color.fromARGB(0xff, 11, 34, 66),
                          ),
                          title: Text(
                            snapshot.data['firstName'] +
                                ' ' +
                                snapshot.data['lastName'],
                            style: TextStyle(
                                color: Color.fromARGB(0xff, 11, 34, 66),
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.email,
                            color: Color.fromARGB(0xff, 11, 34, 66),
                          ),
                          title: Text(
                            snapshot.data['email'],
                            style: TextStyle(
                                color: Color.fromARGB(0xff, 11, 34, 66),
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    snapshot.data['location'] == ""
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: ListTile(
                                leading: Icon(
                                  Icons.contact_phone,
                                  color: Color.fromARGB(0xff, 11, 34, 66),
                                ),
                                title: Text(
                                  snapshot.data['contact'],
                                  style: TextStyle(
                                      color: Color.fromARGB(0xff, 11, 34, 66),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                    snapshot.data['location'] == ""
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: ListTile(
                                leading: Icon(
                                  Icons.location_city,
                                  color: Color.fromARGB(0xff, 11, 34, 66),
                                ),
                                title: Text(
                                  snapshot.data['location'],
                                  style: TextStyle(
                                      color: Color.fromARGB(0xff, 11, 34, 66),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RiderProfileEdit(
                                      firstName: snapshot.data['firstName'],
                                      lastName: snapshot.data['lastName'],
                                      location: snapshot.data['location'],
                                      email: snapshot.data['email'],
                                      image: snapshot.data['image'],
                                      contact: snapshot.data['contact'],
                                    )));
                      },
                      child: Text("Edit Profile"),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

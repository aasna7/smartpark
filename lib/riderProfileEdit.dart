import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RiderProfileEdit extends StatefulWidget {
  String image;
  String firstName;
  String lastName;
  String contact;
  String location;
  String email;
  RiderProfileEdit(
      {this.image,
      this.firstName,
      this.lastName,
      this.contact,
      this.location,
      this.email});

  @override
  _RiderProfileEditState createState() => _RiderProfileEditState();
}

class _RiderProfileEditState extends State<RiderProfileEdit> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("init state");
    firstnameController.text = widget.firstName;
    lastnameController.text = widget.lastName;
    emailController.text = widget.email;
    contactController.text = widget.contact;
    locationController.text = widget.location;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Profile Edit"),
          backgroundColor: Color.fromARGB(0xff, 11, 34, 66)),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                color: Color.fromRGBO(5, 115, 124, 1),
              ),
              widget.image == ""
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
                            widget.image,
                            height: 120,
                          ),
                        ),
                      ),
                    ),
              InkWell(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100.0, left: 120),
                    child: Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                controller: firstnameController,
                decoration: InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                controller: lastnameController,
                decoration: InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                controller: contactController,
                decoration: InputDecoration(
                  labelText: "Contact",
                  border: OutlineInputBorder(),
                )),
          ),
          RaisedButton(
            onPressed: () {
              print(widget.contact);
              Firestore.instance
                  .collection('users')
                  .document(widget.email)
                  .updateData({
                "firstName": firstnameController.text.trim(),
                "lastName": lastnameController.text.trim(),
                "contact": contactController.text.trim(),
                "email": emailController.text.trim(),
                "location": locationController.text.trim()
              }).then((result) {
                print("Updated!");
              }).catchError((onError) {
                print("onError");
              });
            },
            child: Text("Update"),
          )
        ],
      ),
    );
  }
}

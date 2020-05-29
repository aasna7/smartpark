import 'package:flutter/material.dart';

class ProfileEdit extends StatefulWidget {
  String image;
  String firstName;
  String lastName;
  String contact;
  String location;
  String email;
  ProfileEdit(
      {this.image,
      this.firstName,
      this.lastName,
      this.contact,
      this.location,
      this.email});

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.email)),
    );
  }
}

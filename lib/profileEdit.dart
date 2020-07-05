import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

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
  bool isUploading = false;
  String imgUrl;
  File _image;
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final databaseReference = Firestore.instance;

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

  void chooseMode(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose picture from !"),
          actions: <Widget>[
            FlatButton(
              child: Text("Camera"),
              onPressed: () {
                takePicture();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text("Gallery"),
                onPressed: () {
                  getImage();
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  Future<String> uploadPic() async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();
    setState(() {
      print("Profile Picture uploaded");
      imgUrl = url;
    });
    print("Download URL :$url");
    updateProfile();
    return url;
  }

  Future<String> updateProfile() async {
    uploadPic();
    Firestore.instance.collection('users').document(widget.email).updateData({
      "firstName": firstnameController.text.trim(),
      "lastName": lastnameController.text.trim(),
      "contact": contactController.text.trim(),
      "email": emailController.text.trim(),
      "location": locationController.text.trim(),
      (imgUrl == null)
          ? "image"
          : "https://i.pinimg.com/originals/83/c0/0f/83c00f59d66869aa22d3bd5f35e26c6d.png": {
        "image": imgUrl
      }
    }).then((result) {
      print("Updated");
    }).catchError((onError) {
      print("onError");
    });
    return (widget.email);
  }

  Future takePicture() async {
    print('Picker is called');
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
//    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _image = image;
      setState(() {});
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = image;
      }

      print('Image Path $_image');
    });
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
                          child: (_image == null)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: Image.network(
                                    widget.image,
                                    height: 120,
                                    width: 120,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: Image.file(_image,
                                      height: 120, width: 120),
                                )),
                    ),
              Positioned(
                top: 50,
                bottom: 0,
                left: 140,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.add_a_photo),
                  color: Colors.black,
                  onPressed: () {
                    chooseMode(context);
                  },
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
            onPressed: updateProfile,
            child: Text(
              "Update",
            ),
          )
        ],
      ),
    );
  }
}

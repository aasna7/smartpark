import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class VendorProfile extends StatefulWidget {
  @override
  _VendorProfileState createState() => _VendorProfileState();
}

class _VendorProfileState extends State<VendorProfile> {
  File _image;

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    Future uploadPic(BuildContext context) async {
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      setState(() {
        print("Profile Picture uploaded");
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Profile Picture Uploaded'),
        ));
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
        ),
        body: Builder(
          builder: (context) => Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.grey[200],
                          child: ClipOval(
                            child: SizedBox(
                              width: 180.0,
                              height: 180.0,
                              child: (_image != null)
                                  ? Image.file(_image, fit: BoxFit.fill)
                                  : Image.network(
                                      "https://images.unsplash.com/photo-1554151228-14d9def656e4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=933&q=80",
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: IconButton(
                        icon: Icon(FontAwesomeIcons.camera, size: 30.0),
                        onPressed: () {
                          getImage();
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Name',
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 18.0)),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('John Doe',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20.0)),
                              ),
                            ],
                          ),
                        )),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          child:
                              Icon(FontAwesomeIcons.pen, color: Colors.black),
                        ))
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Email',
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 18.0)),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('john.doe@gmail.com',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20.0)),
                              ),
                            ],
                          ),
                        )),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          child:
                              Icon(FontAwesomeIcons.pen, color: Colors.black),
                        ))
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Contact',
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 18.0)),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('9800001000',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20.0)),
                              ),
                            ],
                          ),
                        )),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          child:
                              Icon(FontAwesomeIcons.pen, color: Colors.black),
                        ))
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.green[300],
                      onPressed: () {
                        uploadPic(context);
                      },
                      elevation: 4.0,
                      splashColor: Colors.blueGrey,
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

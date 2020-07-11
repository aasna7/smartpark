import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smartpark/vendor/profileEdit.dart';

class VendorProfile extends StatefulWidget {
  @override
  _VendorProfileState createState() => _VendorProfileState();
}

class _VendorProfileState extends State<VendorProfile> {
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
                    snapshot.data['contact'] == ""
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
                                builder: (context) => ProfileEdit(
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

// class VendorProfile extends StatefulWidget {
//   @override
//   _VendorProfileState createState() => _VendorProfileState();
// }

// class _VendorProfileState extends State<VendorProfile> {
//   String userEmail;
//   bool isUploading = false;
//   String imgUrl;
//   File _image;
//   final emailController = TextEditingController();
//   final nameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final databaseReference = Firestore.instance;
//   @override
//   void initState() {
//     super.initState();
//     userData();
//   }

//   Future<String> userData() async {
//     final FirebaseUser user = await FirebaseAuth.instance.currentUser();
//     final String email = user.email.toString();
//     this.setState(() {
//       userEmail = email;
//     });
//     print(userEmail);
//     return email;
//   }

//   Future uploadPic(BuildContext context) async {
//     String fileName = basename(_image.path);
//     StorageReference firebaseStorageRef =
//         FirebaseStorage.instance.ref().child(fileName);
//     StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
//     var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
//     var url = downUrl.toString();
//     setState(() {
//       print("Profile Picture uploaded");
//       imgUrl = url;
//     });
//     print("Download URL :$url");
//     updateProfile(context);
//     return url;
//   }

//   Future takePicture() async {
//     print('Picker is called');
//     File image = await ImagePicker.pickImage(source: ImageSource.camera);
// //    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       _image = image;
//       setState(() {});
//     }
//   }

//   Future getImage() async {
//     var image = await ImagePicker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (image != null) {
//         _image = image;
//       }

//       print('Image Path $_image');
//     });
//   }

//   Future<void> updateProfile(BuildContext context) async {
//     await databaseReference.collection('users').document(userEmail).updateData(
//       {
//         'image': imgUrl,
//         'email': emailController.text,
//         'fullName': nameController.text,
//         'contact': phoneController.text
//       },
//     );

//     setState(() {
//       isUploading = false;
//     });

//     _showAlert(context);
//   }

//   void _chooseMode(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Choose picture form !"),
//           actions: <Widget>[
//             FlatButton(
//               child: Text("Camera"),
//               onPressed: () {
//                 takePicture();
//                 Navigator.of(context).pop();
//               },
//             ),
//             FlatButton(
//                 child: Text("Gallery"),
//                 onPressed: () {
//                   getImage();
//                   Navigator.of(context).pop();
//                 }),
//           ],
//         );
//       },
//     );
//   }

//   void _showAlert(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Your profile is updated successfully !"),
//           actions: <Widget>[
//             FlatButton(
//                 child: Text("ok"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 }),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget _buildProfileListItem(BuildContext context, snapshot) {
//       emailController.text = snapshot.data.data['email'];
//       nameController.text = snapshot.data.data['firstName'];
//       phoneController.text = snapshot.data.data['contact'];

//       //for profile
//       return Stack(
//         children: <Widget>[
//           Container(
//             width: MediaQuery.of(context).size.width,
//             child: Container(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Stack(
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.only(top: 50),
//                         child: (_image != null)
//                             ? CircleAvatar(
//                                 radius: 80,
//                                 child: Image.file(
//                                   _image,
//                                   fit: BoxFit.contain,
//                                 ),
//                               )
//                             : (imgUrl != null)
//                                 ? CircleAvatar(
//                                     backgroundColor: Colors.blueGrey,
//                                     radius: 80,
//                                     child: CachedNetworkImage(imageUrl: imgUrl))
//                                 : CachedNetworkImage(
//                                     height: 100,
//                                     width: 100,
//                                     // width: MediaQuery.of(context).size.width,
//                                     fit: BoxFit.cover,
//                                     imageUrl:
//                                         "https://i.pinimg.com/originals/83/c0/0f/83c00f59d66869aa22d3bd5f35e26c6d.png",
//                                     placeholder: (context, url) =>
//                                         CircularProgressIndicator(),
//                                     errorWidget: (context, url, error) =>
//                                         Icon(Icons.error),
//                                   ),
//                       ),
//                       Positioned(
//                         top: 0,
//                         bottom: 0,
//                         left: 0,
//                         right: 0,
//                         child: IconButton(
//                           icon: Icon(Icons.camera),
//                           color: Colors.black,
//                           onPressed: () {
//                             _chooseMode(context);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(
//                       top: 20,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextFormField(
//                             enabled: false,
//                             controller: nameController,
//                             decoration: InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 labelText: 'Name'),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextFormField(
//                               enabled: false,
//                               controller: emailController,
//                               decoration: InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   labelText: 'Email')),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextFormField(
//                               controller: phoneController,
//                               decoration: InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   labelText: 'Phone Number')),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: InkWell(
//                             onTap: () {
//                               uploadPic(context);
//                               updateProfile(context);
//                               setState(() {
//                                 isUploading = true;
//                               });
//                             },
//                             child: Container(
//                               height: 50,
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                   color: Colors.blue[800],
//                                   borderRadius: BorderRadius.circular(10)),
//                               child: Center(
//                                 child: Text(
//                                   "UPDATE",
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue[800],
//         title: Text("Profile Detail"),
//         // leading: IconButton(
//         //   icon: Icon(Icons.chevron_left),
//         //   // onPressed: () {
//         //   //   // Navigator.of(context).pushReplacementNamed('/home');
//         //   // },
//         // ),
//       ),
//       body: Stack(
//         children: <Widget>[
//           SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: StreamBuilder(
//                     stream: Firestore.instance
//                         .collection('users')
//                         .document(userEmail)
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData)
//                         return LinearProgressIndicator(
//                           backgroundColor: Colors.green,
//                         );
//                       return _buildProfileListItem(context, snapshot);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

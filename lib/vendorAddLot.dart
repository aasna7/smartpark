import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VendorAddLot extends StatefulWidget {
  final LatLng locationCoord;
  VendorAddLot({this.locationCoord});
  @override
  _VendorAddLotState createState() => _VendorAddLotState();
}

class _VendorAddLotState extends State<VendorAddLot> {
  TextEditingController lotName = TextEditingController();
  TextEditingController lotLocation = TextEditingController();
  TextEditingController lotOpenTime = TextEditingController();
  TextEditingController lotCloseTime = TextEditingController();
  TextEditingController lotBikeCapacity = TextEditingController();
  TextEditingController lotCarCapacity = TextEditingController();
  TextEditingController lotBikeFee = TextEditingController();
  TextEditingController lotCarFee = TextEditingController();
  @override
  void initState() {
    convert();
    super.initState();
  }

  bool sunday = false;
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;
  String country;
  String postalCode;
  String locality;
  String subLocality;
  List day = [];
  void convert() async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        widget.locationCoord.latitude, widget.locationCoord.longitude);
    setState(() {
      country = placemark[0].country;
      postalCode = placemark[0].postalCode;
      locality = placemark[0].locality;
      subLocality = placemark[0].subLocality;
    });
    print(placemark[0].country);
    print(placemark[0].position);
    print(placemark[0].locality);
    print(placemark[0].subLocality);
  }

  @override
  Widget build(BuildContext context) {
    Future<String> addLot() async {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final String userEmail = user.email.toString();
      Firestore.instance.collection('parkinglot').document(userEmail).setData({
        'email': userEmail.trim(),
        'lotName': lotName.text.trim(),
        //'lotLocation': lotLocation.text.trim(),
        'lotOpenTime': lotOpenTime.text.trim(),
        'lotCloseTime': lotCloseTime.text.trim(),
        'lotOpenDays': day,
        'lotBikeCapacity': lotBikeCapacity.text.trim(),
        'lotCarCapacity': lotCarCapacity.text.trim(),
        'lotBikeFee': lotBikeFee.text.trim(),
        'lotCarFee': lotCarFee.text.trim(),
        'lotLocation': new GeoPoint(
            widget.locationCoord.latitude, widget.locationCoord.longitude)
      });
      print(userEmail);
      return userEmail;
    }

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Add Lot")),
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
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'images/logo.PNG',
                    height: 200,
                    width: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: lotName,
                    decoration: InputDecoration(
                        hintText: 'Parking Lot Name',
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  // child: TextFormField(
                  //   controller: lotLocation,
                  //   decoration: InputDecoration(
                  //       hintText: 'Location', border: OutlineInputBorder()),
                  // ),
                  child: Text(
                    "Lot Location",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 8),
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: Text(
                            (country != null &&
                                    locality != null &&
                                    postalCode != null)
                                ? locality +
                                    ", " +
                                    country +
                                    postalCode.toString()
                                : "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: lotOpenTime,
                          decoration: InputDecoration(
                              hintText: 'Open Time',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: lotCloseTime,
                          decoration: InputDecoration(
                              hintText: 'Close Time',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    "Opening Days",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Wrap(
                  spacing: 0,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          sunday = !sunday;
                          print(sunday);
                          if (sunday) {
                            day.add('sunday');
                          } else {
                            day.remove('sunday');
                          }
                          print(day);
                        });
                      },
                      child: Container(
                        // height: 50,
                        margin: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width / 10.05,
                        decoration: sunday == false
                            ? BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1))
                            : BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text('S',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ))),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          monday = !monday;
                          print(monday);
                          if (monday) {
                            day.add('monday');
                          } else {
                            day.remove('monday');
                          }
                          print(day);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width / 10.05,
                        decoration: monday == false
                            ? BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1))
                            : BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text('M',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ))),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          tuesday = !tuesday;
                          print(tuesday);
                          if (tuesday) {
                            day.add('tuesday');
                          } else {
                            day.remove('tuesday');
                          }
                          print(day);
                        });
                      },
                      child: Container(
                        //height: 50,
                        margin: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width / 10.05,
                        decoration: tuesday == false
                            ? BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1))
                            : BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text('T',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          wednesday = !wednesday;
                          print(wednesday);
                          if (wednesday) {
                            day.add('wednesday');
                          } else {
                            day.remove('wednesday');
                          }
                          print(day);
                        });
                      },
                      child: Container(
                        // height: 50,
                        margin: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width / 10.05,
                        decoration: wednesday == false
                            ? BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1))
                            : BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1)),

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text('W',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          thursday = !thursday;
                          print(thursday);
                          if (thursday) {
                            day.add('thursday');
                          } else {
                            day.remove('thursday');
                          }
                          print(day);
                        });
                      },
                      child: Container(
                        //height: 50,
                        margin: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width / 10.05,
                        decoration: thursday == false
                            ? BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1))
                            : BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text('T',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          friday = !friday;
                          print(friday);
                          if (friday) {
                            day.add('friday');
                          } else {
                            day.remove('friday');
                          }
                          print(day);
                        });
                      },
                      child: Container(
                        //height: 50,
                        margin: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width / 10.05,
                        decoration: friday == false
                            ? BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1))
                            : BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text('F',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          saturday = !saturday;
                          print(saturday);
                          if (saturday) {
                            day.add('saturday');
                          } else {
                            day.remove('saturday');
                          }
                          print(day);
                        });
                      },
                      child: Container(
                        //height: 50,
                        margin: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width / 10.05,
                        decoration: saturday == false
                            ? BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1))
                            : BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text('S',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    "Capacity",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: lotBikeCapacity,
                          decoration: InputDecoration(
                              hintText: 'No. of Bikes',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: lotCarCapacity,
                          decoration: InputDecoration(
                              hintText: 'No. of Cars',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    "Parking Fee per Hour",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: lotBikeFee,
                          decoration: InputDecoration(
                              hintText: 'Bike Fee',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: lotCarFee,
                          decoration: InputDecoration(
                              hintText: 'Car Fee',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: addLot,
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.green[800],
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text('Add Lot',
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

class PlacePicker extends StatefulWidget {
  @override
  _PlacePickerState createState() => _PlacePickerState();
}

class _PlacePickerState extends State<PlacePicker> {
  GoogleMapController _controller;

  Set<Marker> Markers;

  PageController _pageController;
  double longitude;
  double latitude;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  int prevPage;
  @override
  void initState() {
    super.initState();
    getLocation();
    Markers = Set.from([]);
  }

  void getLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      if (mounted)
        setState(() {
          longitude = position.longitude;
          latitude = position.latitude;
        });
    });
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Lot Location"),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            (latitude == null && longitude == null)
                ? Container()
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(latitude, longitude), zoom: 17.0),
                      markers: Set.from(Markers),
                      myLocationButtonEnabled: true,
                      rotateGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      compassEnabled: true,
                      myLocationEnabled: true,
                      onMapCreated: mapCreated,
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      mapType: MapType.normal,
                      onTap: (position) {
                        Marker mk1 =
                            Marker(markerId: MarkerId('1'), position: position);
                        setState(() {
                          Markers.add(mk1);
                        });
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton.extended(
            icon: Icon(Icons.location_on),
            label: Text("Set Location"),
            onPressed: () {
              if (Markers.length < 1) {
                print("No Markers added");
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VendorAddLot(
                              locationCoord: LatLng(
                                  Markers.first.position.latitude,
                                  Markers.first.position.longitude),
                            )));
                print(Markers.first.position);
              }
            },
          ),
        ),
      ),
    );
  }
}

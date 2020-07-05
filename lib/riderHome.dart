import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smartpark/lotModel.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class RiderHome extends StatefulWidget {
  @override
  _RiderHomeState createState() => _RiderHomeState();
}

class _RiderHomeState extends State<RiderHome> {
  GoogleMapController _controller;

  List<Marker> allMarkers = [];

  List<Lot> lots = [];

  PageController _pageController;
  double longitude;
  double latitude;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  int prevPage;
  @override
  void initState() {
    super.initState();
    getLocation();

    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
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
    getLots();
  }

  void getLots() async {
    await Firestore.instance
        .collection("parkinglot")
        .getDocuments()
        .then((element) {
      element.documents.forEach((lot) {
        setState(() {
          lots.add(Lot.fromMap(lot.data));
          allMarkers.add(Marker(
              icon: BitmapDescriptor.defaultMarker,
              markerId: MarkerId(lot.data["markerId"]),
              draggable: true,
              infoWindow: InfoWindow(
                  title: lot.data["lotName"], snippet: lot.data['lotName']),
              position: LatLng(lot.data["lotLocation"].latitude,
                  lot.data["lotLocation"].longitude)));
        });
      });
    });
  }

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      moveCamera();
    }
  }

  _lotList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 400.0,
            width: Curves.easeInOut.transform(value) * 400.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
        onTap: () {
          moveCamera();
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          // height: 200.0,
          // width: 350.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0.0, 4.0),
                  blurRadius: 10.0,
                ),
              ]),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200]),
            child: Row(
              children: [
                Flexible(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RiderBookingPage(
                                    email: lots[index].email,
                                  )));
                    },
                    child: Container(
                      // height: 100,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child:
                            CachedNetworkImage(imageUrl: lots[index].userImage),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.0),
                Flexible(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lots[index].lotName,
                          style: TextStyle(
                              fontSize: 12.5, fontWeight: FontWeight.bold),
                        ),
                        Text("Car Slots:" + lots[index].carSlots),
                        Text("Bike Slots: " + lots[index].bikeSlots),
                        Text("Opening Time: " +
                            lots[index].openTime +
                            "-" +
                            lots[index].closeTime)
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  moveCamera() {
    if (lots.length == 0) {
      print("Is Null");
    } else {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: lots[_pageController.page.toInt()].locationCoords,
              zoom: 17.0,
              bearing: 45.0,
              tilt: 45.0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text("Rider Home"),
            backgroundColor: Color.fromARGB(0xff, 11, 34, 66)),
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
                        markers: Set.from(allMarkers),
                        myLocationButtonEnabled: true,
                        rotateGesturesEnabled: true,
                        tiltGesturesEnabled: true,
                        compassEnabled: true,
                        myLocationEnabled: true,
                        onMapCreated: mapCreated,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        mapType: MapType.normal,
                      ),
                    ),
              Positioned(
                top: 50,
                child: Container(
                  height: 120.0,
                  width: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: lots.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _lotList(index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class RiderBookingPage extends StatefulWidget {
  String email;
  RiderBookingPage({this.email});
  @override
  _RiderBookingPageState createState() => _RiderBookingPageState();
}

class _RiderBookingPageState extends State<RiderBookingPage> {
  TextEditingController reserveTime = TextEditingController();
  int bikeSlots = 0;
  int carSlots = 0;
  List capacityOfBike = [];

  void initState() {
    super.initState();
    getLots();
  }

  // Future<String> getLots() async {
  //   var docRef =
  //       Firestore.instance.collection('parkinglot').document(widget.email);
  //   docRef.get().then((doc) {
  //     this.setState(() {
  //       bikeSlots = int.parse(doc.data["lotBikeCapacity"]);
  //       carSlots = int.parse(doc.data["lotCarCapacity"]);
  //     });
  //   });
  //   return widget.email;
  // }
  Future<String> getLots() async {
    var docRef =
        Firestore.instance.collection('parkinglot').document(widget.email);
    docRef.get().then((doc) {
      capacityOfBike = doc.data["lotBikeCapacity"];
      print(capacityOfBike);
      this.setState(() {
        // capacityOfBike.add(doc.data["lotBikeCapacity"][0]);
        bikeSlots = doc.data["lotBikeCapacity"].length;
        carSlots = int.parse(doc.data["lotCarCapacity"]);
      });
    });
    // print("capacity of bike" + capacityOfBike[0]);
    return widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Book Slots"),
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                bottom: 76,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        itemCount: carSlots, // Number of slot of Car
                        itemBuilder: (BuildContext context, int index) {
                          index = index + 1;
                          return InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Stack(
                                        overflow: Overflow.visible,
                                        children: <Widget>[
                                          Positioned(
                                            right: -40.0,
                                            height: 100,
                                            top: -40.0,
                                            child: InkResponse(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: CircleAvatar(
                                                child: Icon(Icons.close),
                                                backgroundColor: Colors.red,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              controller: reserveTime,
                                              decoration: InputDecoration(
                                                  hintText: 'Reserve Time',
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              height: 50,
                                              margin: EdgeInsets.all(8),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  color: Colors.green[800],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                child: Text('Book',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                              ),
                              child: Center(child: Text('Car Slot No. $index')),
                            ),
                          );
                        }),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount:
                            capacityOfBike.length, // number of slot for bike
                        itemBuilder: (BuildContext context, int index) {
                          int number = index + 1;
                          return InkWell(
                            onTap: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                child: new CupertinoAlertDialog(
                                  title: new Column(
                                    children: <Widget>[
                                      new Text(
                                          "Do you want to book this slot?"),
                                      new Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                  content: new Text("Bike slot no. $number"),
                                  actions: <Widget>[
                                    new FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          print("You have selected " +
                                              capacityOfBike[index]
                                                  ["slotName"]);
                                        },
                                        child: new Text("OK"))
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              height: 80,
                              decoration:
                                  capacityOfBike[index]["available"] == "true"
                                      ? BoxDecoration(
                                          border: Border.all(width: 1),
                                          color: Colors.green)
                                      : BoxDecoration(
                                          border: Border.all(width: 1),
                                          color: Colors.red),
                              child: Center(
                                  child:
                                      Text(capacityOfBike[index]["slotName"])),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

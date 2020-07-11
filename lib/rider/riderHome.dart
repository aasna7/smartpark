import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smartpark/rider/lotModel.dart';

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
  TextEditingController arrivingTime = TextEditingController();
  int bikeSlots = 0;
  int carSlots = 0;
  int slotNumber = 0;
  String bikeFee;
  String carFee;
  List capacityOfBike = [];
  List capacityofCar = [];
  String lotName;

  void initState() {
    super.initState();
    getLots();
  }

  Future<String> getLots() async {
    var docRef =
        Firestore.instance.collection('parkinglot').document(widget.email);
    docRef.get().then((doc) {
      capacityOfBike = doc.data["lotBikeCapacity"];

      capacityofCar = doc.data["lotCarCapacity"];
      lotName = doc.data["lotName"];
      print(capacityofCar);
      this.setState(() {
        bikeSlots = doc.data["lotBikeCapacity"].length;
        carSlots = doc.data["lotCarCapacity"].length;
        bikeFee = doc.data['lotBikeFee'];
        carFee = doc.data['lotCarFee'];
      });
    });
    // print("capacity of bike" + capacityOfBike[0]);
    return widget.email;
  }

  Future<String> bookCarSlots(name, number) async {
    print("name");
    print(name);
    print("number");
    print(number);
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String userEmail = user.email.toString();

    Firestore.instance.collection('reservation').document().setData({
      "riderEmail": userEmail,
      "vendorEmail": widget.email,
      "vehicleType": "Car",
      "reserveTime": reserveTime.text,
      "arrivingTime": arrivingTime.text,
      "slotNo": capacityofCar[slotNumber]["slotName"],
      "lotName": lotName
    });

    Firestore.instance
        .collection('parkinglot')
        .document(widget.email)
        .updateData({
      'lotCarCapacity': FieldValue.arrayUnion([
        {
          "available": 'false',
          'slotName': name,
        }
      ]),
    });

    Firestore.instance
        .collection('parkinglot')
        .document(widget.email)
        .updateData({
      'lotCarCapacity': FieldValue.arrayRemove([
        {'available': 'true', 'slotName': name, 'bookedBy': userEmail}
      ]),
    });

    print("data updated" + name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Text("Slot Booked"),
          actions: <Widget>[
            FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  Future<String> bookBikeSlots(name, number) async {
    print("name");
    print(name);
    print("number");
    print(number);
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String userEmail = user.email.toString();

    Firestore.instance.collection('reservation').document().setData({
      "riderEmail": userEmail,
      "vendorEmail": widget.email,
      "vehicleType": "Bike",
      "reserveTime": reserveTime.text,
      "arrivingTime": arrivingTime.text,
      "slotNo": capacityOfBike[slotNumber]["slotName"],
      "lotName": lotName
    });

    Firestore.instance
        .collection('parkinglot')
        .document(widget.email)
        .updateData({
      'lotBikeCapacity': FieldValue.arrayUnion([
        {
          "available": 'false',
          'slotName': name,
        }
      ]),
    });

    Firestore.instance
        .collection('parkinglot')
        .document(widget.email)
        .updateData({
      'lotBikeCapacity': FieldValue.arrayRemove([
        {'available': 'true', 'slotName': name, 'Booked By': userEmail}
      ]),
    });

    print("data updated" + name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Text("Slot Booked"),
          actions: <Widget>[
            FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
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
                          int number = index + 1;
                          return capacityofCar[index]["available"] == "true"
                              ? InkWell(
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
                                                  top: -40.0,
                                                  child: InkResponse(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: CircleAvatar(
                                                      child: Icon(Icons.close),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                Form(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          controller:
                                                              reserveTime,
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      "Reserve Time"),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          controller:
                                                              arrivingTime,
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      "Arriving Time"),
                                                        ),
                                                      ),
                                                      Text(
                                                          "Car slot no. $number"),
                                                      Text("Fee per Hour: " +
                                                          carFee),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: RaisedButton(
                                                          child: Text(
                                                            "Book",
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {
                                                              slotNumber =
                                                                  index;
                                                              bookCarSlots(
                                                                  capacityofCar[
                                                                          index]
                                                                      [
                                                                      "slotName"],
                                                                  index);
                                                              print("You have selected " +
                                                                  capacityofCar[
                                                                          index]
                                                                      [
                                                                      "slotName"]);

                                                              print("The slotNUmber is" +
                                                                  slotNumber
                                                                      .toString());
                                                            });
                                                          },
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          18.0),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .red)),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    height: 120,
                                    decoration: capacityofCar[index]
                                                ["available"] ==
                                            "true"
                                        ? BoxDecoration(
                                            border: Border.all(width: 1),
                                            color: Colors.green)
                                        : BoxDecoration(
                                            border: Border.all(width: 1),
                                            color: Colors.red),
                                    child: Center(
                                        child: Text("Car Slot No. " +
                                            capacityofCar[index]["slotName"])),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return AlertDialog(
                                          content: Text("Slot Not Available"),
                                          actions: <Widget>[
                                            FlatButton(
                                                child: Text("Ok"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                }),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 80,
                                    decoration: capacityofCar[index]
                                                ["available"] ==
                                            "true"
                                        ? BoxDecoration(
                                            border: Border.all(width: 1),
                                            color: Colors.green)
                                        : BoxDecoration(
                                            border: Border.all(width: 1),
                                            color: Colors.red),
                                    child: Center(
                                        child: Text("Car Slot No. " +
                                            capacityofCar[index]["slotName"])),
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
                          return capacityOfBike[index]["available"] == "true"
                              ? InkWell(
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
                                                  top: -40.0,
                                                  child: InkResponse(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: CircleAvatar(
                                                      child: Icon(Icons.close),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                Form(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          controller:
                                                              reserveTime,
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      "Reserve Time"),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          controller:
                                                              arrivingTime,
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      "Arriving Time"),
                                                        ),
                                                      ),
                                                      Text(
                                                          "Bike slot no. $number"),
                                                      Text("Fee per Hour: " +
                                                          bikeFee),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: RaisedButton(
                                                          child: Text(
                                                            "Book",
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            print("You have selected " +
                                                                capacityOfBike[
                                                                        index][
                                                                    "slotName"]);
                                                            setState(() {
                                                              slotNumber =
                                                                  index;

                                                              print(slotNumber);
                                                            });
                                                            bookBikeSlots(
                                                                capacityOfBike[
                                                                        index][
                                                                    "slotName"],
                                                                index);
                                                          },
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          18.0),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .red)),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    height: 80,
                                    decoration: capacityOfBike[index]
                                                ["available"] ==
                                            "true"
                                        ? BoxDecoration(
                                            border: Border.all(width: 1),
                                            color: Colors.green)
                                        : BoxDecoration(
                                            border: Border.all(width: 1),
                                            color: Colors.red),
                                    child: Center(
                                        child: Text("Bike Slot No. " +
                                            capacityOfBike[index]["slotName"])),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return AlertDialog(
                                          content: Text("Slot Not Available"),
                                          actions: <Widget>[
                                            FlatButton(
                                                child: Text("Ok"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                }),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 80,
                                    decoration: capacityOfBike[index]
                                                ["available"] ==
                                            "true"
                                        ? BoxDecoration(
                                            border: Border.all(width: 1),
                                            color: Colors.green)
                                        : BoxDecoration(
                                            border: Border.all(width: 1),
                                            color: Colors.red),
                                    child: Center(
                                        child: Text("Bike Slot No. " +
                                            capacityOfBike[index]["slotName"])),
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

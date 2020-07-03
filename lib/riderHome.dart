import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                  title: lot.data["LotName"], snippet: lot.data['LotName']),
              position: LatLng(lot.data["LocationCoord"].latitude,
                  lot.data["LocationCoord"].longitude)));
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
                          CachedNetworkImage(imageUrl: lots[index].thumbNail),
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
                        Text(lots[index].vacentSlot)
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

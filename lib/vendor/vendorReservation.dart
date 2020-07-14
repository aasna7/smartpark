import 'package:flutter/material.dart';
import 'package:smartpark/vendor/vendorReservationList.dart';

class VendorReservation extends StatefulWidget {
  @override
  _VendorReservationState createState() => _VendorReservationState();
}

class _VendorReservationState extends State<VendorReservation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Reservations"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(0xff, 11, 34, 66)),
      body: VendorReservationList(),
    );
  }
}

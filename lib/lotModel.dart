import 'package:google_maps_flutter/google_maps_flutter.dart';

class Lot {
  String lotName;
  String vacentSlot;
  String thumbNail;
  LatLng locationCoords;

  Lot({this.lotName, this.vacentSlot, this.thumbNail, this.locationCoords});

  Lot.fromMap(Map snapshot)
      : lotName = snapshot["LotName"],
        vacentSlot = snapshot['vacentSlots'],
        thumbNail = snapshot["thumbNail"],
        locationCoords = LatLng(snapshot["LocationCoord"].latitude,
            snapshot["LocationCoord"].longitude);
}

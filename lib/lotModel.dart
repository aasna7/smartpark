import 'package:google_maps_flutter/google_maps_flutter.dart';

class Lot {
  String email;
  String lotName;
  String carSlots;
  String bikeSlots;
  String carFee;
  String bikeFee;
  String openTime;
  String closeTime;
  String userImage;
  LatLng locationCoords;

  Lot(
      {this.email,
      this.lotName,
      this.carSlots,
      this.bikeSlots,
      this.openTime,
      this.closeTime,
      this.userImage,
      this.locationCoords});

  Lot.fromMap(Map snapshot)
      : email = snapshot['email'],
        lotName = snapshot["lotName"],
        carSlots = snapshot['lotCarCapacity'],
        bikeSlots = snapshot['lotBikeCapacity'],
        openTime = snapshot['lotOpenTime'],
        closeTime = snapshot['lotCloseTime'],
        userImage = snapshot['userImage'],
        locationCoords = LatLng(snapshot["lotLocation"].latitude,
            snapshot["lotLocation"].longitude);
}

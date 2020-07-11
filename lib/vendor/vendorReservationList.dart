import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VendorReservationList extends StatefulWidget {
  @override
  _VendorReservationListState createState() => _VendorReservationListState();
}

class _VendorReservationListState extends State<VendorReservationList> {
  Future getReservation() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String userEmail = user.email.toString();
    QuerySnapshot qn = await Firestore.instance
        .collection('reservation')
        .where("vendorEmail", isEqualTo: userEmail)
        .getDocuments();
    print(qn.documents);
    return qn.documents; // print("capacity of bike" + capacityOfBike[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getReservation(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading.."));
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return Card(
                    elevation: 5.0,
                    child: ListTile(
                      leading: Icon(Icons.local_offer),
                      title: Text(
                        "Slot No. :" + snapshot.data[index].data['slotNo'],
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text("Booked By:" +
                          snapshot.data[index].data['riderEmail'] +
                          "\n" +
                          "Vehicle Type:" +
                          snapshot.data[index].data['vehicleType'] +
                          "\n" +
                          "Arriving Time:" +
                          snapshot.data[index].data['arrivingTime'] +
                          "\n" +
                          "Reserving Type:" +
                          snapshot.data[index].data['reserveTime']),
                      trailing: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Reservation?'),
                                content: Text(
                                    "Are you sure you want to delete this package ?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("YES"),
                                    onPressed: () async {
                                      //Put your code here which you want to execute on Yes button click.
                                      await Firestore.instance
                                          .collection('reservation')
                                          .document(
                                              snapshot.data[index].documentID)
                                          .delete();
                                      Navigator.of(context).pop();
                                      getReservation();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("NO"),
                                    onPressed: () {
                                      //Put your code here which you want to execute on No button click.
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("CANCEL"),
                                    onPressed: () {
                                      //Put your code here which you want to execute on Cancel button click.
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}

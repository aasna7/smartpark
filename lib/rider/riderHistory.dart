import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RiderHistory extends StatefulWidget {
  @override
  _RiderHistoryState createState() => _RiderHistoryState();
}

class _RiderHistoryState extends State<RiderHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rider History"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(0xff, 11, 34, 66),
      ),
      body: RiderHistoryList(),
    );
  }
}

class RiderHistoryList extends StatefulWidget {
  @override
  _RiderHistoryListState createState() => _RiderHistoryListState();
}

class _RiderHistoryListState extends State<RiderHistoryList> {
  String userEmail;
  Future getHistory() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userEmail = user.email.toString();
    QuerySnapshot qn = await Firestore.instance
        .collection('reservation')
        .where("riderEmail", isEqualTo: userEmail)
        .getDocuments();
    print(qn.documents);
    return qn.documents; // print("capacity of bike" + capacityOfBike[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getHistory(),
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
                      leading: Icon(Icons.history),
                      title: Text(
                        snapshot.data[index].data['lotName'],
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text("Slot No.:" +
                          snapshot.data[index].data['slotNo'] +
                          "\n" +
                          "Vehicle Type:" +
                          snapshot.data[index].data['vehicleType'] +
                          "\n" +
                          "Arriving Time:" +
                          snapshot.data[index].data['arrivingTime'] +
                          "\n" +
                          "Reserving Type:" +
                          snapshot.data[index].data['reserveTime']),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}

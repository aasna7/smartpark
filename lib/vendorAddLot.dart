import 'package:flutter/material.dart';

class VendorAddLot extends StatefulWidget {
  @override
  _VendorAddLotState createState() => _VendorAddLotState();
}

class _VendorAddLotState extends State<VendorAddLot> {
  bool sunday = false;
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;

  List day = [];
  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Parking Lot Name',
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Location', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
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
                          decoration: InputDecoration(
                              hintText: 'Close Time',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
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
                  height: 10,
                ),
                Wrap(
                  spacing: 15,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          sunday = !sunday;
                          if (!sunday) {
                            day.add('S');
                          } else {
                            day.remove('S');
                          }
                          print(day);
                        });
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width / 8,
                        decoration: sunday
                            ? BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1))
                            : BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1)),
                        child: Center(
                            child: Text('S',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          monday = !monday;
                          if (!monday) {
                            day.add('M');
                          } else {
                            day.remove('M');
                          }
                          print(day);
                        });
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width / 8,
                        decoration: monday
                            ? BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1))
                            : BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1)),
                        child: Center(
                            child: Text('M',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width / 8,
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1)),
                      child: Center(
                        child: Text('T',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width / 8,
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1)),
                      child: Center(
                        child: Text('W',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width / 8,
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1)),
                      child: Center(
                        child: Text('T',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width / 8,
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1)),
                      child: Center(
                        child: Text('F',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width / 8,
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1)),
                      child: Center(
                        child: Text('S',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.green[800],
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text('Add Vehicle',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
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

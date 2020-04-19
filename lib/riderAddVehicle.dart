import 'package:flutter/material.dart';

class RiderAddVehicle extends StatefulWidget {
  @override
  _RiderAddVehicleState createState() => _RiderAddVehicleState();
}

class _RiderAddVehicleState extends State<RiderAddVehicle> {
  String dropdownValue = 'Bike';

  TextEditingController vehicleType = TextEditingController();
  TextEditingController vehicleModel = TextEditingController();
  TextEditingController vehicleNumber = TextEditingController();

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
              children: <Widget>[
                Image.asset(
                  'images/logo.PNG',
                  height: 200,
                  width: 200,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(12),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color: Colors.grey[600],
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 20,
                      elevation: 30,
                      style: TextStyle(color: Colors.grey[600]),
                      hint: Text("Vehicle Type"),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>['Bike', 'Scooter', 'Car', 'Van']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Vehicle Model',
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Vehicle Number',
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 20,
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

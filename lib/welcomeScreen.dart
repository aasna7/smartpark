import 'package:flutter/material.dart';
import 'package:smartpark/riderLogin.dart';
import 'package:smartpark/vendorLogin.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0xff, 24, 32, 88),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(
              'images/scooter.png',
              height: MediaQuery.of(context).size.height / 4,
            ),
          ),
          Text(
            "SMART PARK",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(
            height: 60,
          ),
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RiderLogin()));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      // height: MediaQuery.of(context).size.height / 4.5,
                      width: MediaQuery.of(context).size.width / 2 - 16,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'images/car1.png',
                            height: MediaQuery.of(context).size.height / 6,
                          ),
                          Text(
                            'I am a Rider.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => VendorLogin()));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      // height: MediaQuery.of(context).size.height / 4.5,
                      width: MediaQuery.of(context).size.width / 2 - 16,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'images/car.png',
                            height: MediaQuery.of(context).size.height / 6,
                          ),
                          Text(
                            'I am a Vendor.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),

      // child: Center(
      //   child: Column(
      //     children: <Widget>[Image.asset('images/scooter.png')],
      //   ),
      // ),
    );
    // return Scaffold(
    //   backgroundColor: Color.fromARGB(0xff, 24, 32, 88),
    //   body: Padding(
    //     padding: const EdgeInsets.only(left: 20, right: 20),
    //     child: Column(
    //       children: <Widget>[
    //         Padding(
    //           padding: const EdgeInsets.only(top: 40),
    //           child: Image.asset(
    //             'images/scooter.png',
    //             height: 200,
    //             // width: 200,
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.only(bottom: 12.0),
    //           child: Text(
    //             "SMART PARK",
    //             style: TextStyle(
    //                 color: Colors.white,
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: 25),
    //           ),
    //         ),
    //         SizedBox(
    //           height: 20,
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             InkWell(
    //               onTap: () {
    //                 Navigator.push(context,
    //                     MaterialPageRoute(builder: (context) => RiderLogin()));
    //               },
    //               child: Container(
    //                 // height: 200,
    //                 width: MediaQuery.of(context).size.width / 2.5,
    //                 decoration: BoxDecoration(
    //                     // border: Border.all(width: 1),
    //                     color: Colors.white,
    //                     // boxShadow: [
    //                     //   BoxShadow(
    //                     //     color: Colors.grey[400],
    //                     //     blurRadius:
    //                     //         20.0, // has the effect of softening the shadow
    //                     //     spreadRadius:
    //                     //         5.0, // has the effect of extending the shadow
    //                     //   )
    //                     // ],
    //                     borderRadius: BorderRadius.circular(10)),
    //                 child: Padding(
    //                   padding: const EdgeInsets.symmetric(vertical: 20),
    //                   child: Column(
    //                     children: <Widget>[
    //                       Image.asset(
    //                         'images/car1.png',
    //                         height: 80,
    //                       ),
    //                       Text(
    //                         'I am a Rider.',
    //                         style: TextStyle(
    //                           color: Colors.black,
    //                           fontSize: 30,
    //                           fontWeight: FontWeight.bold,
    //                         ),
    //                         textAlign: TextAlign.center,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             InkWell(
    //               onTap: () {
    //                 Navigator.push(context,
    //                     MaterialPageRoute(builder: (context) => VendorLogin()));
    //               },
    //               child: Container(
    //                 width: MediaQuery.of(context).size.width / 2.5,
    //                 decoration: BoxDecoration(
    //                     color: Colors.white,
    //                     // boxShadow: [
    //                     //   BoxShadow(
    //                     //     color: Colors.grey[400],
    //                     //     blurRadius:
    //                     //         20.0, // has the effect of softening the shadow
    //                     //     spreadRadius:
    //                     //         5.0, // has the effect of extending the shadow
    //                     //   )
    //                     // ],
    //                     borderRadius: BorderRadius.circular(10)),
    //                 child: Padding(
    //                   padding: const EdgeInsets.symmetric(vertical: 20),
    //                   child: Column(
    //                     children: <Widget>[
    //                       Image.asset(
    //                         'images/park.png',
    //                         height: 70,
    //                       ),
    //                       SizedBox(
    //                         height: 10,
    //                       ),
    //                       Text(
    //                         'I am a Vendor',
    //                         style: TextStyle(
    //                           color: Colors.black,
    //                           fontSize: 30,
    //                           fontWeight: FontWeight.bold,
    //                         ),
    //                         textAlign: TextAlign.center,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}

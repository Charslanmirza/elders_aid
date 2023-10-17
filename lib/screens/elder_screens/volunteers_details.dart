import 'dart:async';
import 'dart:convert';

import 'package:elders_aid_project/providers/bookings_provider.dart';
import 'package:elders_aid_project/screens/elder_screens/menuPage.dart';
import 'package:elders_aid_project/widgets/constants.dart';
import 'package:elders_aid_project/widgets/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class VolunteersDetail extends StatefulWidget {
  static const String idScreen = "volubterr";

  @override
  State<VolunteersDetail> createState() => _VolunteersDetailState();
}

class _VolunteersDetailState extends State<VolunteersDetail> {
  var _isLoading = false;

  var _isInIt = true;

  bool isNull = false;
  String? ratings;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> userInfo() async {
    try {
      currentFirebaseUser = fAuth.currentUser;
      DatabaseReference userRef = await FirebaseDatabase.instance
          .ref()
          .child("User")
          .child(currentFirebaseUser!.uid);
      userRef.once().then((snap) {
        if (snap.snapshot.value != null) {
          setState(() {
            ratings = UserModel.fromSnapshot(snap.snapshot).ratings;
          });
          print(UserModel.fromSnapshot(snap.snapshot).email);
        }
      });
    } catch (error) {
      throw error;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("object");
  }

  void didChangeDependencies() {
    userInfo();
    try {
      if (mounted) if (_isInIt) {
        setState(() {
          _isLoading = true;
        });
        Provider.of<BookingsProvider>(context)
            .fetchDataforCabShare()
            .then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      }
      Timer(
          Duration(seconds: 12),
          () => setState(() {
                _isLoading = false;
              }));
    } catch (error) {
      throw error;
    }
    _isInIt = false;

    super.didChangeDependencies();
  }

  String? dID;
  String? vName;
  String? vLocation;
  String? vDescription;
  bool _hasCallSupport = false;
  Future<void>? _launched;
  String? phone;
  Future<void> _makePhoneCall(String? phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber!,
    );
    await launchUrl(launchUri);
  }

  Future<void> bookRide(
    String? driId,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String driverId = currentFirebaseUser!.uid;

      await http.delete(
        Uri.parse(
          'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/cab share.json',
        ),
      );
      await bookingCredentials(
        vName!,
        vDescription!,
        vLocation!,
      );
      await http
          .post(
              Uri.parse(
                'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driId//status.json',
              ),
              //volunteer k pas jayega
              body: jsonEncode({
                'User id': currentFirebaseUser!.uid,
                'Passenger name': userModelCurrentInfo!.name,
                'Phone': userModelCurrentInfo!.phone,
                'User Role': userModelCurrentInfo!.role,
                "User email": userModelCurrentInfo!.email,
                "Status": "Accepted",
              }))
          .then((value) => Navigator.pushNamedAndRemoveUntil(
              context, MenuScreen.idScreen, (route) => false));
    } catch (error) {
      throw error;
    }
  }

  Future<void> bookingCredentials(
      String name, String description, String userLocation) async {
    try {
      String userId = currentFirebaseUser!.uid;

      http.post(
          Uri.parse(
            'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$userId/status.json',
          ),
          //admin k pas jayega
          body: jsonEncode({
            "Status": "Accepted",
            'User Id': ddidd,
            'Passenger name': name,
            'Description': description,
            'User location': userLocation,
          }));
    } catch (error) {
      throw error;
    }
  }

  String? ddidd;

  @override
  Widget build(BuildContext context) {
    final ridesDataProvider =
        Provider.of<BookingsProvider>(context, listen: false);
    final ridesData = ridesDataProvider.BookingsData;
    isNull = ridesDataProvider.isNull;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfffD5DEEF),
        appBar: AppBar(
          backgroundColor: Color(0xff3E4685),
          title: Text(
            "Volunteers",
            style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white)),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Color(0xff3E4685),
              ))
            : isNull == true
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No data to display",
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins")),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.only(top: 20),
                              itemCount: ridesData.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                dID = ridesData[index].userId;
                                vName = ridesData[index].passengerName;
                                vDescription = ridesData[index].description;
                                vLocation = ridesData[index].userLocation;
                                print("volunteer id is ${dID}");

                                return Container(
                                  padding: EdgeInsets.only(
                                      top: 5, left: 15, right: 15, bottom: 10),
                                  margin: EdgeInsets.only(
                                      left: 15, right: 15, bottom: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1,
                                          color:
                                              Colors.black.withOpacity(0.6))),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.person,
                                                      color: Color(0xff3E4685),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      // width: 50.w,
                                                      child: Text(
                                                        ridesData[index]
                                                            .passengerName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: GoogleFonts.lato(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                            Image.asset(
                                              'assets/clock.png',
                                              height: 50,
                                              width: 50,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.my_location_outlined,
                                              color: Color(0xff3E4685),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              // width: 50.w,
                                              child: Text(
                                                ridesData[index].userLocation,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Color(0xff3E4685),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              // width: 50.w,
                                              child: Text(
                                                ratings.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.description,
                                                  color: Color(0xff3E4685),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  // width: 50.w,
                                                  child: Text(
                                                    ridesData[index]
                                                        .description,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            MaterialButton(
                                                color: Color(0xff3E4685),
                                                onPressed: () async {
                                                  setState(() {
                                                    ddidd = dID;
                                                  });

                                                  await bookRide(dID);
                                                },
                                                child: Text(
                                                  "Approve",
                                                  style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          color: Colors.white)),
                                                ))
                                          ],
                                        ),
                                      ]),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

import 'dart:async';

import 'package:elders_aid_project/providers/status_provider.dart';
import 'package:elders_aid_project/screens/elder_screens/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ViewStatusDetail extends StatefulWidget {
  static const String idScreen = "vorrrr";

  @override
  State<ViewStatusDetail> createState() => _ViewStatusDetailState();
}

class _ViewStatusDetailState extends State<ViewStatusDetail> {
  var _isLoading = false;

  var _isInIt = true;

  bool isNull = false;
  var uId;

  void didChangeDependencies() {
    try {
      if (mounted) if (_isInIt) {
        setState(() {
          _isLoading = true;
        });
        Provider.of<StatusProviderElder>(context)
            .fetchDataforStatusEelder()
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

  @override
  void initState() {
    super.initState();

    // Check for phone call support.
  }

  // Future<void> delRide() async {
  //   String driverId = currentFirebaseUser!.uid;

  //   await http.delete(
  //     Uri.parse(
  //       'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/rides history.json',
  //     ),
  //   );
  //   await http.delete(
  //     Uri.parse(
  //       'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/cab share.json',
  //     ),
  //   );

  //   await http.delete(
  //     Uri.parse(
  //       'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/status.json',
  //     ),
  //   );

  //   await http.delete(
  //     Uri.parse(
  //       'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/My rides.json',
  //     ),
  //   );

  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (context) => MenuScreen()));
  // }

  @override
  Widget build(BuildContext context) {
    final ridesDataProvider =
        Provider.of<StatusProviderElder>(context, listen: false);
    final ridesData = ridesDataProvider.statusData;
    isNull = ridesDataProvider.isNull;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfffD5DEEF),
        appBar: AppBar(
          backgroundColor: Color(0xff3E4685),
          title: Text(
            "Status details",
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
                                                ridesData[index].status,
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
                                                onPressed: () {
                                                  // delRide();
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (c) =>
                                                              RateDriverScreen(
                                                                assignedDriverId:
                                                                    ridesData[
                                                                            index]
                                                                        .did,
                                                                assignedDriverDescription:
                                                                    ridesData[
                                                                            index]
                                                                        .description,
                                                                assignedDriverLocation:
                                                                    ridesData[
                                                                            index]
                                                                        .userLocation,
                                                                assignedDriverName:
                                                                    ridesData[
                                                                            index]
                                                                        .passengerName,
                                                              )));
                                                },
                                                child: Text(
                                                  "Mark Complete",
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

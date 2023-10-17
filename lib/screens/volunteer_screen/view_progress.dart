import 'dart:async';
import 'dart:convert';
import 'package:elders_aid_project/providers/status_provider.dart';
import 'package:elders_aid_project/screens/elder_screens/menuPage.dart';
import 'package:elders_aid_project/screens/volunteer_screen/menu_page_volunteer.dart';
import 'package:elders_aid_project/widgets/constants.dart';
import 'package:elders_aid_project/widgets/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/bookings_provider.dart';

class ProgressDetail extends StatefulWidget {
  static const String idScreen = "vol";

  @override
  State<ProgressDetail> createState() => _ProgressDetailState();
}

class _ProgressDetailState extends State<ProgressDetail> {
  var _isLoading = false;

  var _isInIt = true;

  bool isNull = false;

  void didChangeDependencies() {
    try {
      if (mounted) if (_isInIt) {
        setState(() {
          _isLoading = true;
        });
        Provider.of<StatusProvider>(context).fetchDataforStatus().then((value) {
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
  }

  String phoone = "";

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    final ridesDataProvider =
        Provider.of<StatusProvider>(context, listen: false);
    final ridesData = ridesDataProvider.statusData;
    isNull = ridesDataProvider.isNull;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfffD5DEEF),
        appBar: AppBar(
          backgroundColor: Color(0xff3E4685),
          title: Text(
            "View Progress",
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
                                phoone = ridesData[index].phone;
                                return InkWell(
                                  onTap: () async {},
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 5,
                                        left: 15,
                                        right: 15,
                                        bottom: 10),
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
                                                        Icons.mail,
                                                        color:
                                                            Color(0xff3E4685),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Container(
                                                        // width: 50.w,
                                                        child: Text(
                                                          ridesData[index]
                                                              .userEmail,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.face,
                                                color: Color(0xff3E4685),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Container(
                                                // width: 50.w,
                                                child: Text(
                                                  ridesData[index].userRole,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star_outlined,
                                                color: Color(0xff3E4685),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Container(
                                                // width: 50.w,
                                                child: Text(
                                                  ridesData[index].status,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.phone,
                                                    color: Color(0xff3E4685),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    // width: 50.w,
                                                    child: Text(
                                                      ridesData[index].phone,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.lato(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              MaterialButton(
                                                  color: Color(0xff3E4685),
                                                  onPressed: () async {
                                                    await _makePhoneCall(
                                                        phoone);
                                                  },
                                                  child: Text(
                                                    "Make a call",
                                                    style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ))
                                            ],
                                          ),
                                        ]),
                                  ),
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

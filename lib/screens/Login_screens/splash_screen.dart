import 'dart:async';

import 'package:elders_aid_project/screens/Login_screens/Login_page.dart';
import 'package:elders_aid_project/screens/elder_screens/menuPage.dart';
import 'package:elders_aid_project/screens/oldhouse_screens/oldhouse_menu_page.dart';
import 'package:elders_aid_project/screens/volunteer_screen/menu_page_volunteer.dart';
import 'package:elders_aid_project/widgets/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  static const String idScreen = "splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void startTimer() async {
    try {
      Timer(Duration(seconds: 5), () async {
        if (await fAuth.currentUser != null) {
          currentFirebaseUser = fAuth.currentUser;
          final userId = currentFirebaseUser!.uid;

          await FirebaseDatabase.instance
              .ref()
              .child("User")
              .child(userId)
              .once()
              .then((DataSnapshot) {
            print(userId);
            print(DataSnapshot.snapshot.value);
            Map student = DataSnapshot.snapshot.value as Map;
            setState(() {
              if (student['role'] == "Volunteer") {
                Navigator.pushNamedAndRemoveUntil(
                    context, MenuScreenVoulenteer.idScreen, (route) => false);
              } else if (student['role'] == 'Elder') {
                Navigator.pushNamedAndRemoveUntil(
                    context, MenuScreen.idScreen, (route) => false);
              } else if (student['role'] == 'Old house') {
                Navigator.pushNamedAndRemoveUntil(
                    context, OldHouseMenuPage.idScreen, (route) => false);
              }
            });
          });
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, LoginPage.idScreen, (route) => false);
        }
      });
    } catch (e) {}
    // fAuth.currentUser != null
    //     ? AssistantMethods.readCurrentOnlineUserInfo()
    //     : null;
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'Elders Aid',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff3E4685),
                        )),
                        children: []),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:elders_aid_project/providers/task_providers.dart';
import 'package:elders_aid_project/screens/elder_screens/menuPage.dart';
import 'package:elders_aid_project/widgets/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class RateDriverScreen extends StatefulWidget {
  static const String idScreen = "my";
  String? assignedDriverId;
  String? assignedDriverName;
  String? assignedDriverLocation;
  String? assignedDriverDescription;

  RateDriverScreen(
      {this.assignedDriverId,
      this.assignedDriverName,
      this.assignedDriverDescription,
      this.assignedDriverLocation});

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  double countRatingStars = 0.0;
  String titleStarsRating = "";

  Future<void> delRide() async {
    String driverId = currentFirebaseUser!.uid;
    await http.post(
        Uri.parse(
          'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/past task.json',
        ),
        body: jsonEncode({
          'name': widget.assignedDriverName,
          'Location': widget.assignedDriverLocation,
          'Description': widget.assignedDriverDescription,
          'Rating': countRatingStars.toString(),
        }));
    DatabaseReference rateDriverRef = FirebaseDatabase.instance
        .ref()
        .child("User")
        .child(widget.assignedDriverId!)
        .child("ratings");

    rateDriverRef.once().then((snap) {
      if (snap.snapshot.value == null) {
        rateDriverRef.set(countRatingStars.toString());
      } else {
        double pastRatings = double.parse(snap.snapshot.value.toString());
        double newAverageRatings = (pastRatings + countRatingStars) / 2;
        rateDriverRef.set(newAverageRatings.toString());
      }

      Fluttertoast.showToast(msg: "Task has been successfully completed");
    });

    await http.delete(
      Uri.parse(
        'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/rides history.json',
      ),
    );
    await http.delete(
      Uri.parse(
        'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/cab share.json',
      ),
    );

    await http.delete(
      Uri.parse(
        'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/status.json',
      ),
    );

    await http.delete(
      Uri.parse(
        'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/My rides.json',
      ),
    );

    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => MenuScreen()));
  }

  // Future<void> shareRide() async {
  //   String driverId = currentFirebaseUser!.uid;
  //   await http.post(
  //       Uri.parse(
  //         'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/past task.json',
  //       ),
  //       body: jsonEncode({
  //         'name': widget.assignedDriverName,
  //         'Location': widget.assignedDriverLocation,
  //         'Description': widget.assignedDriverDescription,
  //         'Rating': countRatingStars.toString(),
  //       }));

  //   // Navigator.of(context)
  //   //     .push(MaterialPageRoute(builder: (context) => MenuScreen()));
  // }

  // Future<void> postRating() async {

  // }

  @override
  Widget build(BuildContext context) {
    final ridesDataProvider = Provider.of<MyTasksProvider>(context);
    final ridesData = ridesDataProvider.MyTaskData;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Dialog(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Rate Experience",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Divider(
                    thickness: 0.3,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SmoothStarRating(
                    rating: countRatingStars,
                    allowHalfRating: false,
                    starCount: 5,
                    color: Color(0xff3E4685),
                    borderColor: Color(0xff3E4685),
                    size: 40,
                    onRatingChanged: (valueOfStarsChoosed) {
                      countRatingStars = valueOfStarsChoosed;

                      if (countRatingStars == 1) {
                        setState(() {
                          titleStarsRating = "Very Bad";
                        });
                      }
                      if (countRatingStars == 2) {
                        setState(() {
                          titleStarsRating = "Bad";
                        });
                      }
                      if (countRatingStars == 3) {
                        setState(() {
                          titleStarsRating = "Good";
                        });
                      }
                      if (countRatingStars == 4) {
                        setState(() {
                          titleStarsRating = "Very Good";
                        });
                      }
                      if (countRatingStars == 5) {
                        setState(() {
                          titleStarsRating = "Excellent";
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    titleStarsRating,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontFamily: "poppins",
                      fontSize: 18,
                      color: Color(0xff3E4685),
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        delRide();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MenuScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff3E4685),
                        padding: EdgeInsets.symmetric(horizontal: 74),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "poppins",
                          color: Colors.white,
                        ),
                      )),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

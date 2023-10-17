import 'dart:convert';

import 'package:elders_aid_project/screens/elder_screens/menuPage.dart';
import 'package:elders_aid_project/widgets/constants.dart';
import 'package:elders_aid_project/widgets/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CreateTask extends StatefulWidget {
  static const String idScreen = "create";

  const CreateTask({Key? key}) : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _charges = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _date = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool activeRide = false;
  late String rideDate;
  late String rideTime;
  bool _isLoading = false;
  final namefocus = FocusNode();
  final descriptionfocus = FocusNode();
  final chargesfocus = FocusNode();
  final timefocus = FocusNode();
  final locationfocus = FocusNode();
  final datefocus = FocusNode();
  List<String> carTypesList = [
    "Get an item",
    "Home assistance",
    "Technical Work"
  ];
  DateTime selectedDate = DateTime.now();

  String? selectedCarType;

  Future<void> bookingStatus() async {
    try {
      String driverId = currentFirebaseUser!.uid;
      final response = await http.get(Uri.parse(
        'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/rides history.json',
      ));
      print(response.statusCode);
      final extractedData =
          await json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((key, value) {
        rideDate = value["Date"];
        rideTime = value["Time"];
        print(rideDate + rideTime);
      });
      if (DateTime.parse(rideDate + " " + rideTime).isAfter(DateTime.now())) {
        if (mounted)
          setState(() {
            activeRide = true;
          });
        print('Active');
      }
      if (DateTime.parse(rideDate + " " + rideTime).isBefore(DateTime.now())) {
        print('Not Active');
        setState(() {
          activeRide = false;
          _isLoading = true;
        });
      }
      if (rideDate.isEmpty) {
        print(null);
      } else {
        print("Something went wrong");
      }
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        activeRide = false;
        _isLoading = false;
      });
    }
  }

  Future<void> shareRide() async {
    String driverId = currentFirebaseUser!.uid;
    await http.post(
        Uri.parse(
          'https://eldersaid-9d168-default-rtdb.firebaseio.com/tasks.json',
        ),
        body: jsonEncode({
          "Name": userModelCurrentInfo!.name,
          'Driver id': driverId,
          'Charges': _charges.text,
          'Description': _description.text,
          'Date': _date.text,
          'Time': _time.text,
          'Location': _location.text,
          "Type": selectedCarType
        }));

    await http.post(
        Uri.parse(
          'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/rides history.json',
        ),
        body: jsonEncode({
          "Time": _time.text,
          "Date": _date.text,
        }));
    await http.post(
        Uri.parse(
          'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/My rides.json',
        ),
        body: jsonEncode({
          "Name": userModelCurrentInfo!.name,
          'Driver id': driverId,
          'Charges': _charges.text,
          'Description': _description.text,
          'Date': _date.text,
          'Time': _time.text,
          'Location': _location.text,
          "Type": selectedCarType
        }));

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MenuScreen()));
  }

  @override
  void didChangeDependencies() {
    if (mounted) bookingStatus();
    //   // _date.text = DateTime.now().toString().substring(0, 10);
    //   // _time.text = DateTime.now().toString().substring(11, 16);
    ///   TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _name.dispose();
    _charges.dispose();
    _date.dispose();
    _description.dispose();
    _location.dispose();
    _time.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3E4685),
        title: Text(
          "Create Task",
          style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white)),
        ),
      ),
      backgroundColor: Color(0xfffD5DEEF),
      body: _isLoading == false
          ? activeRide == false
              ? Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Add details.",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: "poppins",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Charges',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: TextFormField(
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                        prefixIcon: Icon(
                                          Icons.money,
                                        ),
                                      ),
                                      controller: _charges,
                                      focusNode: chargesfocus,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(chargesfocus);
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please  provide number of seats you want to book';
                                        }
                                        if (value == 0) {
                                          return 'Please  provide number of seats you want to book';
                                        }
                                        // if (int.parse(value) > _seatsAvailable) {
                                        //   return 'Maximum ' +
                                        //       _seatsAvailable.toString() +
                                        //       ' seats are available';
                                        // }
                                      }),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Description',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: "poppins",
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: TextFormField(
                                      minLines: 1,
                                      maxLines: 3,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                        prefixIcon: Icon(
                                          Icons.description,
                                        ),
                                      ),
                                      controller: _description,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(descriptionfocus);
                                      },
                                      focusNode: descriptionfocus,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please  provide description';
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Location',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: "poppins",
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: TextFormField(
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                        prefixIcon: Icon(
                                          Icons.my_location_outlined,
                                        ),
                                      ),
                                      controller: _location,
                                      keyboardType: TextInputType.text,
                                      focusNode: locationfocus,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(locationfocus);
                                      },
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please provide location point';
                                        }
                                        if (value.length < 3) {
                                          return 'Please provide valid location point';
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Date',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: "poppins",
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: TextFormField(
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2101));

                                        if (pickedDate != null) {
                                          String formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);

                                          setState(() {
                                            _date.text =
                                                formattedDate; //set foratted date to TextField value.
                                          });
                                        } else {
                                          print("Date is not selected");
                                        }
                                      },
                                      readOnly: true,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Select date",
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                        prefixIcon: Icon(
                                          Icons.date_range,
                                        ),
                                      ),
                                      controller: _date,
                                      focusNode: datefocus,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(datefocus);
                                      },
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please provide date of ride';
                                        }
                                      }),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Select service',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontFamily: "poppins",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: DropdownButton(
                                              // focusColor: Colors.grey,
                                              style: TextStyle(
                                                  fontFamily: "poppins",
                                                  fontSize: 14,
                                                  color: Colors.black),
                                              iconSize: 20,
                                              value: selectedCarType,
                                              items: carTypesList.map((car) {
                                                return DropdownMenuItem(
                                                  child: Text(car),
                                                  value: car,
                                                );
                                              }).toList(),
                                              onChanged: ((value) {
                                                setState(() {
                                                  selectedCarType =
                                                      value.toString();
                                                });
                                              }),
                                              hint: Text(
                                                "Please choose service",
                                                style: TextStyle(
                                                    fontFamily: "poppins",
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate() &&
                                      selectedCarType!.isNotEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Task Added Successfully");
                                    await shareRide();
                                  }
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xff3E4685))),
                                child: Text(
                                  'Create Task',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              : Center(
                  child: Text(
                    "You can add only one task at this until the time ends",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.black)),
                  ),
                )
          : Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              color: Color(0xff3E4685),
            )),
    ));
  }
}

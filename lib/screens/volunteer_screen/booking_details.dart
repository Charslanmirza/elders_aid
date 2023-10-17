import 'dart:convert';
import 'package:elders_aid_project/screens/elder_screens/menuPage.dart';
import 'package:elders_aid_project/screens/volunteer_screen/menu_page_volunteer.dart';
import 'package:elders_aid_project/widgets/constants.dart';
import 'package:elders_aid_project/widgets/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

import '../../providers/task_providers.dart';
import '../../widgets/rides_model.dart';

class BookingDetails extends StatefulWidget {
  static const routeName = 'bookingDetails';

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  final TextEditingController _name = TextEditingController();

  final TextEditingController _description = TextEditingController();
  final TextEditingController _userLocation = TextEditingController();
  final TextEditingController fare = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final name = FocusNode();
  final bookSeats = FocusNode();
  final description = FocusNode();
  final pickUp = FocusNode();
  final dropOff = FocusNode();
  String? driverId;
  String? rideId;

  @override
  void dispose() {
    name.dispose();
    bookSeats.dispose();
    description.dispose();
    pickUp.dispose();
    dropOff.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else
      print('error');
  }

  bool _isLoading = false;

  Future<void> bookRide(String driverId, String name, String description,
      String userLocation, String rideid) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await bookingCredentials(
        rideid,
        name,
        description,
        userLocation,
      );
      await http
          .post(
              Uri.parse(
                'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId//cab share.json',
              ),
              body: jsonEncode({
                'User id': currentFirebaseUser!.uid,
                'Passenger name': userModelCurrentInfo!.name,
                'Description': description,
                'User location': userLocation,
                "Ride id": rideid
              }))
          .then((value) => Navigator.pushNamedAndRemoveUntil(
              context, MenuScreenVoulenteer.idScreen, (route) => false));
    } catch (error) {
      throw error;
    }
  }

  Future<void> bookingCredentials(String rideId, String name,
      String description, String userLocation) async {
    try {
      String userId = currentFirebaseUser!.uid;

      http.post(
          Uri.parse(
            'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$userId/rideCredentials.json',
          ),
          body: jsonEncode({
            'Ride id': rideId,
            'Passenger name': userModelCurrentInfo!.name,
            'Description': description,
            'User location': userLocation,
          }));
    } catch (error) {
      throw error;
    }
  }

  int? _bookedSeats;
  int? _remainingSeats;
  int? rideFare;

  late int _index;
  late List<RidesModel> ridesData;

  @override
  void didChangeDependencies() {
    ridesData = Provider.of<RidesProvider>(context, listen: false).RidesData;
    _index = ModalRoute.of(context)!.settings.arguments as int;
    print("ridessss dataaaaaaaaaaaaa" + ridesData[_index].rideId.toString());
    print("ridessss dataaaaaaaaaaaaa" +
        ridesData[_index].driverIdModel.toString());
    setState(() {});
    rideId = ridesData[_index].rideId.toString();
    driverId = ridesData[_index].driverIdModel.toString();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // ridesData = Provider.of<RidesProvider>(context, listen: false).RidesData;
    // _index = ModalRoute.of(context)!.settings.arguments as int;
    // print("ridessss dataaaaaaaaaaaaa" + ridesData[_index].rideId.toString());
    // final _args = ModalRoute.of(context)!.settings.arguments as List<int>;
    // final ridesData = Provider.of<RidesProvider>(context).RidesData;
    // String? key = Provider.of<RidesProvider>(context).RidesData;
    // print("Key is");
    // print("Key is"+key.toString());
    // final int _index = _args[0];
    // print(index.toString());
    // String _driverId = ridesData[_index].driverIdModel;
    // int name = _args[2];
    // int abc = _args[1];
    // String rideId = ridesData[_index].rideId;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfffD5DEEF),
        appBar: AppBar(
          backgroundColor: Color(0xff3E4685),
          title: Text(
            "Booking details",
            style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white)),
          ),
        ),
        body: _isLoading == true
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Please provide the following details.",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: "poppins",
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Container(
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: <Widget>[
                            //       Text(
                            //         'Name',
                            //         style: const TextStyle(
                            //           fontSize: 12,
                            //           fontFamily: "poppins",
                            //         ),
                            //       ),
                            //       const SizedBox(
                            //         height: 10,
                            //       ),
                            //       Container(
                            //         child: TextFormField(
                            //             style: TextStyle(
                            //               fontFamily: "Poppins",
                            //             ),
                            //             decoration: InputDecoration(
                            //               floatingLabelBehavior:
                            //                   FloatingLabelBehavior.never,
                            //               border: InputBorder.none,
                            //               fillColor: Color(0xfff3f3f4),
                            //               filled: true,
                            //               prefixIcon: Icon(
                            //                 Icons.person,
                            //               ),
                            //             ),
                            //             controller: _name,
                            //             keyboardType: TextInputType.url,
                            //             textInputAction: TextInputAction.next,
                            //             onFieldSubmitted: (_) {
                            //               FocusScope.of(context)
                            //                   .requestFocus(bookSeats);
                            //             },
                            //             validator: (value) {
                            //               if (value!.isEmpty) {
                            //                 return 'Please provide name';
                            //               }
                            //             }),
                            //       ),
                            //     ],
                            //   ),
                            // ),
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
                                          prefixIcon:
                                              Icon(Icons.document_scanner),
                                          filled: true,
                                        ),
                                        controller: _description,
                                        focusNode: description,
                                        keyboardType: TextInputType.multiline,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(context)
                                              .requestFocus(pickUp);
                                        },
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
                                        controller: _userLocation,
                                        focusNode: pickUp,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(context)
                                              .requestFocus(dropOff);
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please provide location';
                                          }
                                          if (value.length < 3) {
                                            return 'Please provide valid location';
                                          }
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 1.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: SizedBox(
                        height: 40,
                        width: 10,
                        child: MaterialButton(
                          color: Color(0xff3E4685),
                          child: Text(
                            'Book',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: "Poppins",
                            ),
                          ),
                          onPressed: () {
                            setState(() {});
                            if (_formKey.currentState!.validate())
                              bookRide(
                                  driverId!,
                                  _name.text.toString(),
                                  _description.text.toString(),
                                  _userLocation.text.toString(),
                                  rideId!);
                          },
                        )),
                  ),
                ],
              ),
      ),
    );
  }
}

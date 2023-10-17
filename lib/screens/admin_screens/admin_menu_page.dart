import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:elders_aid_project/screens/Login_screens/Login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostScreen extends StatefulWidget {
  static const String idScreen = "admin";
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  bool? Available;
  bool? userAvailable;
  String StatusText = 'Block';
  bool? DriverAvailable;
  bool? driverAvailable;
  Color driverStatusColor = Colors.black;
  final ref = FirebaseDatabase.instance.ref('User');
  final List<bool> _selected = List.generate(20, (i) => false);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    // await Provider.of<BookingsProvider>(context,listen: false
    // ).getDriverState();

    // await getDriverState();
    setState(() {
      // driverAvailable = Provider.of<BookingsProvider>(context).DriverAvailable;
      // _loadingState = true;
      Available = userAvailable;
      // _loadingState = false;
    });
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginPage.idScreen, (route) => false);
                },
                icon: Icon(Icons.logout))
          ],
          backgroundColor: Color(0xff3E4685),
          elevation: 0.0,
          title: Text(
            "Admin",
            style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white)),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                  query: ref,
                  defaultChild: Text('Loading'),
                  itemBuilder: (context, snapshot, animation, index) {
                    return ListTile(
                        visualDensity: VisualDensity(
                            vertical: 3, horizontal: 2), //<-- SEE HERE
                        leading: CircleAvatar(
                            backgroundColor: Color(0xff3E4685),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            )),
                        title: Text(
                          snapshot.child('name').value.toString(),
                          style: GoogleFonts.lato(textStyle: TextStyle()),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   snapshot.child('email').value.toString(),
                            //   style: GoogleFonts.lato(textStyle: TextStyle()),
                            // ),
                            Text(
                              snapshot.child('role').value.toString(),
                              style: GoogleFonts.lato(textStyle: TextStyle()),
                            ),
                            Text(
                              snapshot.child('ratings').value.toString(),
                              style: GoogleFonts.lato(textStyle: TextStyle()),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xff3E4685)),
                          onPressed: () async {
                            setState(
                                () => _selected[index] = !_selected[index]);
                            if (driverAvailable != true) {
                              DatabaseReference rideReqRef = FirebaseDatabase
                                  .instance
                                  .ref()
                                  .child("User")
                                  .child(snapshot.key.toString())
                                  .child("Status");
                              rideReqRef.set(true);
                              setState(() {
                                driverStatusColor = Colors.green;
                                driverAvailable = true;
                              });
                            } else {
                              DatabaseReference rideReqRef = FirebaseDatabase
                                  .instance
                                  .ref()
                                  .child("User")
                                  .child(snapshot.key.toString())
                                  .child("Status");
                              rideReqRef.set(false);

                              setState(() {
                                driverStatusColor = Colors.black;
                                driverAvailable = false;
                              });
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              _selected[index] ? "Block" : "Unblock",
                              // driverAvailable == false
                              //     ? "Block"
                              //     : driverAvailable == true
                              //         ? "Unblock"
                              //         : "Loading",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                        )
                        // trailing: PopupMenuButton(
                        //     color: Colors.white,
                        //     elevation: 4,
                        //     padding: EdgeInsets.zero,
                        //     shape: const RoundedRectangleBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(2))),
                        //     icon: Icon(
                        //       Icons.more_vert,
                        //     ),
                        //     itemBuilder: (context) => [
                        //           PopupMenuItem(
                        //             value: 2,
                        //             child: ListTile(
                        //               onTap: () {
                        //                 patchDriverState(
                        //                     true, snapshot.key.toString());
                        //               },
                        //               leading: Icon(Icons.block),
                        //               title: Text(Available == false
                        //                   ? "Block"
                        //                   : "Unblock"),
                        //             ),
                        //           ),
                        //         ]),
                        );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> patchDriverState(bool Status, String id) async {
    try {
      await http.post(
          Uri.parse(
            'https://eldersaid-9d168-default-rtdb.firebaseio.com/User.json',
          ),
          body: jsonEncode({
            "available": Status,
          }));
    } catch (error) {
      throw error;
    }
  }
  // Future<void> patchDriverState(bool Status, String id) async {
  //   try {
  //     await http
  //         .delete(Uri.parse(
  //           'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$id/Available/.json',
  //         ))
  //         .then((value) => http.post(
  //             Uri.parse(
  //               'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$id/Available/.json',
  //             ),
  //             body: jsonEncode({
  //               "available": Status,
  //             })));
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  getDriverState(String id) async {
    try {
      final response = await http.get(Uri.parse(
        'https://gowithme-4fd09-default-rtdb.firebaseio.com/Drivers/$id/Available.json',
      ));
      print(response.statusCode);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((key, extractedData) {
        if (extractedData != null)
          userAvailable = extractedData["available"] as bool;
      });
    } catch (error) {
      throw error;
    }
  }
}

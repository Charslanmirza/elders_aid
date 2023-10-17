import 'package:elders_aid_project/providers/task_providers.dart';
import 'package:elders_aid_project/screens/Login_screens/Login_page.dart';
import 'package:elders_aid_project/widgets/constants.dart';
import 'package:elders_aid_project/widgets/new_transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class OldHouseMenuPage extends StatefulWidget {
  static const String idScreen = "old house";
  const OldHouseMenuPage({Key? key}) : super(key: key);

  @override
  State<OldHouseMenuPage> createState() => _OldHouseMenuPageState();
}

class _OldHouseMenuPageState extends State<OldHouseMenuPage> {
  var _isLoading = false;
  var _isInIt = true;
  bool isNull = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  void didChangeDependencies() {
    if (mounted)
      try {
        if (_isInIt) {
          setState(() {
            _isLoading = true;
          });
          Provider.of<oldTasksProvider>(context)
              .fetchMyData()
              .then((value) async {
            setState(() {
              _isLoading = false;
            });
            // await Provider.of<RidesProvider>(context).driverResponse();
          });
        }
        _isInIt = false;
      } catch (error) {
        throw error;
      }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> delRide() async {
    String driverId = currentFirebaseUser!.uid;
    await http.delete(
      Uri.parse(
        'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/My.json',
      ),
    );
    setState(() {});
    print("deleted");
  }

  @override
  Widget build(BuildContext context) {
    final ridesDataProvider = Provider.of<oldTasksProvider>(context);
    final ridesData = ridesDataProvider.MyTaskData;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Future<bool?> showWarning(BuildContext context) async {
      showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text('Are you sure you want to quit?'),
                actions: <Widget>[
                  MaterialButton(
                      child: Text('Yes'),
                      onPressed: () => Navigator.pop(context, true)),
                  MaterialButton(
                      child: Text('No'),
                      onPressed: () => Navigator.pop(context, false)),
                ]);
          });
    }

    return WillPopScope(
      onWillPop: () async {
        var shouldpop = await showWarning(context);
        return shouldpop ?? true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xfffD5DEEF),
          // key: scaffoldKey,
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginPage.idScreen, (route) => false);
                    setState(() {});
                  },
                  icon: Icon(Icons.logout))
            ],
            backgroundColor: Color(0xff3E4685),
            elevation: 0.0,
            title: Text(
              "Old House",
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            centerTitle: true,
          ),

          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Color(0xff3E4685),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, left: 18, right: 150),
                      child: Text(
                        "Welcome to Dashboard.",
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Services/Workers.",
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xff3E4685)),
                                onPressed: () {
                                  _startAddNewTransaction(context);
                                },
                                child: Text("Add"))
                          ],
                        ),
                        _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                color: Color(0xff3E4685),
                              ))
                            : isNull == true
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "No data to display",
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.black)),
                                        ),
                                        // Text(
                                        //       "You can add new rides after ride time ends",
                                        //       style: TextStyle(
                                        //           fontSize: 11.sp,
                                        //           fontWeight: FontWeight.w500,
                                        //           fontFamily: "Poppins")),
                                      ],
                                    ),
                                  )
                                : SingleChildScrollView(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics: ClampingScrollPhysics(),
                                        padding: EdgeInsets.only(top: 20),
                                        itemCount: ridesData.length,
                                        itemBuilder:
                                            (BuildContext ctx, int index) {
                                          String name =
                                              ridesData[index].locationModel;

                                          return Card(
                                            margin: EdgeInsets.all(6),
                                            elevation: 6,
                                            color: Color(0xff3E4685),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 20,
                                                  child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5,
                                                          vertical: 5),
                                                      child: Icon(
                                                        Icons.person,
                                                        color:
                                                            Color(0xff3E4685),
                                                      )),
                                                ),
                                                title: Text(
                                                  ridesData[index].nameModel,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      ridesData[index]
                                                          .locationModel,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.lato(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                    Text(
                                                      ridesData[index]
                                                          .descriptionModel,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.lato(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ],
                                                ),
                                                trailing: IconButton(
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      delRide();
                                                    },
                                                    icon: Icon(Icons.delete)),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startAddNewTransaction(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return NewTransaction();
        });
  }

  // void _addnewtransaction(String title, double amount, DateTime chosendate) {
  //   final newtx = Transaction(
  //     title,
  //     amount,
  //     chosendate,
  //     DateTime.now().toString(),
  //   );
  //   setState(() {
  //     _usertransaction.add(newtx);
  //   });
  // }
}

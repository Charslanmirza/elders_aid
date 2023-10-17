import 'package:elders_aid_project/providers/task_providers.dart';
import 'package:elders_aid_project/screens/elder_screens/menuPage.dart';
import 'package:elders_aid_project/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MyTask extends StatefulWidget {
  static const String idScreen = "mytask";
  const MyTask({Key? key}) : super(key: key);

  @override
  State<MyTask> createState() => _MyTaskState();
}

class _MyTaskState extends State<MyTask> {
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
          Provider.of<MyTasksProvider>(context)
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
        'https://eldersaid-9d168-default-rtdb.firebaseio.com/tasks.json',
      ),
    );

    await http.delete(
      Uri.parse(
        'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/rides history.json',
      ),
    );

    await http.delete(
      Uri.parse(
        'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/My rides.json',
      ),
    );

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MenuScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final ridesDataProvider = Provider.of<MyTasksProvider>(context);
    final ridesData = ridesDataProvider.MyTaskData;
    isNull = ridesDataProvider.isNull;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfffD5DEEF),
        appBar: AppBar(
          backgroundColor: Color(0xff3E4685),
          title: Text(
            "My Task",
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
                        Text(
                          "No data to display",
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.black)),
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
                        itemBuilder: (BuildContext ctx, int index) {
                          String name = ridesData[index].locationModel;

                          return InkWell(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 5, left: 15, right: 15, bottom: 10),
                              margin: EdgeInsets.only(
                                  left: 15, right: 15, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.black.withOpacity(0.6))),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    ridesData[index].nameModel,
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
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.group_work_sharp,
                                              color: Color(0xff3E4685),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              // width: 50.w,
                                              child: Text(
                                                ridesData[index].typeModel,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.description,
                                              color: Color(0xff3E4685),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              ridesData[index]
                                                  .descriptionModel,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      color: Colors.black)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.money,
                                              color: Color(0xff3E4685),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              // width: 50.w,
                                              child: Text(
                                                ridesData[index].fareModel,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.gps_fixed,
                                              color: Color(0xff3E4685),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              // width: 50.w,
                                              child: Text(
                                                ridesData[index].locationModel,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.timelapse_sharp,
                                              color: Color(0xff3E4685),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              // width: 50.w,
                                              child: Text(
                                                ridesData[index].timeModel,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.date_range,
                                              color: Color(0xff3E4685),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              // width: 50.w,
                                              child: Text(
                                                ridesData[index].dateModel,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: MaterialButton(
                                          color: Color(0xff3E4685),
                                          onPressed: () {
                                            delRide();
                                          },
                                          child: Text(
                                            "Delete",
                                            style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    color: Colors.white)),
                                          )),
                                    )
                                  ]),
                            ),
                          );
                        }),
                  ),
      ),
    );
  }
}

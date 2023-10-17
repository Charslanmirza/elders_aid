import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/task_providers.dart';

class CompletedTask extends StatefulWidget {
  static const String idScreen = "task";
  const CompletedTask({Key? key}) : super(key: key);

  @override
  State<CompletedTask> createState() => _CompletedTaskState();
}

class _CompletedTaskState extends State<CompletedTask> {
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
          Provider.of<PastTasksProvider>(context)
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

  @override
  Widget build(BuildContext context) {
    final ridesDataProvider = Provider.of<PastTasksProvider>(context);
    final ridesData = ridesDataProvider.MyTaskData;
    isNull = ridesDataProvider.isNull;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfffD5DEEF),
        appBar: AppBar(
          backgroundColor: Color(0xff3E4685),
          title: Text(
            "Previous Task",
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
                                                    'Volunteer Name: ${ridesData[index].nameModel}',
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
                                            'Volunteer desc: ${ridesData[index].descriptionModel}',
                                            overflow: TextOverflow.ellipsis,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
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
                                                'Volunteer Location: ${ridesData[index].locationModel}',
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
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
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
                                                'Ratings given: ${ridesData[index].rating}',
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
                                  ]),
                            ),
                          );
                        }),
                  ),
      ),
    );
  }
}

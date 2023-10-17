import 'package:elders_aid_project/screens/Login_screens/Login_page.dart';
import 'package:elders_aid_project/screens/elder_screens/completed_task.dart';
import 'package:elders_aid_project/screens/elder_screens/create_task.dart';
import 'package:elders_aid_project/screens/elder_screens/my_task.dart';
import 'package:elders_aid_project/screens/elder_screens/profile_screen.dart';
import 'package:elders_aid_project/screens/elder_screens/view_oldhouse.dart';
import 'package:elders_aid_project/screens/elder_screens/view_status.dart';
import 'package:elders_aid_project/screens/elder_screens/volunteers_details.dart';
import 'package:elders_aid_project/widgets/constants.dart';
import 'package:elders_aid_project/widgets/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuScreen extends StatefulWidget {
  static const String idScreen = "menu";
  // final String value;

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String? UserName;
  String? UserEmail;
  bool? status;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> userInfo() async {
    try {
      currentFirebaseUser = fAuth.currentUser;
      DatabaseReference userRef = await FirebaseDatabase.instance
          .ref()
          .child("User")
          .child(currentFirebaseUser!.uid);
      userRef.once().then((snap) {
        if (snap.snapshot.value != null) {
          setState(() {
            UserEmail = UserModel.fromSnapshot(snap.snapshot).email;
            UserName = UserModel.fromSnapshot(snap.snapshot).name;
            status = UserModel.fromSnapshot(snap.snapshot).status;
          });
          print(UserModel.fromSnapshot(snap.snapshot).email);
        }
      });
    } catch (error) {
      throw error;
    }
  }

  void didChangeDependencies() async {
    userInfo();
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   // await ridesDataProvider.driverResponse();
    //   await userInfo().then((value) => setState(() {
    //     // RideAccepted = ridesDataProvider.DriverResponse;
    //     // print(RideAccepted);
    //     _isLoading = false;
    //       }));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
              "ELDERS AID",
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            centerTitle: true,
          ),
          drawer: SafeArea(
            child: Container(
              width: width * 0.7,
              // color: Color(0xffFF593C),
              child: Drawer(
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color(0xff3E4685),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    UserName.toString(),
                                    style: GoogleFonts.lato(
                                        textStyle:
                                            TextStyle(color: Colors.white)),
                                  ),
                                  Text(
                                    UserEmail.toString(),
                                    style: GoogleFonts.lato(
                                        textStyle:
                                            TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const DrawerList(
                      iconName: Icons.location_on,
                      texxt: 'Address',
                    ),

                    // Divider(height: 1.0, color: Colors.grey.shade600, indent: 40.0, endIndent: 40.0,),
                    const DrawerList(
                      iconName: Icons.star,
                      texxt: 'Rate',
                    ),
                    const DrawerList(
                      iconName: Icons.share,
                      texxt: 'Share',
                    ),
                    const DrawerList(
                      iconName: Icons.feedback,
                      texxt: 'Feedback',
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Stack(
              fit: StackFit.loose,
              children: [
                Container(
                  width: double.infinity,
                  height: height * 0.3,
                  decoration: BoxDecoration(
                    color: Color(0xff3E4685),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, left: 18, right: 150),
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
                Container(
                  color: Color(0xfffD5DEEF),
                  margin: EdgeInsets.fromLTRB(0.0, 180.0, 0.0, 0.0),
                  child: GridView.count(
                    // crossAxisSpacing: 0,
                    // mainAxisSpacing: 2,
                    crossAxisCount: 2,
                    scrollDirection: Axis.vertical,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (status == true) {
                            Fluttertoast.showToast(
                                msg: "You are blocked by admin");
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CreateTask()));
                          }
                        },
                        child: ExpandedInsideContainer(
                          icon: Icon(Icons.create,
                              size: 40, color: Color(0xff3E4685)),
                          secondName: "Create Task",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, MyTask.idScreen, (route) => true);
                        },
                        child: ExpandedInsideContainer(
                          icon: Icon(Icons.share_location_rounded,
                              size: 40, color: Color(0xff3E4685)),
                          secondName: "View My Task",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(context,
                              VolunteersDetail.idScreen, (route) => true);
                        },
                        child: ExpandedInsideContainer(
                          icon: Icon(Icons.task_alt,
                              size: 40, color: Color(0xff3E4685)),
                          secondName: "View Volunteers",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(context,
                              ViewStatusDetail.idScreen, (route) => true);
                        },
                        child: ExpandedInsideContainer(
                          icon: Icon(Icons.star,
                              size: 40, color: Color(0xff3E4685)),
                          secondName: "View Status",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, CompletedTask.idScreen, (route) => true);
                        },
                        child: ExpandedInsideContainer(
                          icon: Icon(Icons.done,
                              size: 40, color: Color(0xff3E4685)),
                          secondName: "Past tasks",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, ViewOldHouse.idScreen, (route) => true);
                        },
                        child: ExpandedInsideContainer(
                          icon: Icon(Icons.house,
                              size: 40, color: Color(0xff3E4685)),
                          secondName: "Old house",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, ProfileScreen.idScreen, (route) => true);
                        },
                        child: ExpandedInsideContainer(
                          icon: Icon(Icons.person,
                              size: 40, color: Color(0xff3E4685)),
                          secondName: "Profile",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerList extends StatelessWidget {
  const DrawerList({
    // required Key key,
    required this.iconName,
    required this.texxt,

    // required this.stylee,
  });

  final IconData iconName;
  final String texxt;

  // final TextStyle stylee;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        iconName,
      ),
      title: Text(
        texxt,
        style: GoogleFonts.lato(textStyle: TextStyle()),
      ),
      onTap: () {},
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////

class ExpandedInsideContainer extends StatelessWidget {
  const ExpandedInsideContainer({
    required this.icon,
    required this.secondName,
  });

  final Icon icon;
  final String secondName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0, left: 20, right: 20),
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(
                height: 8,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: secondName,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff3E4685),
                  )),
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}

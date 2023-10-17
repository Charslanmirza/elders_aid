import 'package:elders_aid_project/screens/Login_screens/Login_page.dart';
import 'package:elders_aid_project/screens/elder_screens/create_task.dart';
import 'package:elders_aid_project/screens/elder_screens/profile_screen.dart';
import 'package:elders_aid_project/screens/volunteer_screen/view_progress.dart';
import 'package:elders_aid_project/screens/volunteer_screen/view_task.dart';
import 'package:elders_aid_project/screens/elder_screens/volunteers_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/constants.dart';
import '../../widgets/user_model.dart';

class MenuScreenVoulenteer extends StatefulWidget {
  static const String idScreen = "voullenteer";
  // final String value;

  @override
  _MenuScreenVoulenteerState createState() => _MenuScreenVoulenteerState();
}

class _MenuScreenVoulenteerState extends State<MenuScreenVoulenteer> {
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
          print(UserModel.fromSnapshot(snap.snapshot).status);
        }
      });
    } catch (error) {
      throw error;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("object");
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
                  height: 500,
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
                SizedBox(
                  height: 50,
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
                                builder: (context) => ViewTask()));
                          }
                        },
                        child: ExpandedInsideContainer(
                          icon: Icon(Icons.remove_red_eye,
                              size: 40, color: Color(0xff3E4685)),
                          secondName: "View task",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(context,
                              ProgressDetail.idScreen, (route) => true);
                        },
                        child: ExpandedInsideContainer(
                          icon: Icon(Icons.share_location_rounded,
                              size: 40, color: Color(0xff3E4685)),
                          secondName: "View Progress",
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

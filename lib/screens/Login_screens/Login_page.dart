import 'package:elders_aid_project/screens/Login_screens/PasswordReset.dart';
import 'package:elders_aid_project/screens/Login_screens/Signup_page.dart';
import 'package:elders_aid_project/screens/admin_screens/admin_login.dart';
import 'package:elders_aid_project/screens/elder_screens/menuPage.dart';
import 'package:elders_aid_project/screens/oldhouse_screens/oldhouse_menu_page.dart';
import 'package:elders_aid_project/screens/volunteer_screen/menu_page_volunteer.dart';
import 'package:elders_aid_project/widgets/constants.dart';
import 'package:elders_aid_project/widgets/rides_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  static const String idScreen = "login";
  LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget _emailField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Email Id",
            style: GoogleFonts.lato(
                textStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail),
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email Required';
              }
              return null;
            },
            // onSaved: (value) {
            //   userLoginData['email'] = value!;
            // },
            controller: emailController,
          ),
        ],
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Password",
              style: GoogleFonts.lato(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: passwordController,
            obscureText: true,

            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password Required';
              }
              return null;
            },
            // onSaved: (value) {
            //   userLoginData['password'] = value!;
            // },
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: loginUser,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xff3E4685),
                  Color(0xff3E4685),
                ])),
        child: Text(
          'Login Now',
          style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel1() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPageAdmin()));
      },
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Login as',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Admin',
              style: TextStyle(
                  color: Color(0xff3E4685),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(5),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xff3E4685),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .catchError((errmsg) {
      displayToastMessage("Error" + errmsg.toString(), context);
    }))
        .user;
    if (firebaseUser != null) {
      currentFirebaseUser = fAuth.currentUser;
      final userId = currentFirebaseUser!.uid;
      DatabaseReference userRef = FirebaseDatabase.instance.ref().child("User");
      userRef.child(firebaseUser.uid).once().then((userKey) async {
        final snap = userKey.snapshot;
        if (snap.value != null) {
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
                fAuth.currentUser != null
                    ? AssistantMethods.readCurrentOnlineUserInfo()
                    : null;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MenuScreenVoulenteer()));
              } else if (student['role'] == 'Elder') {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MenuScreen()));
                fAuth.currentUser != null
                    ? AssistantMethods.readCurrentOnlineUserInfo()
                    : null;
                // Navigator.pushNamedAndRemoveUntil(
                //     context, CreateTask.idScreen, (route) => false);
              } else if (student['role'] == 'Old house') {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OldHouseMenuPage()));
                fAuth.currentUser != null
                    ? AssistantMethods.readCurrentOnlineUserInfo()
                    : null;
                // Navigator.pushNamedAndRemoveUntil(
                //     context, CreateTask.idScreen, (route) => false);
              }
            });
          });
          currentFirebaseUser = firebaseUser;
          // Navigator.pushNamed(context, MenuScreen.idScreen);
          displayToastMessage("Your are logged in", context);
        } else {
          fAuth.signOut();
          Navigator.pop(context);
          displayToastMessage("no record fount", context);
        }
      });
      // displayToastMessage("congratulations", context);
      // Navigator.of(context).push(
      //     MaterialPageRoute(builder: (BuildContext context) => MenuScreen()));
    } else {
      fAuth.signOut();
      Navigator.pop(context);
      displayToastMessage("No record exist", context);
      Navigator.of(context).pop();
    }
  }

  Widget _title() {
    return RichText(
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
    );
  }

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _emailField(),
        _passwordField(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xfffD5DEEF),
          body: Container(
            height: height,
            child: Stack(
              children: <Widget>[
                Positioned(
                    top: -height * .10,
                    right: -MediaQuery.of(context).size.width * .4,
                    child: Container()),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .2),
                        _title(),
                        SizedBox(height: 40),
                        _emailPasswordWidget(),
                        SizedBox(height: 20),
                        _submitButton(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetPage()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            child: Text('Forgot Password ?',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff3E4685))),
                          ),
                        ),
                        SizedBox(height: 30),
                        _divider(),
                        SizedBox(height: height * .1),
                        _createAccountLabel(),
                        _createAccountLabel1(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

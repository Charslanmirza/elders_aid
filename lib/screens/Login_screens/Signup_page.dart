import 'package:elders_aid_project/screens/Login_screens/Login_page.dart';
import 'package:elders_aid_project/widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  static const String idScreen = "signup";
  SignUpPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  List<String> carTypesList = ["Elder", "Volunteer", "Old house"];
  String? selectedCarType;
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
                prefixIcon: Icon(Icons.email),
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
          Text(
            "Password",
            style: GoogleFonts.lato(
                textStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
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

  Widget _contactField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Phone no",
            style: GoogleFonts.lato(
                textStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: contactController,

            decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone),
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),

            // onSaved: (value) {
            //   userLoginData['password'] = value!;
            // },
          ),
        ],
      ),
    );
  }

  Widget _usernameField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Username",
            style: GoogleFonts.lato(
                textStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: nameController,

            decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),

            // onSaved: (value) {
            //   userLoginData['password'] = value!;
            // },
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(5),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Alredy have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
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

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  Widget _emailPasswordWidget() {
    return Form(
      child: Column(
        children: <Widget>[
          _usernameField(),
          _emailField(),
          _passwordField(),
          _contactField()
        ],
      ),
    );
  }

  Future<void> registerUser() async {
    final User? firebaseUser = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .catchError((errmsg) {
      displayToastMessage("error" + errmsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      Map userDataMap = {
        "id": firebaseUser.uid,
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": contactController.text.trim(),
        "role": selectedCarType,
        "Status": false
        // "status": patchDriverState
      };
      DatabaseReference userRef = FirebaseDatabase.instance.ref().child("User");
      await userRef.child(firebaseUser.uid).set(userDataMap);
      print("asdasdaaaaaaaasa${firebaseUser.uid}");

      // currentFirebaseUser = firebaseUser;

      displayToastMessage(
          "Congratulations your account has been created successfuly", context);
      Navigator.pushNamedAndRemoveUntil(
          context, LoginPage.idScreen, (route) => false);

      // Navigator.of(context).pop();
    }
  }

  Widget _submitButton(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        if (nameController.text.isEmpty ||
            emailController.text.isEmpty ||
            contactController.text.isEmpty ||
            selectedCarType!.isEmpty) {
          Fluttertoast.showToast(msg: "Please Fill the Form");
        } else {
          registerUser();
        }
      }),
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
                colors: [Color(0xff3E4685), Color(0xff3E4685)])),
        child: Text(
          'Register Now',
          style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
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
                    top: -height * .8,
                    right: -MediaQuery.of(context).size.width * .4,
                    child: Container()),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .15),
                        _title(),
                        SizedBox(height: 30),
                        _emailPasswordWidget(),
                        DropdownButton(
                          focusColor: Colors.grey,
                          borderRadius: BorderRadius.circular(5),
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
                              selectedCarType = value.toString();
                            });
                          }),
                          hint: Text(
                            "Please choose role",
                            style: TextStyle(
                                fontFamily: "poppins",
                                fontSize: 14,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 10),
                        _submitButton(context),
                        SizedBox(height: height * .01),
                        _createAccountLabel(),
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

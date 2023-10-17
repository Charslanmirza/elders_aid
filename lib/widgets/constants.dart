import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

displayToastMessage(msg, BuildContext context) {
  Fluttertoast.showToast(msg: msg);
}

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;

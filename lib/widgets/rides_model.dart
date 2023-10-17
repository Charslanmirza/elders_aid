import 'package:elders_aid_project/widgets/constants.dart';
import 'package:elders_aid_project/widgets/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RidesModel extends ChangeNotifier {
  final String nameModel;
  final String locationModel;
  final String timeModel;
  final String dateModel;
  final String driverIdModel;
  final String descriptionModel;
  final String fareModel;
  final String rideId;
  final String typeee;

  RidesModel(
      {required this.nameModel,
      required this.locationModel,
      required this.timeModel,
      required this.dateModel,
      required this.driverIdModel,
      required this.descriptionModel,
      required this.fareModel,
      required this.rideId,
      required this.typeee});
}

class OldHouseModel extends ChangeNotifier {
  final String nameModel;
  final String title;

  final String descriptionModel;
  final String locationModel;

  OldHouseModel(
      {required this.nameModel,
      required this.locationModel,
      required this.descriptionModel,
      required this.title});
}

class AssistantMethods {
  static Future<void> readCurrentOnlineUserInfo() async {
    try {
      currentFirebaseUser = fAuth.currentUser;
      DatabaseReference userRef = await FirebaseDatabase.instance
          .ref()
          .child("User")
          .child(currentFirebaseUser!.uid);
      userRef.once().then((snap) {
        if (snap.snapshot.value != null) {
          userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
        }
      });
    } catch (error) {
      throw error;
    }
  }
}

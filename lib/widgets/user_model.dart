import 'package:firebase_database/firebase_database.dart';

UserModel? userModelCurrentInfo;
UserModel2? userModelCurrentInfo2;

class UserModel {
  String? phone;
  String? name;
  String? id;
  String? email;
  bool? status;
  String? ratings;
  String? role;

  UserModel({this.phone, this.name, this.id, this.email, this.role});

  UserModel.fromSnapshot(DataSnapshot snap) {
    phone = (snap.value as dynamic)["phone"];
    name = (snap.value as dynamic)["name"];
    id = snap.key;
    email = (snap.value as dynamic)["email"];
    status = (snap.value as dynamic)["Status"];
    ratings = (snap.value as dynamic)["ratings"];
    role = (snap.value as dynamic)["role"];
  }
}

class UserModel2 {
  String? vId;

  UserModel2({
    this.vId,
  });

  UserModel2.fromSnapshot(DataSnapshot snap) {
    vId = (snap.value as dynamic)["User id"];
  }
}

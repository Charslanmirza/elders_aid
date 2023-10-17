import 'package:flutter/cupertino.dart';

class MyTaskModel extends ChangeNotifier {
  final String nameModel;
  final String locationModel;
  final String timeModel;
  final String dateModel;
  final String driverIdModel;
  final String descriptionModel;
  final String fareModel;
  final String typeModel;

  MyTaskModel(
      {required this.nameModel,
      required this.locationModel,
      required this.timeModel,
      required this.dateModel,
      required this.driverIdModel,
      required this.descriptionModel,
      required this.fareModel,
      required this.typeModel});
}

class Mysta extends ChangeNotifier {
  final String nameModel;

  Mysta({
    required this.nameModel,
  });
}

class oldTaskModel extends ChangeNotifier {
  final String nameModel;
  final String locationModel;

  final String descriptionModel;
  oldTaskModel({
    required this.nameModel,
    required this.locationModel,
    required this.descriptionModel,
  });
}

class PastTaskModel extends ChangeNotifier {
  final String nameModel;
  final String locationModel;
  final String rating;
  final String descriptionModel;

  PastTaskModel(
      {required this.nameModel,
      required this.locationModel,
      required this.descriptionModel,
      required this.rating});
}

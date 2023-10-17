import 'dart:convert';
import 'package:elders_aid_project/widgets/my_task_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../widgets/constants.dart';
import '../widgets/rides_model.dart';

class RidesProvider with ChangeNotifier {
  List<RidesModel> RidesData = [];
  bool isNull = false;
  // double? DistanceTravelled;
  // double? RideDuration;
  Future<void> fetchData() async {
    final String userId = currentFirebaseUser!.uid;
    try {
      final response = await http.get(
        Uri.parse(
            'https://eldersaid-9d168-default-rtdb.firebaseio.com/tasks.json'),
      );
      print(response.statusCode);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<RidesModel> rides = [];
      extractedData.forEach((key, extractedData) {
        rides.add(RidesModel(
            nameModel: extractedData["Name"],
            timeModel: extractedData['Time'],
            dateModel: extractedData['Date'],
            driverIdModel: extractedData['Driver id'],
            descriptionModel: extractedData['Description'],
            fareModel: extractedData['Charges'],
            typeee: extractedData['Type'],
            rideId: key,
            locationModel: extractedData['Location']));
      });
      RidesData = rides;
    } catch (error) {
      isNull = true;
    }
  }
}

class OldHouseProvider with ChangeNotifier {
  List<OldHouseModel> RidesData = [];
  bool isNull = false;
  // double? DistanceTravelled;
  // double? RideDuration;
  Future<void> fetchData() async {
    final String userId = currentFirebaseUser!.uid;
    try {
      final response = await http.get(
        Uri.parse(
            'https://eldersaid-9d168-default-rtdb.firebaseio.com/oldhouse.json'),
      );
      print(response.statusCode);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OldHouseModel> rides = [];
      extractedData.forEach((key, extractedData) {
        rides.add(OldHouseModel(
            locationModel: extractedData["Location"],
            nameModel: extractedData["Name"],
            descriptionModel: extractedData['Description'],
            title: extractedData['Title']));
      });
      RidesData = rides;
    } catch (error) {
      isNull = true;
    }
  }
}

class MyTasksProvider with ChangeNotifier {
  List<MyTaskModel> MyTaskData = [];
  bool isNull = false;

  Future<void> fetchMyData() async {
    final String userId = currentFirebaseUser!.uid;
    try {
      final response = await http.get(
        Uri.parse(
            'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$userId/My rides.json'),
      );
      print(response.statusCode);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<MyTaskModel> rides = [];
      extractedData.forEach((key, extractedData) {
        rides.add(MyTaskModel(
            nameModel: extractedData["Name"],
            timeModel: extractedData['Time'],
            dateModel: extractedData['Date'],
            driverIdModel: extractedData['Driver id'],
            descriptionModel: extractedData['Description'],
            fareModel: extractedData['Charges'],
            typeModel: extractedData['Type'],
            locationModel: extractedData['Location']));
      });
      MyTaskData = rides;
    } catch (error) {
      isNull = true;
    }
  }
}

class Myonline with ChangeNotifier {
  List<Mysta> MyTaskData = [];
  bool isNull = false;

  Future<void> fetchMyData(String id) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$id/Available/.json.json'),
      );
      print(response.statusCode);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Mysta> rides = [];
      extractedData.forEach((key, extractedData) {
        rides.add(Mysta(
          nameModel: extractedData["available"],
        ));
      });
      MyTaskData = rides;
    } catch (error) {
      isNull = true;
    }
  }
}

class oldTasksProvider with ChangeNotifier {
  List<oldTaskModel> MyTaskData = [];
  bool isNull = false;

  Future<void> fetchMyData() async {
    final String userId = currentFirebaseUser!.uid;
    try {
      final response = await http.get(
        Uri.parse(
            'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$userId/My.json'),
      );
      print(response.statusCode);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<oldTaskModel> rides = [];
      extractedData.forEach((key, extractedData) {
        rides.add(oldTaskModel(
            nameModel: extractedData["Title"],
            descriptionModel: extractedData['Description'],
            locationModel: extractedData['Location']));
      });
      MyTaskData = rides;
    } catch (error) {
      isNull = true;
    }
  }
}

class PastTasksProvider with ChangeNotifier {
  List<PastTaskModel> MyTaskData = [];
  bool isNull = false;

  Future<void> fetchMyData() async {
    final String userId = currentFirebaseUser!.uid;
    try {
      final response = await http.get(
        Uri.parse(
            'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$userId/past task.json'),
      );
      print(response.statusCode);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<PastTaskModel> rides = [];
      extractedData.forEach((key, extractedData) {
        rides.add(PastTaskModel(
          nameModel: extractedData["name"],
          descriptionModel: extractedData['Description'],
          locationModel: extractedData['Location'],
          rating: extractedData['Rating'],
        ));
      });
      MyTaskData = rides;
    } catch (error) {
      isNull = true;
    }
  }
}

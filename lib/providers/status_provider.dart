import 'dart:convert';
import 'package:elders_aid_project/widgets/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class StatusModel extends ChangeNotifier {
  final String passengerName;
  final String status;
  final String userRole;
  final String phone;
  final String userEmail;

  StatusModel({
    required this.passengerName,
    required this.status,
    required this.userRole,
    required this.phone,
    required this.userEmail,
  });
}

class StatusProvider with ChangeNotifier {
  List<StatusModel> statusData = [];

  bool isNull = false;
  Future<void> fetchDataforStatus() async {
    try {
      String driverId = currentFirebaseUser!.uid;
      final response = await http.get(
        Uri.parse(
            'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/status.json'),
      );
      final extractedData = json.decode(response.body);
      final List<StatusModel> rides = [];
      extractedData.forEach((key, extractedData) {
        rides.add(StatusModel(
            passengerName: extractedData['Passenger name'],
            status: extractedData['Status'],
            phone: extractedData['Phone'],
            userEmail: extractedData['User email'],
            userRole: extractedData['User Role']));
      });
      statusData = rides;
      notifyListeners();
    } catch (error) {
      print(currentFirebaseUser!.uid);
      isNull = true;
    }
  }

  // endRide(String userId, int index) async {
  //   await http.delete(
  //     Uri.parse(
  //       'https://gowithme-4fd09-default-rtdb.firebaseio.com/User/$userId/contactUser.json',
  //     ),
  //   );
  //   await http.delete(
  //     Uri.parse(
  //       'https://gowithme-4fd09-default-rtdb.firebaseio.com/User/$userId/rideStarted.json',
  //     ),
  //   );
  //   await http.delete(
  //     Uri.parse(
  //       'https://gowithme-4fd09-default-rtdb.firebaseio.com/User/$userId/reachedLocation.json',
  //     ),
  //   );
  //   await http.delete(
  //     Uri.parse(
  //       'https://gowithme-4fd09-default-rtdb.firebaseio.com/User/$userId/tripdetails.json',
  //     ),
  //   );
  //   await http.delete(
  //     Uri.parse(
  //       'https://gowithme-4fd09-default-rtdb.firebaseio.com/User/$userId/paymentDetails.json',
  //     ),
  //   );
  // }

  // endallRides() async {
  //   String driverId = currentFirebaseUser!.uid;
  //   await http.delete(
  //     Uri.parse(
  //       'https://gowithme-4fd09-default-rtdb.firebaseio.com/Drivers/$driverId/cab share.json',
  //     ),
  //   );
  //   await http.delete(
  //     Uri.parse(
  //       'https://gowithme-4fd09-default-rtdb.firebaseio.com/Drivers/$driverId/rides history.json',
  //     ),
  //   );
  // }
}

class StatusModelElder extends ChangeNotifier {
  final String passengerName;
  final String description;
  final String userLocation;
  final String status;
  final String did;

  StatusModelElder(
      {required this.passengerName,
      required this.description,
      required this.status,
      required this.userLocation,
      required this.did});
}

class StatusProviderElder with ChangeNotifier {
  List<StatusModelElder> statusData = [];

  bool isNull = false;
  Future<void> fetchDataforStatusEelder() async {
    try {
      String driverId = currentFirebaseUser!.uid;
      final response = await http.get(
        Uri.parse(
            'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/status.json'),
      );
      final extractedData = json.decode(response.body);
      final List<StatusModelElder> rides = [];
      extractedData.forEach((key, extractedData) {
        rides.add(StatusModelElder(
          did: extractedData['User Id'],
          passengerName: extractedData['Passenger name'],
          description: extractedData['Description'],
          status: extractedData['Status'],
          userLocation: extractedData['User location'],
        ));
      });
      statusData = rides;
      notifyListeners();
    } catch (error) {
      isNull = true;
    }
  }

  // endRide(String userId, int index) async {
  //   await http.delete(
  //     Uri.parse(
  //       'https://gowithme-4fd09-default-rtdb.firebaseio.com/User/$userId/contactUser.json',
  //     ),
  //   );
  //   await http.delete(
  //     Uri.parse(
  //       'https://gowithme-4fd09-default-rtdb.firebaseio.com/User/$userId/rideStarted.json',
  //     ),
  //   );
  //   await http.delete(
  //     Uri.parse(
  //       'https://gowithme-4fd09-default-rtdb.firebaseio.com/User/$userId/reachedLocation.json',
  //     ),
  //   );
  //   await http.delete(
  //     Uri.parse(
  //       'https://gowithme-4fd09-default-rtdb.firebaseio.com/User/$userId/tripdetails.json',
  //     ),
  //   );
  //   await http.delete(
  //     Uri.parse(
  //       'https://gowithme-4fd09-default-rtdb.firebaseio.com/User/$userId/paymentDetails.json',
  //     ),
  //   );
  // }

  // endallRides() async {
  //   String driverId = currentFirebaseUser!.uid;
  //   await http.delete(
  //     Uri.parse(
  //       'https://gowithme-4fd09-default-rtdb.firebaseio.com/Drivers/$driverId/cab share.json',
  //     ),
  //   );
  //   await http.delete(
  //     Uri.parse(
  //       'https://gowithme-4fd09-default-rtdb.firebaseio.com/Drivers/$driverId/rides history.json',
  //     ),
  //   );
  // }
}

import 'dart:convert';
import 'package:elders_aid_project/widgets/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class BookingsModel extends ChangeNotifier {
  final String description;
  final String userId;
  final String passengerName;
  final String userLocation;
  String driverId = currentFirebaseUser!.uid;

  BookingsModel(
      {required this.description,
      required this.userId,
      required this.passengerName,
      required this.userLocation});
}

class BookingsProvider with ChangeNotifier {
  List<BookingsModel> BookingsData = [];

  bool isNull = false;
  Future<void> fetchDataforCabShare() async {
    try {
      String driverId = currentFirebaseUser!.uid;
      final response = await http.get(
        Uri.parse(
            'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/cab share.json'),
      );
      final extractedData = json.decode(response.body);
      final List<BookingsModel> rides = [];
      extractedData.forEach((key, extractedData) {
        rides.add(BookingsModel(
            description: extractedData['Description'],
            passengerName: extractedData['Passenger name'],
            userId: extractedData['User id'],
            userLocation: extractedData['User location']));
      });
      BookingsData = rides;
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

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'user_model.dart';

class NewTransaction extends StatefulWidget {
  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titlecontroller = TextEditingController();

  final desccontroller = TextEditingController();
  final locationcontroller = TextEditingController();
  DateTime? _selecteddate;

  void onSubmit() {
    final enteredtext = titlecontroller.text;
    final entereddesc = desccontroller.text;
    final enteredloc = locationcontroller.text;

    if (enteredtext.isEmpty || entereddesc.isEmpty || enteredloc.isEmpty) {
      return setState(() {});
    }
    shareRide();
    Fluttertoast.showToast(msg: "Added successfully");
    Navigator.of(context).pop();
    setState(() {});
  }

  Future<void> shareRide() async {
    String driverId = currentFirebaseUser!.uid;
    await http.post(
        Uri.parse(
          'https://eldersaid-9d168-default-rtdb.firebaseio.com/oldhouse.json',
        ),
        body: jsonEncode({
          "Name": userModelCurrentInfo!.name,
          'Driver id': driverId,
          'Title': titlecontroller.text,
          'Description': desccontroller.text,
          'Location': locationcontroller.text,
        }));
    await http.post(
        Uri.parse(
          'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/My.json',
        ),
        body: jsonEncode({
          "Name": userModelCurrentInfo!.name,
          'Driver id': driverId,
          'Title': titlecontroller.text,
          'Description': desccontroller.text,
          'Location': locationcontroller.text,
        }));

    // await http.post(
    //     Uri.parse(
    //       'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/rides history.json',
    //     ),
    //     body: jsonEncode({
    //       "Time": _time.text,
    //       "Date": _date.text,
    //     }));
    // await http.post(
    //     Uri.parse(
    //       'https://eldersaid-9d168-default-rtdb.firebaseio.com/User/$driverId/My rides.json',
    //     ),
    //     body: jsonEncode({
    //       "Name": userModelCurrentInfo!.name,
    //       'Driver id': driverId,
    //       'Charges': _charges.text,
    //       'Description': _description.text,
    //       'Date': _date.text,
    //       'Time': _time.text,
    //       'Location': _location.text,
    //       "Type": selectedCarType
    //     }));

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: 10,
              right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                onSubmitted: (value) => onSubmit(),
                controller: titlecontroller,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                onSubmitted: (value) => onSubmit(),
                keyboardType: TextInputType.text,
                controller: desccontroller,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                onSubmitted: (value) => onSubmit(),
                keyboardType: TextInputType.text,
                controller: locationcontroller,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              Platform.isIOS
                  ? CupertinoButton(
                      child: Text(
                        'Add ',
                        style: TextStyle(),
                      ),
                      color: Color(0xff3E4685),
                      onPressed: onSubmit,
                    )
                  : MaterialButton(
                      color: Color(0xff3E4685),
                      textColor: Colors.white,
                      onPressed: onSubmit,
                      child: Text(
                        'Add ',
                        style: TextStyle(),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}

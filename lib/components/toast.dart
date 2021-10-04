
import 'package:driverapp/components/fluttertoast.dart';
import 'package:flutter/material.dart';

displayMessage(String message, BuildContext context) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.pink[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }


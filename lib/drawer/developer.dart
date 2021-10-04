

import 'package:driverapp/AllScreens/mainscreen.dart';
import 'package:driverapp/constants/colors.dart';
import 'package:flutter/material.dart';

class Developer extends StatefulWidget {
    static const String idScreen = "developerScreen";
  Developer({Key key}) : super(key: key);

  @override
  _DeveloperState createState() => _DeveloperState();
}

class _DeveloperState extends State<Developer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Developer"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, MainScreen.idScreen, (route) => false);
              //
            }),
        centerTitle: true,
        backgroundColor: maron,
      ),
      body: Column(
        children: [
          //
        ],
      ),
    );
  }
}

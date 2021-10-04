
import 'package:driverapp/AllScreens/mainscreen.dart';
import 'package:driverapp/constants/colors.dart';
import 'package:flutter/material.dart';

class ShareApp extends StatefulWidget {
   static const String idScreen = "shareScreen";
  ShareApp({Key key}) : super(key: key);

  @override
  _ShareAppState createState() => _ShareAppState();
}

class _ShareAppState extends State<ShareApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Share"),
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


import 'package:driverapp/AllScreens/mainscreen.dart';
import 'package:driverapp/constants/colors.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
    static const String idScreen = "historyScreen";
  HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
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

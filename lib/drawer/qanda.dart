
import 'package:driverapp/AllScreens/mainscreen.dart';
import 'package:driverapp/constants/colors.dart';
import 'package:driverapp/constants/string.dart';
import 'package:flutter/material.dart';

class QestionAndAnswer extends StatefulWidget {
      static const String idScreen = "qAScreen";
  QestionAndAnswer({Key key}) : super(key: key);

  @override
  _QestionAndAnswerState createState() => _QestionAndAnswerState();
}

class _QestionAndAnswerState extends State<QestionAndAnswer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Basic Q&A"),
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
          Text("Frequently Asked Question"),
          Padding(padding: EdgeInsets.only(top: 10),child: qaone,),
          Padding(padding: EdgeInsets.only(top: 10),child: qatwo,),
          Padding(padding: EdgeInsets.only(top: 10),child: qathree,),
          Padding(padding: EdgeInsets.only(top: 10),child: qafour,),
          Padding(padding: EdgeInsets.only(top: 10),child: qafive,),
          Padding(padding: EdgeInsets.only(top: 10),child: qasix,),
          Padding(padding: EdgeInsets.only(top: 10),child: qaseven,),
          Padding(padding: EdgeInsets.only(top: 10),child: qaeight,),
          Padding(padding: EdgeInsets.only(top: 10),child: qanine,),
        ],
      ),
    );
  }
}

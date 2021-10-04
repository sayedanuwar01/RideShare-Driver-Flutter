
import 'package:driverapp/drawer/qanda.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AllScreens/carInfoScreen.dart';
import 'AllScreens/contact_us.dart';
import 'AllScreens/forget_pass.dart';
import 'AllScreens/loginScreen.dart';
import 'AllScreens/mainscreen.dart';
import 'AllScreens/newRideScreen.dart';
import 'AllScreens/registerationScreen.dart';
import 'AllScreens/upload_id.dart';
import 'DataHandler/appData.dart';
import 'configMaps.dart';
import 'drawer/developer.dart';
import 'drawer/history.dart';
import 'drawer/share.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  currentfirebaseUser = FirebaseAuth.instance.currentUser;

  runApp(MyApp());
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child("users");
DatabaseReference driversRef =
    FirebaseDatabase.instance.reference().child("drivers");
DatabaseReference newRequestsRef =
    FirebaseDatabase.instance.reference().child("Ride Requests");

DatabaseReference rideRequestRef = FirebaseDatabase.instance
    .reference()
    .child("drivers")
    .child(currentfirebaseUser.uid)
    .child("newRide");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(     
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? LoginScreen.idScreen
            : MainScreen.idScreen,
        routes: {
          RegistrationScreen.idScreen: (context) => RegistrationScreen(),
          UploadId.idScreen: (context) => UploadId(),
          
          LoginScreen.idScreen: (context) => LoginScreen(),
          ResetPass.idScreen: (context) => ResetPass(),

          MainScreen.idScreen: (context) => MainScreen(),
          CarInfoScreen.idScreen: (context) => CarInfoScreen(),

          ContactUS.idScreen: (context) => ContactUS(),
          //Drawer navigation

          Developer.idScreen: (context) => Developer(),
          HistoryScreen.idScreen: (context) => HistoryScreen(),
          QestionAndAnswer.idScreen: (context) => QestionAndAnswer(),
          ShareApp.idScreen: (context) => ShareApp(),

          NewRideScreen.newRideScreen: (context) => NewRideScreen(),
        },
      ),
    );
  }
}

import 'dart:async';
import 'package:driverapp/AllScreens/newRideScreen.dart';
import 'package:driverapp/assistants/assistantMethods.dart';
import 'package:driverapp/components/toast.dart';
import 'package:driverapp/constants/colors.dart';
import 'package:driverapp/models/drivers.dart';
import 'package:driverapp/notifications/pushNotificationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../configMaps.dart';
import '../main.dart';

class HomeTabPage extends StatefulWidget {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  PushNotificationService pushNotificationService = PushNotificationService();

  var geoLocator = Geolocator();

  String driverStatusText = "Go Online ";

  Color driverStatusColor = Colors.black;

  bool isDriverAvailable = false;

  @override
  void initState() {
    super.initState();

    getCurrentDriverInfo();
  }

  getRideType() {
    driversRef
        .child(currentfirebaseUser.uid)
        .child("car_details")
        .child("type")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        setState(() {
          rideType = snapshot.value.toString();
        });
      }
    });
  }

  getRatings() {
    //update ratings
    driversRef
        .child(currentfirebaseUser.uid)
        .child("ratings")
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        double ratings = double.parse(dataSnapshot.value.toString());
        setState(() {
          starCounter = ratings;
        });

        if (starCounter <= 1.5) {
          setState(() {
            title = "Very Bad";
          });
          return;
        }
        if (starCounter <= 2.5) {
          setState(() {
            title = "Bad";
          });

          return;
        }
        if (starCounter <= 3.5) {
          setState(() {
            title = "Good";
          });

          return;
        }
        if (starCounter <= 4.5) {
          setState(() {
            title = "Very Good";
          });
          return;
        }
        if (starCounter <= 5.0) {
          setState(() {
            title = "Excellent";
          });

          return;
        }
      }
    });
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void getCurrentDriverInfo() async {
    currentfirebaseUser = FirebaseAuth.instance.currentUser;

    driversRef
        .child(currentfirebaseUser.uid)
        .once()
        .then((DataSnapshot dataSnapShot) {
      if (dataSnapShot.value != null) {
        driversInformation = Drivers.fromSnapshot(dataSnapShot);
      }
    });

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();

    AssistantMethods.retrieveHistoryInfo(context);
    getRatings();
    getRideType();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //

        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: HomeTabPage._kGooglePlex,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              locatePosition();
            },
          ),
        ),

        //online offline driver Container
        Container(
          height: 100.0,
          width: double.infinity,
          color: maron,
        ),

        Positioned(
          top: 30.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (isDriverAvailable != true) {
                      makeDriverOnlineNow();
                      getLocationLiveUpdates();

                      setState(() {
                        driverStatusColor = Colors.pink[600];
                        driverStatusText = "Online Now ";
                        isDriverAvailable = true;
                      });

                      displayMessage("You are online now.", context);
                    } else {
                      makeDriverOfflineNow();

                      setState(() {
                        driverStatusColor = Colors.black;
                        driverStatusText = "Offline";
                        isDriverAvailable = false;
                      });

                      displayMessage("You are offline now.", context);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(17.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          driverStatusText,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.phone_android,
                          color: Colors.white,
                          size: 26.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        //
      ],
    );
  }

  void makeDriverOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);

    rideRequestRef.set("searching");
    rideRequestRef.onValue.listen((event) {
      var rideRequestId = event.snapshot.value;
      pushNotificationService.retrieveRideRequestInfo(rideRequestId, context);
    });
  }

  void getLocationLiveUpdates() {
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if (isDriverAvailable == true) {
        Geofire.setLocation(
            currentfirebaseUser.uid, position.latitude, position.longitude);
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void makeDriverOfflineNow() {
    Geofire.removeLocation(currentfirebaseUser.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    rideRequestRef = null;
  }
}

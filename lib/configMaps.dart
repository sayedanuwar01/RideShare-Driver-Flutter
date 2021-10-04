import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import 'models/allUsers.dart';
import 'models/drivers.dart';

String mapKey = "AIzaSyBUgk8Jt3yg7VDrJ3LN76Qg_LJIJKRaSDU";

User firebaseUser;

Users userCurrentInfo;

User currentfirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubscription;

StreamSubscription<Position> rideStreamSubscription;

final assetsAudioPlayer = AssetsAudioPlayer();

Position currentPosition;

Drivers driversInformation;

String title = "";
double starCounter = 0.0;

String rideType = "";

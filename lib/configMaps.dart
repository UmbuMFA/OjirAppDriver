import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver_app/Models/drivers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver_app/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';

String mapKey = "AIzaSyDSYLMonOTm99fFiilHVj54qXeQy9pL5D8";

late User firebaseUser;

late Users userCurrentInfo;

late User currentfirebaseUser;

late StreamSubscription<Position> homeTabPageStreamSubscription;

late StreamSubscription<Position> rideStreamSubscription;

final assetsAudioPlayer = AssetsAudioPlayer();

late Position currentPosition;

late Drivers driversInformation;

String title = "";
double starCounter = 0.0;

String rideType = "";

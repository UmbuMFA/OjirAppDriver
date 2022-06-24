import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver_app/Models/rideDetails.dart';
import 'package:driver_app/Notifications/notificationDialog.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;


  // Future initialize(context) async {
    // firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     retrieveRideRequestInfo(getRideRequestId(message), context);
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     retrieveRideRequestInfo(getRideRequestId(message), context);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     retrieveRideRequestInfo(getRideRequestId(message), context);
    //   },
    // );
  // }

  // getToken() async {
  //   Future<String?> token = firebaseMessaging.getToken();
  //   print("This is token :: ");
  //   print(token);
  //   driversRef.child(currentfirebaseUser.uid).child("token").set(token);
  //
  //   firebaseMessaging.subscribeToTopic("alldrivers");
  //   firebaseMessaging.subscribeToTopic("allusers");
  //
  //   return token;
  // }

  String getRideRequestId(Map<String, dynamic> message) {
    String rideRequestId = "";
    if (Platform.isAndroid) {
      rideRequestId = message['data']['ride_request_id'];
    } else {
      rideRequestId = message['ride_request_id'];
    }

    return rideRequestId;
  }

  void retrieveRideRequestInfo(String rideRequestId, BuildContext context) {
    newRequestsRef.child(rideRequestId).once().then((event) {
      if (event.snapshot.value != null) {
        assetsAudioPlayer.open(Audio("sounds/alert.mp3"));
        assetsAudioPlayer.play();

        double pickUpLocationLat = double.parse(
            event.snapshot.child("pickup").child("latitude").value.toString());
        double pickUpLocationLng = double.parse(
            event.snapshot.child("pickup").child("longitude").value.toString());
        String pickUpAddress =
            event.snapshot.child("pickup_address").value.toString();

        double dropOffLocationLat = double.parse(
            event.snapshot.child("dropoff").child("latitude").value.toString());
        double dropOffLocationLng = double.parse(event.snapshot
            .child("dropoff")
            .child("longitude")
            .value
            .toString());
        String dropOffAddress =
            event.snapshot.child("dropoff_address").value.toString();

        String paymentMethod =
            event.snapshot.child("payment_method").value.toString();

        String rider_name = event.snapshot.child("rider_name").value.toString();
        String rider_phone =
            event.snapshot.child("rider_phone").value.toString();

        RideDetails rideDetails = RideDetails();
        rideDetails.ride_request_id = rideRequestId;
        rideDetails.pickup_address = pickUpAddress;
        rideDetails.dropoff_address = dropOffAddress;
        rideDetails.pickup = LatLng(pickUpLocationLat, pickUpLocationLng);
        rideDetails.dropoff = LatLng(dropOffLocationLat, dropOffLocationLng);
        rideDetails.payment_method = paymentMethod;
        rideDetails.rider_name = rider_name;
        rideDetails.rider_phone = rider_phone;

        print("Information :: ");
        print(rideDetails.pickup_address);
        print(rideDetails.dropoff_address);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => NotificationDialog(
            rideDetails: rideDetails,
          ),
        );
      }
    });
  }
}

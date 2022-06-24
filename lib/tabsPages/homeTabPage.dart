import 'dart:async';
import 'package:driver_app/AllScreens/registerationScreen.dart';
import 'package:driver_app/Assistants/assistantMethods.dart';
import 'package:driver_app/Models/drivers.dart';
import 'package:driver_app/Notifications/pushNotificationService.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Assistants/geoFireAssistant.dart';
import '../Models/nearbyAvailableOrder.dart';

class HomeTabPage extends StatefulWidget {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-7.9467136, 112.6134797),
    zoom: 17,
  );

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;

  var geoLocator = Geolocator();

  String driverStatusText = "Offline Now - Go Online ";

  Color driverStatusColor = Colors.black;

  bool isDriverAvailable = false;

  @override
  void initState() {
    super.initState();

    FirebaseDatabase.instance.ref("help").onValue.map((event) => () {
          for (var sn in event.snapshot.children) {
            displayToastMessage("help", context);

            NearbyAvailableOrder newOrder = NearbyAvailableOrder();
            newOrder.id = sn.child("id").value.toString();
            newOrder.komposisi = sn.child("komposisi").value.toString();
            newOrder.user = sn.child("user").value.toString();
            newOrder.latitude = double.parse(sn.child("latitude").value.toString());
            newOrder.longitude = double.parse(sn.child("longitude").value.toString());
            GeoFireAssistant.nearByAvailableOrderList.add(newOrder);
          }
        });

    getCurrentDriverInfo();
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void getCurrentDriverInfo() async {
    currentfirebaseUser = (FirebaseAuth.instance.currentUser)!;

    driversRef.child(currentfirebaseUser.uid).once().then((event) {
      if (event.snapshot.value != null) {
        driversInformation = Drivers.fromSnapshot(event.snapshot);
        if (event.snapshot.child("newRide").value.toString() == "searching") {
          makeDriverOnlineNow();
          getLocationLiveUpdates();

          setState(() {
            driverStatusColor = Colors.green;
            driverStatusText = "Online Now ";
            isDriverAvailable = true;
          });

          displayToastMessage("you are Online Now.", context);
        }
      }
    });

    PushNotificationService pushNotificationService = PushNotificationService();

    // pushNotificationService.initialize(context);
    // pushNotificationService.getToken();

    AssistantMethods.retrieveHistoryInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
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

        //online offline driver Container
        Container(
          height: 140.0,
          width: double.infinity,
          color: Colors.black87,
        ),

        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  onPressed: () {
                    if (isDriverAvailable != true) {
                      makeDriverOnlineNow();
                      getLocationLiveUpdates();

                      setState(() {
                        driverStatusColor = Colors.green;
                        driverStatusText = "Online Now ";
                        isDriverAvailable = true;
                      });

                      displayToastMessage("you are Online Now.", context);
                    } else {
                      makeDriverOfflineNow();

                      setState(() {
                        driverStatusColor = Colors.black;
                        driverStatusText = "Offline Now - Go Online ";
                        isDriverAvailable = false;
                      });

                      displayToastMessage("you are Offline Now.", context);
                    }
                  },
                  color: driverStatusColor,
                  child: Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          driverStatusText,
                          style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const Icon(
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
      ],
    );
  }

  BitmapDescriptor? nearByIcon = null;
  Set<Marker> markersSet = {};

  void updateAvailableDriversOnMap() {
    setState(() {
      markersSet.clear();
    });

    Set<Marker> tMakers = Set<Marker>();
    for (NearbyAvailableOrder driver
        in GeoFireAssistant.nearByAvailableOrderList) {
      LatLng driverAvaiablePosition =
          LatLng(driver.latitude!, driver.longitude!);

      Marker marker = Marker(
        markerId: MarkerId('driver${driver.id}'),
        position: driverAvaiablePosition,
        icon: nearByIcon!,
      );

      tMakers.add(marker);
    }
    setState(() {
      markersSet = tMakers;
    });
  }

  void createIconMarker() {
    if (nearByIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car_ios.png")
          .then((value) {
        nearByIcon = value;
      });
    }
  }

  void makeDriverOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);

    rideRequestRef.set("searching");
    rideRequestRef.onValue.listen((event) {});
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
  }
}

import 'package:driver_app/AllScreens/carInfoScreen.dart';
import 'package:driver_app/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver_app/AllScreens/loginScreen.dart';
import 'package:driver_app/AllScreens/mainscreen.dart';
import 'package:driver_app/AllScreens/registerationScreen.dart';
import 'package:driver_app/DataHandler/appData.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

DatabaseReference bankSampahRef = FirebaseDatabase.instance.ref("bank_sampahs");
DatabaseReference usersRef = FirebaseDatabase.instance.ref("users");
DatabaseReference driversRef = FirebaseDatabase.instance.ref("drivers");
DatabaseReference helpRef = FirebaseDatabase.instance.ref("help");
DatabaseReference newRequestsRef =
    FirebaseDatabase.instance.ref("Ride Requests");
DatabaseReference rideRequestRef = FirebaseDatabase.instance
    .ref("drivers")
    .child(currentfirebaseUser.uid)
    .child("newRide");

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 2,
        navigateAfterSeconds: AfterSplash(),
        image: Image.asset('images/logo.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: const TextStyle(),
        photoSize: 100.0,
        onClick: () => print("Flutter Egypt"),
        loaderColor: Colors.green);
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Gojek Sampah Driver',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? LoginScreen.idScreen
            : MainScreen.idScreen,
        routes: {
          RegisterationScreen.idScreen: (context) => RegisterationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
          CarInfoScreen.idScreen: (context) => CarInfoScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

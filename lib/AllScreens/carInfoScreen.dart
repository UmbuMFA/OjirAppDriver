import 'package:driver_app/AllScreens/mainscreen.dart';
import 'package:driver_app/AllScreens/registerationScreen.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CarInfoScreen extends StatefulWidget {
  static const String idScreen = "carinfo";

  @override
  _CarInfoScreenState createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModelTextEditingController = TextEditingController();

  TextEditingController carNumberTextEditingController =
      TextEditingController();

  TextEditingController carColorTextEditingController = TextEditingController();

  List<String> carTypesList = ["uber-x", "uber-go", "bike"];

  String? selectedCarType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 100.0,
              ),
              Image.asset(
                "images/logo.png",
                width: 100.0,
                height: 100.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 12.0,
                    ),
                    const Text(
                      "Enter Car Details",
                      style:
                          TextStyle(fontFamily: "Brand Bold", fontSize: 24.0),
                    ),
                    const SizedBox(
                      height: 26.0,
                    ),
                    TextField(
                      controller: carModelTextEditingController,
                      decoration: const InputDecoration(
                        labelText: "Car Model",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: carNumberTextEditingController,
                      decoration: const InputDecoration(
                        labelText: "Car Number",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: carColorTextEditingController,
                      decoration: const InputDecoration(
                        labelText: "Car Color",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    DropdownButton(
                      iconSize: 40,
                      hint: const Text('Please choose Car Type'),
                      value: selectedCarType,
                      onChanged: (newValue) {
                        setState(() {
                          selectedCarType = newValue.toString();
                          // displayToastMessage(selectedCarType!, context);
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: "uber-x",
                          child: Text("uber-x"),
                        ),
                        DropdownMenuItem(
                          value: "uber-go",
                          child: Text("uber-go"),
                        ),
                        DropdownMenuItem(
                          value: "bike",
                          child: Text("bike"),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            elevation: 0,
                            primary: const Color(0xFF1bac4b)),
                        onPressed: () {
                          if (carModelTextEditingController.text.isEmpty) {
                            displayToastMessage(
                                "please write Car Model.", context);
                          } else if (carNumberTextEditingController
                              .text.isEmpty) {
                            displayToastMessage(
                                "please write Car Number.", context);
                          } else if (carColorTextEditingController
                              .text.isEmpty) {
                            displayToastMessage(
                                "please write Car Color.", context);
                          } else if (selectedCarType == null) {
                            displayToastMessage(
                                "please choose Car Type.", context);
                          } else {
                            saveDriverCarInfo(context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "NEXT",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Color(0xFF050707)),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Color(0xFF050707),
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
          ),
        ),
      ),
    );
  }

  void saveDriverCarInfo(context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    Map carInfoMap = {
      "car_color": carColorTextEditingController.text,
      "car_number": carNumberTextEditingController.text,
      "car_model": carModelTextEditingController.text,
      "type": selectedCarType,
    };

    driversRef.child(userId!).child("car_details").set(carInfoMap);

    Navigator.pushNamedAndRemoveUntil(
        context, MainScreen.idScreen, (route) => false);
  }
}

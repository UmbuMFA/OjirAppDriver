import 'dart:io' as io;

import 'package:driver_app/AllScreens/mainscreen.dart';
import 'package:driver_app/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:driver_app/AllScreens/loginScreen.dart';
import 'package:driver_app/AllWidgets/progressDialog.dart';
import 'package:driver_app/main.dart';
import 'package:image_picker/image_picker.dart';

class RegisterationScreen extends StatefulWidget {
  static const String idScreen = "register";

  const RegisterationScreen({Key? key}) : super(key: key);

  @override
  _RegisterationScreenState createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  bool _isObscure = true;
  XFile? file;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String photoText = "Upload Photo";
  String chosenBankSampah = '';

  List<DropdownMenuItem<String>> dropdowns = [];

  void getBankSampah() async {
    bankSampahRef.onValue.listen((event) {
      for (DataSnapshot snapshot in event.snapshot.children) {
        dropdowns.add(DropdownMenuItem<String>(
          value: snapshot.child("id").value.toString(),
          child: Text(snapshot.child("pemilik").value.toString()),
        ));
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    getBankSampah();
    dropdowns.add(const DropdownMenuItem<String>(
      value: "",
      child: Text("Pilih Bank Sampah"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 100.0,
              ),
              const Image(
                image: AssetImage("images/logo.png"),
                width: 100.0,
                height: 100.0,
                alignment: Alignment.center,
              ),
              const SizedBox(
                height: 50.0,
              ),
              const Text(
                "Register as a Driver",
                style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: "Brand Bold",
                    color: Color(0xFF050707)),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() async {
                            file = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (file != null) {
                              setState(() {
                                photoText = "Photo OK";
                              });
                            } else {
                              setState(() {
                                photoText = "Upload Photo";
                              });
                            }
                          });
                        },
                        child: Text(photoText)),
                    const SizedBox(
                      height: 1.0,
                    ),
                    DropdownButton<String>(
                      value: chosenBankSampah,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          chosenBankSampah = newValue!;
                        });
                      },
                      items: dropdowns.toList(),
                    ),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Phone",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                              icon: Icon(_isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          elevation: 0,
                          primary: const Color(0xFF1bac4b)),
                      child: const SizedBox(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (nameTextEditingController.text.length < 3) {
                          displayToastMessage(
                              "name must be atleast 3 Characters.", context);
                        } else if (!emailTextEditingController.text
                            .contains("@")) {
                          displayToastMessage(
                              "Email address is not Valid.", context);
                        } else if (phoneTextEditingController.text.isEmpty) {
                          displayToastMessage(
                              "Phone Number is mandatory.", context);
                        } else if (passwordTextEditingController.text.length <
                            6) {
                          displayToastMessage(
                              "Password must be atleast 6 Characters.",
                              context);
                        } else if (chosenBankSampah.isEmpty) {
                          displayToastMessage(
                              "Bank Sampah is mandatory", context);
                        } else if (file == null) {
                          displayToastMessage("Please upload photo", context);
                        } else {
                          registerNewUser(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: const Text(
                  "Already have an Account? Login Here",
                  style: TextStyle(color: Color(0xFF050707)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Registering, Please wait...",
          );
        });

    final User? firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: $errMsg", context);
    }))
        .user;

    if (firebaseUser != null) //user created
    {
      //save user info to database
      String? photo = await uploadFile(file, firebaseUser.uid);
      setState(() {
        Map userDataMap = {
          "name": nameTextEditingController.text.trim(),
          "email": emailTextEditingController.text.trim(),
          "phone": phoneTextEditingController.text.trim(),
          "photo": photo,
          "bank_sampah": chosenBankSampah,
        };

        driversRef.child(firebaseUser.uid).set(userDataMap);

        currentfirebaseUser = firebaseUser;

        displayToastMessage(
            "Congratulations, your account has been created.", context);

        Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.idScreen, (route) => false);
      });
    } else {
      Navigator.pop(context);
      //error occured - display error msg
      displayToastMessage("New user account has not been Created.", context);
    }
  }

  Future<String?> uploadFile(XFile? file, String uid) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );

      return null;
    }

    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref =
        FirebaseStorage.instance.ref().child('photo').child('/$uid.jpg');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    uploadTask = ref.putFile(io.File(file.path), metadata);

    String dowurl = await (await uploadTask).ref.getDownloadURL();

    return dowurl;
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}

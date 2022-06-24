import 'package:driver_app/AllScreens/mainscreen.dart';
import 'package:driver_app/AllScreens/registerationScreen.dart';
import 'package:driver_app/AllWidgets/progressDialog.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String idScreen = "login";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool _isObscure = true;
  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();

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
                "Login as a Driver",
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
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      focusNode: emailFocus,
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      onTap: () {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                            fontSize: 14.0,
                            color: emailFocus.hasFocus
                                ? const Color(0xFF1bac4b)
                                : const Color(0xFF050707)),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF050707)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF1bac4b)),
                        ),
                      ),
                      style: const TextStyle(
                          fontSize: 18.0, color: Color(0xFF050707)),
                    ),
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      focusNode: passFocus,
                      controller: passwordTextEditingController,
                      obscureText: _isObscure,
                      onTap: () {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                              fontSize: 14.0,
                              color: passFocus.hasFocus
                                  ? const Color(0xFF1bac4b)
                                  : const Color(0xFF050707)),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF050707)),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF1bac4b)),
                          ),
                          suffixIcon: IconButton(
                              color: passFocus.hasFocus
                                  ? const Color(0xFF1bac4b)
                                  : const Color(0xFF050707),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                              icon: Icon(_isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                      style: const TextStyle(
                          fontSize: 18.0, color: Color(0xFF050707)),
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
                      onPressed: () {
                        if (!emailTextEditingController.text.contains("@")) {
                          displayToastMessage(
                              "Email address is not Valid.", context);
                        } else if (passwordTextEditingController.text.isEmpty) {
                          displayToastMessage(
                              "Password is mandatory.", context);
                        } else {
                          loginAndAuthenticateUser(context);
                        }
                      },
                      child: const SizedBox(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RegisterationScreen.idScreen, (route) => false);
                },
                child: const Text(
                  "Do not have an Account? Register Here",
                  style: TextStyle(color: Color(0xFF050707)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Authenticating, Please wait...",
          );
        });

    final User? firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: $errMsg", context);
    }))
        .user;

    if (firebaseUser != null) {
      driversRef.child(firebaseUser.uid).once().then((event) {
        if (event.snapshot.value != null) {
          currentfirebaseUser = firebaseUser;
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMessage("you are logged-in now.", context);
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage(
              "No record exists for this user. Please create new account.",
              context);
        }
      });
    } else {
      Navigator.pop(context);
      displayToastMessage("Error Occured, can not be Signed-in.", context);
    }
  }
}

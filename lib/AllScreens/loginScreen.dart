import 'package:driverapp/AllScreens/contact_us.dart';
import 'package:driverapp/AllScreens/mainscreen.dart';
import 'package:driverapp/AllScreens/registerationScreen.dart';
import 'package:driverapp/components/progressDialog.dart';
import 'package:driverapp/components/toast.dart';
import 'package:driverapp/configMaps.dart';
import 'package:driverapp/constants/colors.dart';
import 'package:driverapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'forget_pass.dart';

class LoginScreen extends StatefulWidget {
  static const String idScreen = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _hidePass = true;

  final _emailController = TextEditingController(text: "adnan@graduate.utm.my");
  final _passwordController = TextEditingController(text: "123456");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 35.0),
              Image(
                image: AssetImage("assets/images/driver.png"),
                width: 320.0,
                height: 150.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0),
              Text(
                "Login as a Driver",
                style: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 1.0),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.pink[900],
                        ),
                      ),
                      validator: (val) {
                        if (val.isEmpty) return "email can't be empty";

                        /* if (!val.contains('.utm.my'))
                        return 'Please provide a valid email.'; */

                        return null;
                      },
                      onChanged: (String value) {
                        print('inputted email address ===> $value');
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      obscureText: _hidePass,
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        /*  enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.pink[900], width: 0.0),
                      ), */
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.pink[900],
                        ),
                        suffixIcon: IconButton(
                          color: Theme.of(context).accentColor.withOpacity(0.4),
                          icon: Icon(
                            _hidePass ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _hidePass = !_hidePass;
                            });
                          },
                        ),
                      ),
                      validator: (val) =>
                          val.isEmpty ? "password can't be empty" : null,
                      onChanged: (String value) {
                        print('inputted password ===> $value');
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Forgot password',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              ResetPass.idScreen,
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Colors.pink[300];
                          return maron;
                        }),
                      ),
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (!_emailController.text.contains(".utm.my")) {
                          displayMessage(
                              "Email address is not Valid.", context);
                        } else if (_passwordController.text.isEmpty) {
                          displayMessage("Password is mandatory.", context);
                        } else {
                          loginAndAuthenticateUser(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have any account ? "),
                  GestureDetector(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: "Register now",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context,
                          RegistrationScreen.idScreen, (route) => false);
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Having trouble to login ? "),
                  GestureDetector(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: "Contact us",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, ContactUS.idScreen, (route) => false);
                    },
                  ),
                ],
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

    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayMessage("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      driversRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          currentfirebaseUser = firebaseUser;
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayMessage("you are logged-in now.", context);
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayMessage(
              "No record exists for this user. Please create new account.",
              context);
        }
      });
    } else {
      Navigator.pop(context);
      displayMessage("Error Occured, can not be Signed-in.", context);
    }
  }
}

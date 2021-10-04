
import 'package:driverapp/components/toast.dart';
import 'package:driverapp/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'loginScreen.dart';


class ResetPass extends StatefulWidget {
  static const String idScreen = "resetPass";

  ResetPass({Key key}) : super(key: key);

  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final _registerEmailController = TextEditingController();
  User firebaseUser;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void dispose() {
    _registerEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rest Password"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.idScreen, (route) => false);
              //
            }),
        centerTitle: true,
        backgroundColor: maron,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your registered email',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _registerEmailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                prefixIcon: Icon(
                  Icons.mail,
                  color: maron,
                ),
                // errorStyle: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.pink[300];
                  return maron;
                }),
              ),
              child: Text('Send a reset request'),
              onPressed: () {
                print("reset button ");
                setState(() {
                  _firebaseAuth
                      .sendPasswordResetEmail(
                          email: _registerEmailController.text)
                      .whenComplete(() {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.idScreen, (route) => false);
                    displayMessage(
                        "A password reset link send to your email ", context);
                  }).onError((error, stackTrace) =>
                          displayMessage("Something wrong $error ", context));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

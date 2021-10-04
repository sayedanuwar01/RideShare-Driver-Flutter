import 'package:driverapp/AllScreens/carInfoScreen.dart';
import 'package:driverapp/AllScreens/loginScreen.dart';
import 'package:driverapp/components/progressDialog.dart';
import 'package:driverapp/components/toast.dart';
import 'package:driverapp/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:driverapp/main.dart';

class RegistrationScreen extends StatefulWidget {
  static const String idScreen = "register";
  RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _hidePass = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneContoller = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneContoller.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/driver.png",
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (val) =>
                        val.isEmpty ? "Name can't be empty.." : null,
                    onChanged: (String value) {
                      print('inputted password ===> $value');
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (val) {
                      if (val.isEmpty) return "Email can't be empty";

                      if (!val.contains('.utm.my'))
                        return 'Please provide a valid email.';

                      return null;
                    },
                    onChanged: (String value) {
                      print('inputted email address ===> $value');
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneContoller,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (val) => val.isEmpty ? "Phone" : null,
                    onChanged: (String value) {
                      print('inputted phone number ===> $value');
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    obscureText: _hidePass,
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
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
                    validator: (val) {
                      if (val.isEmpty) return "Password can't be empty";
                      if (val.length < 4) return "Your password is too short..";
                      return null;
                    },
                    onChanged: (String value) {
                      print('inputted password ===> $value');
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    obscureText: _hidePass,
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Confirm Password",
                      prefixIcon: Icon(Icons.lock),
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
                    validator: (val) {
                      if (val.isEmpty) return "Confirm password can't be empty";

                      if (val != _passwordController.text) return "Not Match";
                      return null;
                    },
                    onChanged: (String value) {
                      print("inputted password ===> $value");
                    },
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        child: Text('Registration'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.pink[300];
                            return Colors.pink[900];
                          }),
                        ),
                        onPressed: () {
                          setState(() {
                            _registerDriverNow(context);
                            
                          });
                        }),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                      child: RichText(
                        text: TextSpan(
                          text: "Already have an account ? ",
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Login now",
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
                          LoginScreen.idScreen,
                          (route) => false,
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  _registerDriverNow(BuildContext context) async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ProgressDialog(
              message: "Registering, Please wait...",
            );
          });

      final User firebaseUser = (await _firebaseAuth
              .createUserWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text)
              .catchError((errMsg) {
        Navigator.pop(context);
        displayMessage("Error: " + errMsg.toString(), context);
      }))
          .user;

      if (firebaseUser != null) //user created
      {
        //save user info to database
        Map userDataMap = {
          "name": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "phone": _phoneContoller.text.trim()
        };

        driversRef.child(firebaseUser.uid).set(userDataMap).whenComplete(() {
          setState(() {
            currentfirebaseUser = firebaseUser;
          });
          //Navigator.pushNamed(context, UploadId.idScreen);
          Navigator.pushNamedAndRemoveUntil(
              context, CarInfoScreen.idScreen, (route) => false);

          displayMessage(
              "Congratulations, your account has been created.", context);
        });

        // Navigator.pushNamed(context, CarInfoScreen.idScreen);
      } else {
        Navigator.pop(context);
        //error occured - display error msg
        displayMessage("New user account has not been Created.", context);
      }
    }
  }
}

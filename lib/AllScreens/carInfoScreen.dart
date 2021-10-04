import 'package:driverapp/components/toast.dart';
import 'package:driverapp/constants/colors.dart';
import 'package:flutter/material.dart';

import '../configMaps.dart';
import '../main.dart';
import 'mainscreen.dart';
import 'upload_id.dart';

class CarInfoScreen extends StatefulWidget {
  static const String idScreen = "carinfo";

  @override
  _CarInfoScreenState createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  final carModelTextEditingController = TextEditingController();
  final carNumberTextEditingController = TextEditingController();
  final carColorTextEditingController = TextEditingController();

  // List<String> carTypesList = ['uber-x', 'uber-go', 'bike'];
  List<String> carTypesList = ['car', 'bike'];

  String selectedCarType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Car Info"),
        centerTitle: true,
        backgroundColor: maron,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 22.0),
              Image.asset(
                "assets/images/driver.png",
                width: 150.0,
                height: 100.0,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                child: Column(
                  children: [
                    SizedBox(height: 12.0),
                    Text(
                      "Enter Transport Details",
                      style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 24.0,
                      ),
                    ),
                    SizedBox(height: 26.0),
                    TextField(
                      controller: carModelTextEditingController,
                      decoration: InputDecoration(
                        labelText: "Transport Model",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 15.0),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: carNumberTextEditingController,
                      decoration: InputDecoration(
                        labelText: "Transport Number",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 15.0),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: carColorTextEditingController,
                      decoration: InputDecoration(
                        labelText: "Transport Color",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 15.0),
                    ),
                    SizedBox(height: 26.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DropdownButton(
                          iconSize: 40,
                          hint: Text('Please choose Transport Type'),
                          value: selectedCarType,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCarType = newValue;
                              displayMessage(selectedCarType, context);
                            });
                          },
                          items: carTypesList.map((car) {
                            return DropdownMenuItem(
                              child: new Text(car),
                              value: car,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 42.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (carModelTextEditingController.text.isEmpty) {
                            displayMessage("please write Car Model.", context);
                          } else if (carNumberTextEditingController
                              .text.isEmpty) {
                            displayMessage("please write Car Number.", context);
                          } else if (carColorTextEditingController
                              .text.isEmpty) {
                            displayMessage("please write Car Color.", context);
                          } else if (selectedCarType == null) {
                            displayMessage("please choose Car Type.", context);
                          } else {
                            saveDriverCarInfo(context);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "NEXT",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Icon(
                                Icons.arrow_forward,
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
          ),
        ),
      ),
    );
  }

  void saveDriverCarInfo(context) {
    String userId = currentfirebaseUser.uid;

    Map carInfoMap = {
      "car_color": carColorTextEditingController.text,
      "car_number": carNumberTextEditingController.text,
      "car_model": carModelTextEditingController.text,
      "type": selectedCarType,
    };

    driversRef.child(userId).child("car_details").set(carInfoMap);

    Navigator.pushNamedAndRemoveUntil(
      context,
      UploadId.idScreen,
      (route) => false,
    );
  }
}

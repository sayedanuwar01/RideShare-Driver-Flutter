import 'package:driverapp/components/toast.dart';
import 'package:driverapp/constants/colors.dart';

import 'package:flutter/material.dart';

import 'loginScreen.dart';


class ContactUS extends StatefulWidget {
  static const String idScreen = "contactUs";
  ContactUS({Key key}) : super(key: key);

  @override
  _ContactUSState createState() => _ContactUSState();
}

class _ContactUSState extends State<ContactUS> {
  final _mattarsController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _mattarsController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
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
            TextField(
              controller: _mattarsController,
              decoration: InputDecoration(
                  labelText: "Matter", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Describe more",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                child: Text('Send Us Feedback'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.pink[300];
                    return maron;
                  }),
                ),
                onPressed: () {
                  if (_mattarsController.text.isEmpty &&
                      _descriptionController.text.isEmpty) {
                    displayMessage(
                        'Need to fill all information', context);
                  } else {
                    _feedbackForm();
                  }
                },
              ),
            ),
            //
          ],
        ),
      ),
    );
  }

  _feedbackForm() {}
}

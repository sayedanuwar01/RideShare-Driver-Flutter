
import 'package:driverapp/AllScreens/mainscreen.dart';
import 'package:driverapp/DataHandler/appData.dart';
import 'package:driverapp/components/progressDialog.dart';
import 'package:driverapp/components/toast.dart';
import 'package:driverapp/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserFeedback extends StatefulWidget {
  static const String idScreen = "feedback";
  UserFeedback({Key key}) : super(key: key);

  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<UserFeedback> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
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
                  context, MainScreen.idScreen, (route) => false);
              //
            }),
        centerTitle: true,
        backgroundColor: maron,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: "Name", border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                    labelText: "Phone", border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Your feedback",
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
                    if (_nameController.text.isEmpty &&
                        _messageController.text.isEmpty &&
                        _phoneController.text.isEmpty) {
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
      ),
    );
  }

  _feedbackForm() async {
    showDialog(
      context: context,
      //
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ProgressDialog(
          message: "Submitting. Please wait ...",
        );
      },
    );
    AppData _contactUs = Provider.of<AppData>(context, listen: false);

    await _contactUs.feedbackForm(
      name: _nameController.text,
      phone: _phoneController.text,
      message: _messageController.text,
      context: context,
    );

    setState(() {
      _nameController.text = "";
      _phoneController.text = "";
      _messageController.text = "";
    });
  }
}

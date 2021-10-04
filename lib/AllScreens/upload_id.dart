import 'dart:io';

import 'package:driverapp/components/toast.dart';
import 'package:driverapp/constants/colors.dart';
import 'package:driverapp/models/drivers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../configMaps.dart';
import '../main.dart';
import 'mainscreen.dart';

class UploadId extends StatefulWidget {
  static const String idScreen = "uploadID";

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<UploadId> {
  UploadTask task;
  File file;

  @override
  void initState() {
    super.initState();
    getCurrentDriverInfo();

    // getCurrentOnlineDriverInfo
    //AssistantMethods.getCurrentOnlineDriverInfo();
  }

  getCurrentDriverInfo() {
    currentfirebaseUser = FirebaseAuth.instance.currentUser;

    driversRef
        .child(currentfirebaseUser.uid)
        .once()
        .then((DataSnapshot dataSnapShot) {
      if (dataSnapShot.value != null) {
        driversInformation = Drivers.fromSnapshot(dataSnapShot);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? (file.path).toString() : 'No File Selected';

    return Scaffold(
      appBar: AppBar(
        title: Text("Upload ID"),
        centerTitle: true,
        backgroundColor: maron,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: 'Select File',
                icon: Icons.attach_file,
                onClicked: selectFile,
              ),
              SizedBox(height: 8),
              Text(
                fileName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 48),
              ButtonWidget(
                text: 'Upload File',
                icon: Icons.cloud_upload_outlined,
                onClicked: uploadFile,
              ),
              SizedBox(height: 20),
              task != null ? buildUploadStatus(task) : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final userId = driversInformation.id;
    print("upload id===>>> $userId");

    final ref = FirebaseStorage.instance
        .ref(userId)
        .child("DriverIdentity_" + driversInformation.name);

    setState(() {
      task = ref.putFile(file);
    });

    if (task == null) return;

    final snapshot = await task.whenComplete(() {
      setState(() {
        displayMessage("Successfully uploaded", context);
        //Navigator.pushNamed(context, UploadId.idScreen);
         Navigator.pushNamedAndRemoveUntil(
      context,
      MainScreen.idScreen,
      (route) => false,
    );
      });
    });
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}

//
class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key key,
    this.icon,
    this.text,
    this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: maron,
          minimumSize: Size.fromHeight(50),
        ),
        child: buildContent(),
        onPressed: onClicked,
      );

  Widget buildContent() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28),
          SizedBox(width: 16),
          Text(
            text,
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
        ],
      );
}

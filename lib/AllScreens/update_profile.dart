import 'dart:io';

import 'package:driverapp/components/progressDialog.dart';
import 'package:driverapp/components/toast.dart';
import 'package:driverapp/constants/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../../main.dart';
import '../configMaps.dart';

class Updateprofile extends StatefulWidget {
  static const String idScreen = "updateProfile";
  Updateprofile({Key key}) : super(key: key);

  @override
  _UpdateprofileState createState() => _UpdateprofileState();
}

class _UpdateprofileState extends State<Updateprofile> {
//
  File _imageFile;
  String _imageUrl;

  final picker = ImagePicker();

  Future getImage() async {
    print("image is uploading ...");
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        //_image = File(pickedFile.path);
      }
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
   // AppData _authSate = Provider.of<AppData>(context, listen: false);
    File fileName = File(_imageFile.path);

    FirebaseStorage firebaseStorageRef = FirebaseStorage.instance;
    Reference ref = firebaseStorageRef
        .ref(userCurrentInfo.id)
        .child("profile_" + userCurrentInfo.name);

    UploadTask uploadTask = ref.putFile(fileName);
    uploadTask.then((res) {
      final imageUrl = res.ref.getDownloadURL();

      print("image url ===>>> $imageUrl".toString());
      //_authSate.getPhotoUrl(imageUrl.toString());
    });
    uploadTask.whenComplete(
        () => displayMessage("Successfully updated", context));
    uploadTask.onError(
      (error, stackTrace) =>displayMessage(
          "Something went wrong with + $error", context),
    );
  }

  //

  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPhoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    _userPhoneController.dispose();
  }

  @override
  void initState() {
    _userNameController.text = userCurrentInfo.name;
    _userEmailController.text = userCurrentInfo.email;
    _userPhoneController.text = userCurrentInfo.phone;

    initialImageUrl();
    super.initState();
  }

  initialImageUrl() async {
    final ref = FirebaseStorage.instance
        .ref(userCurrentInfo.id)
        .child("profile_" + userCurrentInfo.name);
// no need of the file extension, the name will do fine.
    var url = await ref.getDownloadURL();
    print(url);
    _imageFile = File(url);
  }

  @override
  Widget build(BuildContext context) {
   // AppData _authSate = Provider.of<AppData>(context, listen: false);

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              /* Navigator.pushNamedAndRemoveUntil(
                  context, UserProfile.idScreen, (route) => false); */
              //
            }),
        centerTitle: true,
        backgroundColor: maron,
        backwardsCompatibility: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  width: size.width,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0),
                    ),
                  ),
                  child: Center(
                    child: _imageFile != null
                        ? Image.file(_imageFile)
                        : Image.asset(
                            "assets/images/user_icon.png",
                            height: 200,
                            width: 150,
                          ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    getImage();
                  });
                },
              ),
              Container(
                width: size.width,
                padding: EdgeInsets.only(left: 20, right: 20),
                // height: 150,
                // color: maron,
                child: Column(
                  children: [
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
                      onPressed: () {
                        //
                        if (_imageFile == null) {
                          displayMessage(
                              "Choose a photo first", context);
                        } else {
                          //
                          setState(() {
                            uploadImageToFirebase(context);
                          });
                        }
                      },
                      child: Text("Upload now"),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _userNameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      enabled: false,
                      readOnly: true ??
                          displayMessage(
                              "To change the email contact with admin",
                              context),
                      onTap: () {
                        setState(() {
                          displayMessage(
                              "To change the email contact with admin",
                              context);
                        });
                      },
                      controller: _userEmailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _userPhoneController,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        child: Text('Update Now'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.pink[300];
                            return maron;
                          }),
                        ),
                        onPressed: () {
                          _updateProfile(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              //
            ],
          ),

          //
        ),
      ),
    );
  }

  // update user profile image

  // update user details

  _updateProfile(BuildContext context) async {
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        Navigator.pop(context);
      });
    });
    showDialog(
      context: context,
      //
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ProgressDialog(
          message: "updating. Please wait ...",
        );
      },
    );
    //

    var _name, _email, _phone;
    _name = _userNameController.text.trim();
    _email = _userEmailController.text.trim();
    _phone = _userPhoneController.text.trim();

    Map<String, dynamic> updateUserDataMap = {
      "email": _email,
      "name": _name,
      "phone": _phone,
    };

    usersRef
        .child(userCurrentInfo.id)
        .update(updateUserDataMap)
        .whenComplete(() {
      displayMessage("Updated successfully", context);
     /*  Navigator.pushNamedAndRemoveUntil(
          context, UserProfile.idScreen, (route) => false); */
    }).onError(
      (error, stackTrace) =>
          displayMessage("Something went wrongd", context),
    );
  }
}

import 'package:firebase_database/firebase_database.dart';

class Drivers {
   String id;
  String name;
  String phone;
  String email;
 
  String carColor;
  String carModel;
  String carNumber;

  Drivers({
    this.id,
    this.name,
    this.phone,
    this.email,
    
    this.carColor,
    this.carModel,
    this.carNumber,
  });

  Drivers.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;
    phone = dataSnapshot.value["phone"];
    email = dataSnapshot.value["email"];
    name = dataSnapshot.value["name"];
    carColor = dataSnapshot.value["car_details"]["car_color"];
    carModel = dataSnapshot.value["car_details"]["car_model"];
    carNumber = dataSnapshot.value["car_details"]["car_number"];
  }
}

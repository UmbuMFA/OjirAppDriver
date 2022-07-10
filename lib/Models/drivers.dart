import 'package:firebase_database/firebase_database.dart';

class Drivers {
  String? name;
  String? phone;
  String? photo;
  String? email;
  String? bank_sampah;
  String? id;

  Drivers({
    this.name,
    this.phone,
    this.email,
    this.id,
    this.bank_sampah,
  });

  Drivers.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;
    phone = dataSnapshot.child("phone").value.toString();
    photo = dataSnapshot.child("photo").value.toString();
    email = dataSnapshot.child("email").value.toString();
    name = dataSnapshot.child("name").value.toString();
    bank_sampah = dataSnapshot.child("bank_sampah").value.toString();
  }
}

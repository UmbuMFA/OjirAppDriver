import 'package:firebase_database/firebase_database.dart';

class History {
  String? paymentMethod;
  String? createdAt;
  String? status;
  String? fares;
  String? dropOff;
  String? pickup;

  History(
      {this.paymentMethod,
      this.createdAt,
      this.status,
      this.fares,
      this.dropOff,
      this.pickup});

  History.fromSnapshot(DataSnapshot snapshot) {
    paymentMethod = snapshot.child("payment_method").value.toString();
    createdAt = snapshot.child("created_at").value.toString();
    status = snapshot.child("status").value.toString();
    fares = snapshot.child("fares").value.toString();
    dropOff = snapshot.child("dropoff_address").value.toString();
    pickup = snapshot.child("pickup_address").value.toString();
  }
}

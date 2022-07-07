import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class History {
  String? paymentMethod;
  String? createdAt;
  String? status;
  String? fares;
  String? dropOff;
  String? pickup;
  String? id1;
  String? id2;
  String? date;
  String? berat;
  String? driver;
  String? client;

  History(
      {this.paymentMethod,
        this.createdAt,
        this.status,
        this.fares,
        this.dropOff,
        this.pickup,
        this.id1,
        this.id2,
        this.date,
        this.berat,
        this.driver,
        this.client});

  History.fromSnapshot(DataSnapshot snapshot) {
    paymentMethod = snapshot.child("payment_method").value.toString();
    createdAt = snapshot.child("created_at").value.toString();
    status = snapshot.child("status").value.toString();
    fares = snapshot.child("fares").value.toString();
    dropOff = snapshot.child("dropoff_address").value.toString();
    pickup = snapshot.child("pickup_address").value.toString();
    id1 = snapshot.child("id1").value.toString();
    id2 = snapshot.child("id2").value.toString();
    date = snapshot.child("date").value.toString();
    berat = snapshot.child("berat").value.toString();
    driver = snapshot.child("driver").value.toString();
    client = snapshot.child("client").value.toString();
  }
}

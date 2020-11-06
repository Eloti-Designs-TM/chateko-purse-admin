import 'package:cloud_firestore/cloud_firestore.dart';

class Investment {
  String id;
  String userID;
  String referrarCode;
  int unit;
  int totalAmount;
  String bankName;
  String accountName;
  String accountNumber;
  String address;
  String status;
  String duration;
  String timeCreated;

  Investment(
      {this.accountName,
      this.accountNumber,
      this.userID,
      this.bankName,
      this.id,
      this.status,
      this.unit,
      this.duration,
      this.timeCreated,
      this.address,
      this.totalAmount});

  factory Investment.fromDoc(DocumentSnapshot doc) {
    final data = doc.data();
    return Investment(
      id: doc.id,
      status: data['status'],
      userID: data['userID'],
      unit: data['unit'],
      totalAmount: data['totalAmount'],
      bankName: data['bankName'],
      accountName: data['accountName'],
      accountNumber: data['accountNumber'],
      duration: data['duration'],
      timeCreated: data['timeCreated'],
    );
  }

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();
    data['id'] = id;
    data['status'] = status;
    data['userID'] = userID;
    data['referrarCode'] = referrarCode;
    data['unit'] = unit;
    data['totalAmount'] = totalAmount;
    data['bankName'] = bankName;
    data['accountName'] = accountName;
    data['accountNumber'] = accountNumber;
    data['duration'] = '6 months';
    data['timeCreated'] = DateTime.now().toString();
    return data;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Bonus {
  final int amount;
  final bool isRead;
  final String referId;
  final String status;
  final String timeStamp;
  final String userID;

  Bonus(
      {this.amount,
      this.isRead,
      this.referId,
      this.status,
      this.timeStamp,
      this.userID});

  factory Bonus.fromDoc(DocumentSnapshot doc) {
    final data = doc.data();
    return Bonus(
      status: data['status'],
      referId: doc.id,
      userID: data['userID'],
      timeStamp: data['timeStamp'],
      amount: data['amount'],
      isRead: data['isRead'],
    );
  }
}

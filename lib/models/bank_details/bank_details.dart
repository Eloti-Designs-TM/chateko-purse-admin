import 'package:cloud_firestore/cloud_firestore.dart';

class BankDetials {
  String bankName;
  String accountNumber;
  String accountName;
  BankDetials({this.bankName, this.accountNumber, this.accountName});

  factory BankDetials.fromDoc(DocumentSnapshot doc) {
    final data = doc.data();
    return BankDetials(
      bankName: data['bank_name'],
      accountNumber: data['account_number'],
      accountName: data['account_name'],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class BankDetial {
  String bankName;
  String id;

  String accountNumber;
  String accountName;
  BankDetial({this.bankName, this.id, this.accountNumber, this.accountName});

  factory BankDetial.fromDoc(DocumentSnapshot doc) {
    final data = doc.data();
    return BankDetial(
      id: doc.id,
      bankName: data['bank_name'],
      accountNumber: data['account_number'],
      accountName: data['account_name'],
    );
  }

  Map<String, dynamic> toDoc() {
    final data = Map<String, dynamic>();
    data['bank_name'] = bankName;
    data['account_number'] = accountNumber;
    data['account_name'] = accountName;
    return data;
  }
}

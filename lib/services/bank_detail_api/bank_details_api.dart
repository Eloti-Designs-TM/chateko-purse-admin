import 'package:chateko_purse_admin/models/bank_details/bank_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BankDetailsApi with ChangeNotifier {
  var bankRef = FirebaseFirestore.instance.collection('bank_detial');
  Future<QuerySnapshot> getBankDetial() async {
    return await bankRef.get();
  }

  createBankDetails(BankDetial bankDetial) async {
    await bankRef.doc(DateTime.now().toString()).set(bankDetial.toDoc());
  }

  updateBankDetails(String id, Map<String, dynamic> doc) async {
    await bankRef.doc(id).update(doc);
  }

  deleteBankDetails(String id) async {
    await bankRef.doc(id).delete();
  }
}

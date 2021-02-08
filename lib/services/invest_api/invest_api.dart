import 'package:chateko_purse_admin/models/invest/investment.dart';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class InvestApi with ChangeNotifier {
  var investRef = FirebaseFirestore.instance.collection('investments');
  var referralSystem = FirebaseFirestore.instance.collection('refer_system');

  InvestApi() {
    getAllInvestmentFromFirestore();
    print('called');
  }

  getRefferral(String id, Map<String, dynamic> doc) async {
    await referralSystem.doc(id).update(doc);
  }

  Investment user;
  Stream<QuerySnapshot> investResult;
  TextEditingController searchController = TextEditingController();

  getAllInvestmentFromFirestore() {
    final data = investRef.snapshots();
    investResult = data;
    notifyListeners();
  }

  handleSearch(String query) async {
    Stream<QuerySnapshot> search =
        investRef.where('id', isEqualTo: query).snapshots();
    investResult = search;
    print(search);
    notifyListeners();
  }

  Stream<DocumentSnapshot> getCurrentInvestment(String id) async* {
    yield* investRef.doc(id).snapshots();
  }

  var authApi = GetIt.I.get<AuthApi>();

  Stream<QuerySnapshot> getInvests(userID) async* {
    yield* investRef.where('userID', isEqualTo: userID).snapshots();
  }

  updateInvestment(String id, Map<String, dynamic> doc) async {
    await investRef.doc(id).update(doc);
  }

  Future<void> deleteInvestment(String id) async {
    await investRef.doc(id).delete();
  }

  Future<QuerySnapshot> getInvest(
    int limit, {
    DocumentSnapshot startAfter,
  }) async {
    final refUsers = investRef.orderBy('isRead', descending: true).limit(limit);

    if (startAfter == null) {
      return refUsers.get();
    } else {
      return refUsers.startAfterDocument(startAfter).get();
    }
  }
}

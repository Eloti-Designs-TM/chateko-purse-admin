import 'package:chateko_purse_admin/models/invest/investment.dart';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class InvestApi with ChangeNotifier {
  var investRef = FirebaseFirestore.instance.collection('investments');
  var bankRef = FirebaseFirestore.instance.collection('bank_detial');

  Investment user;
  Stream<QuerySnapshot> resultFromUserColloection;
  TextEditingController searchController = TextEditingController();

  getAllInvestmentFromFirestore() {
    final data = investRef.snapshots();
    resultFromUserColloection = data;
    notifyListeners();
  }

  handleSearch(String query) async {
    Stream<QuerySnapshot> search =
        investRef.where('id', isEqualTo: query).snapshots();
    resultFromUserColloection = search;
    print(search);
    notifyListeners();
  }

  getCurrentInvestment(context, {String userID}) async {
    user = Investment();
    DocumentSnapshot documents = await investRef.doc(userID).get();
    user = Investment.fromDoc(documents);
    notifyListeners();
  }

  var authApi = GetIt.I.get<AuthApi>();

  Stream<QuerySnapshot> getInvests(userID) async* {
    yield* investRef.where('userID', isEqualTo: userID).snapshots();
  }

  Future<QuerySnapshot> getBankDetial() async {
    return await bankRef.get();
  }
}

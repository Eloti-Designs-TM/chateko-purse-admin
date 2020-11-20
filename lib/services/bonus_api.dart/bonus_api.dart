import 'package:chateko_purse_admin/models/referrals/referral.dart';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class BonusApi extends ChangeNotifier {
  bool requesting = false;
  final authApi = GetIt.I.get<AuthApi>();
  var bonusRef = FirebaseFirestore.instance.collection('bonus_request');

  Stream<QuerySnapshot> getBonuses() async* {
    yield* bonusRef.snapshots();
  }

  Stream<QuerySnapshot> getReferrals() async* {
    authApi.getCurrentUser(authApi.users.userID);
    yield* authApi.referRef
        .doc(authApi.users.referralCode)
        .collection('referrals')
        .snapshots();
  }

  Future<QuerySnapshot> getBonus(
    int limit, {
    DocumentSnapshot startAfter,
  }) async {
    final refUsers = bonusRef.orderBy('isRead', descending: true).limit(limit);

    if (startAfter == null) {
      return refUsers.get();
    } else {
      return refUsers.startAfterDocument(startAfter).get();
    }
  }
}

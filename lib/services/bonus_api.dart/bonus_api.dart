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

  void requestWithddrawal(context, {String userId}) async {
    final ref = await authApi.referRef.doc(authApi.users.referralCode).get();
    var referral = ReferSystem();
    referral = ReferSystem.fromDoc(ref);

    if (referral.activePayment != null && referral.activePayment >= 100) {
      showEligibility(context,
          msg: 'Are you sure you want to perform this request?',
          onTap: () async {
        await bonusRef.doc(userId).set({
          'userID': authApi.users.userID,
          'amount': referral.activePayment,
          'timeStamp': DateTime.now().toString(),
        });
        Navigator.of(context).pop();
      });
    } else {
      showEligibility(context,
          msg: 'You do not have enough Active bonus to perform this request.');
    }
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

Future showEligibility(context, {String msg, VoidCallback onTap}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Request Withdrawal'),
      content: Text('$msg'),
      actions: [
        FlatButton(
          child: Text('Request'),
          onPressed: onTap,
        ),
        FlatButton(
          child: Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

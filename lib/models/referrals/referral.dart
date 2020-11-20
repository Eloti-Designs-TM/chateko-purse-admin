import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ReferSystem {
  int activePayment;
  int activeReferralCount;
  int pedingPayment;
  int pendingReferralCount;
  String referralCode;
  String userID;

  ReferSystem(
      {this.activePayment,
      this.activeReferralCount,
      this.pedingPayment,
      this.pendingReferralCount,
      this.referralCode,
      this.userID});

  factory ReferSystem.fromDoc(DocumentSnapshot doc) {
    final data = doc.data();
    return ReferSystem(
      activePayment: data['activePayment'],
      activeReferralCount: data['activeReferralCount'],
      pedingPayment: data['pedingPayment'],
      pendingReferralCount: data['pendingReferralCount'],
      referralCode: doc.id,
      userID: data['userID'],
    );
  }

  Map<String, dynamic> toMap({
    @required int pedingPayment,
    @required int pendingReferralCount,
    @required int activePayment,
    @required int activeReferralCount,
  }) {
    final data = Map<String, dynamic>();
    data['activePayment'] = activePayment;
    data['activeReferralCount'] = activeReferralCount;
    data['pedingPayment'] = pedingPayment;
    data['pendingReferralCount'] = pendingReferralCount;
    return data;
  }

  Map<String, dynamic> toDoc() {
    final data = Map<String, dynamic>();
    data['activePayment'] = activePayment;
    data['activeReferralCount'] = activeReferralCount;
    data['pedingPayment'] = pedingPayment;
    data['pendingReferralCount'] = pendingReferralCount;
    data['referralCode'] = referralCode;
    data['userID'] = userID;
    return data;
  }
}

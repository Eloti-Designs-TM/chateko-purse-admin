import 'package:chateko_purse_admin/models/invest/investment.dart';
import 'package:chateko_purse_admin/models/referrals/referral.dart';
import 'package:chateko_purse_admin/models/user/user.dart';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/services/invest_api/invest_api.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class InvestViewModel with ChangeNotifier {
  var authApi = GetIt.I.get<AuthApi>();
  var investApi = GetIt.I.get<InvestApi>();

  getAllInvestment() {
    try {
      investApi.getInvests(authApi.users.userID);
    } catch (e) {
      print(e);
    }
  }

  updateFirstTimeUserStatus(
      {String id, String status, Investment invest, Users user}) async {
    var referral = ReferSystem();

    final refDoc = await authApi.referRef.doc(user.referrarCode).get();
    final userDoc = await authApi.userRef.doc(user.userID).get();
    user = Users.fromDoc(userDoc);

    if (user.paidFirstInvestment == 'pending') {
      if (refDoc.exists) {
        referral = ReferSystem.fromDoc(refDoc);
      }
      if (refDoc.exists) {
        print(referral.activePayment + 500);

        await investApi.referralSystem
            .doc(user.referrarCode)
            .update(referral.toMap(
              activePayment: referral.activePayment + 500,
              activeReferralCount: referral.activeReferralCount + 1,
              pedingPayment: referral.pedingPayment == 0
                  ? referral.pedingPayment
                  : referral.pedingPayment - 500,
              pendingReferralCount: referral.pendingReferralCount == 0
                  ? referral.pendingReferralCount
                  : referral.pendingReferralCount - 1,
            ));
        await investApi.referralSystem
            .doc(user.referrarCode)
            .collection('referrals')
            .doc(user.userID)
            .update({
          'status': 'active',
        });
        await authApi.userRef.doc(user.userID).update({
          'paidFirstInvestment': 'active',
        });
      }
    }
  }

  updateStatus(
      {String id, String status, Investment invest, Users user}) async {
    await investApi.updateInvestmentStatus(id, {
      'status': status,
    });
    if (status == 'active') {
      await updateFirstTimeUserStatus(
          id: id, status: status, invest: invest, user: user);
    }
  }

  isCardClick(String id) async {
    await investApi.investRef.doc(id).update({
      'isRead': false,
    });
  }
}

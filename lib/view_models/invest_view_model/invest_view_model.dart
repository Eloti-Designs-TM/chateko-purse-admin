import 'package:chateko_purse_admin/models/invest/investment.dart';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/services/invest_api/invest_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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

  updateStatus({String id, String status, Investment invest}) {
    investApi.updateInvestmentStatus(id, {
      'status': status,
    });
  }
}

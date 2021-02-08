import 'dart:async';

import 'package:chateko_purse_admin/models/invest/investment.dart';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/services/invest_api/invest_api.dart';
import 'package:chateko_purse_admin/view_models/invest_view_model/invest_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class InvestPagination extends InvestViewModel {
  final authApi = GetIt.I.get<AuthApi>();
  final investApi = GetIt.I.get<InvestApi>();

  final scrollController = ScrollController();

  final _controller = StreamController<List<Investment>>.broadcast();
  Stream<List<Investment>> get controllerOut =>
      _controller.stream.asBroadcastStream();
  StreamSink<List<Investment>> get controllerIn => _controller.sink;

  List<Investment> filteredInvestment = [];
  // List<Investment> investments = [];

  InvestPagination() {
    scrollController.addListener(scrollListener);
    fetchNextInvestments();
  }

  List<Investment> get investments => _investSnapshot
      .map(
        (snap) => Investment.fromDoc(snap),
      )
      .toList();

  getInvestment() {
    var investment = Investment();
    _investSnapshot.map((snap) {
      investment = Investment.fromDoc(snap);
      addUsers(investment);
    }).toList();
  }

  addUsers(Investment investment) {
    investments.add(investment);
    controllerIn.add(investments);
    notifyListeners();
  }

  @override
  void dispose() {
    _controller.close();

    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      if (hasNext) {
        fetchNextInvestments();
      }
    }
  }

  final _investSnapshot = <DocumentSnapshot>[];
  String _errorMessage = '';
  int documentLimit = 10;
  bool _hasNext = true;
  bool _isFetchingUsers = false;

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  // List<Investment> get investments => _investSnapshot.map((snap) {
  //       return Investment.fromDoc(snap);
  //     }).toList();

  Future fetchNextInvestments() async {
    if (_isFetchingUsers) return;

    _errorMessage = '';
    _isFetchingUsers = true;

    try {
      final snap = await investApi.getInvest(
        documentLimit,
        startAfter: _investSnapshot.isNotEmpty ? _investSnapshot.last : null,
      );
      _investSnapshot.addAll(snap.docs);
      getInvestment();
      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetchingUsers = false;
  }

  handleSearch(String query) async {
    final search =
        investApi.investRef.where('id', isLessThanOrEqualTo: query).snapshots();
    var user = Investment();

    search.map((m) {
      m.docs.forEach((element) {
        user = Investment.fromDoc(element);
        investments.add(user);
        filteredInvestment = investments
            .where((u) => (u.id.contains(query) || u.bankName.contains(query)))
            .toList();
        print(filteredInvestment.length);
        filteredInvestment.forEach((element) {
          print(element.id);
        });
      });
    }).toList();
    notifyListeners();
  }
}

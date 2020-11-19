import 'package:chateko_purse_admin/models/invest/investment.dart';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/services/invest_api/invest_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class InvestPagination extends ChangeNotifier {
  final authApi = GetIt.I.get<AuthApi>();
  final investApi = GetIt.I.get<InvestApi>();

  final scrollController = ScrollController();

  InvestPagination() {
    scrollController.addListener(scrollListener);
    fetchNextInvestments();
  }

  @override
  void dispose() {
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

  List<Investment> get investments => _investSnapshot.map((snap) {
        return Investment.fromDoc(snap);
      }).toList();

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

      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetchingUsers = false;
  }
}

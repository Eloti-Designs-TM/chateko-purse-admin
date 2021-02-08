import 'package:chateko_purse_admin/models/invest/bonus.dart';
import 'package:chateko_purse_admin/models/user/user.dart';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/services/bonus_api.dart/bonus_api.dart';
import 'package:chateko_purse_admin/ui/views/widget/snacks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class BonusPagination extends ChangeNotifier {
  final authApi = GetIt.I.get<AuthApi>();
  final bonusApi = GetIt.I.get<BonusApi>();

  final scrollController = ScrollController();

  BonusPagination() {
    scrollController.addListener(scrollListener);
    fetchNextBonuses();
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
        fetchNextBonuses();
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

  List<Bonus> get bonuses => _investSnapshot.map((snap) {
        return Bonus.fromDoc(snap);
      }).toList();

  Future fetchNextBonuses() async {
    if (_isFetchingUsers) return;

    _errorMessage = '';
    _isFetchingUsers = true;

    try {
      final snap = await bonusApi.getBonus(
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

  isCardClick(String id) async {
    await bonusApi.bonusRef.doc(id).update({
      'isRead': true,
    });
  }

  updateStatus(context, String id, String status, Users user) async {
    await bonusApi.bonusRef.doc(id).update({
      'status': status,
    });
    if (status != 'pending') {
      await authApi.referRef.doc(user.referralCode).update({
        'activePayment': 0,
      });
    }
    showSnackbarSuccess(context, msg: 'Updated Bonus Request status');
  }

  deleteBonus(context, String id) async {
    await bonusApi.bonusRef.doc(id).delete();
    showSnackbarSuccess(context, msg: 'Deleted Bonus Request');
  }
}

import 'package:flutter/cupertino.dart';

enum DetailState {
  InvestNow,
  BonusEarnin,
  InvestHistory,
  Refferels,
  Profile,
  Loading,
  Error
}

class DetailViewModel with ChangeNotifier {
  DetailState _detailState = DetailState.Loading;
  DetailState get detailState => _detailState;

  set changeState(DetailState state) {
    _detailState = state;
    notifyListeners();
  }
}

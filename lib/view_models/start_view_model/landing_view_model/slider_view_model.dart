import 'package:flutter/material.dart';
import '../../base_view_model.dart';

class SliderViewModel extends BaseViewModel {
  int pageIndex = 0;
  PageController pageController;

  SliderViewModel() {
    pageController = PageController();
  }

  void onPageChanged(int pageIndex) {
    this.pageIndex = pageIndex;
    notifyListeners();
  }

  void onTapChangePageView(int pageIndeX) {
    pageController.animateToPage(
      pageIndeX,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    notifyListeners();
  }
}

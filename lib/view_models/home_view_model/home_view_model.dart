import 'package:chateko_purse_admin/view_models/detail_view_model/detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeViewModel with ChangeNotifier {
  final List<Menu> menu = [
    Menu(
      id: '0',
      title: 'Manage User',
      icon: Icons.people,
      state: DetailState.Users,
    ),
    Menu(
      id: '1',
      title: 'Manage Investment',
      icon: Icons.account_balance,
      state: DetailState.Investments,
    ),
    Menu(
      id: '2',
      title: 'Bonus Requests',
      icon: Icons.military_tech,
      state: DetailState.Bonus,
    ),
    Menu(
      id: '2',
      title: 'Others',
      icon: Icons.dynamic_form,
      state: DetailState.Others,
    ),
  ];

  DetailState _detailState = DetailState.Loading;
  DetailState get detailState => _detailState;

  set changeState(DetailState state) {
    _detailState = state;
    notifyListeners();
  }
}

class Menu {
  final String id;
  final String title;
  final IconData icon;
  final DetailState state;

  Menu({this.id, this.title, this.icon, this.state});
}

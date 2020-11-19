import 'package:chateko_purse_admin/ui/views/bonus/bonus.dart';
import 'package:chateko_purse_admin/ui/views/others/others.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chateko_purse_admin/ui/views/manage_user/manage_user_page.dart';
import 'package:chateko_purse_admin/ui/views/investment/investment.dart';
import 'package:chateko_purse_admin/view_models/detail_view_model/detail_view_model.dart';
import 'package:chateko_purse_admin/view_models/home_view_model/home_view_model.dart';

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
            // controller: userReq.searchController,
            style: TextStyle(fontSize: 18),
            // onFieldSubmitted: userReq.handleSearch,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Search user',
              fillColor: Colors.white,
              suffixIcon: InkWell(
                  // onTap: () =>
                  // userReq.handleSearch(userReq.searchController.text),
                  child: Icon(Icons.search)),
            )),
      ),
      body: Consumer<HomeViewModel>(
        builder: (_, homeModel, ch) => _pages(homeModel.detailState),
      ),
    );
  }

  _pages([DetailState detailState]) {
    print(detailState);
    switch (detailState) {
      case DetailState.Users:
        return ManageUserPage();
        break;
      case DetailState.Investments:
        return InvestmentsPage();
        break;
      case DetailState.Bonus:
        return BonusPage();
        break;
      case DetailState.Others:
        return Others();

        break;
      case DetailState.Loading:
        return Center(
          child: CircularProgressIndicator(),
        );

        break;
      case DetailState.Error:
        break;
    }
  }
}

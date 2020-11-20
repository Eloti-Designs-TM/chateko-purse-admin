import 'package:chateko_purse_admin/ui/views/bonus/bonus.dart';
import 'package:chateko_purse_admin/ui/views/others/others.dart';
import 'package:chateko_purse_admin/view_models/profile_view_model/user_pagination.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chateko_purse_admin/ui/views/manage_user/manage_user_page.dart';
import 'package:chateko_purse_admin/ui/views/investment/investment.dart';
import 'package:chateko_purse_admin/view_models/detail_view_model/detail_view_model.dart';
import 'package:chateko_purse_admin/view_models/home_view_model/home_view_model.dart';

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (_, homeModel, ch) => Scaffold(
        appBar: AppBar(
          title: Text(_pages(homeModel.detailState, isTitle: true)),
          centerTitle: true,
        ),
        body: _pages(homeModel.detailState),
      ),
    );
  }

  _pages(DetailState detailState, {bool isTitle = false}) {
    print(detailState);
    switch (detailState) {
      case DetailState.Users:
        return isTitle ? 'All Users' : ManageUserPage();
        break;
      case DetailState.Investments:
        return isTitle ? 'All Investments' : InvestmentsPage();
        break;
      case DetailState.Bonus:
        return isTitle ? 'All Bonuses' : BonusPage();
        break;
      case DetailState.Others:
        return isTitle ? 'Others' : Others();
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

// class SearchBar extends StatelessWidget {
//   final TextEditingController searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return UserInjector(
//       child: Consumer<UsersPagination>(
//         builder: (context, api, child) => TextFormField(
//             controller: searchController,
//             style: TextStyle(fontSize: 18),
//             // onFieldSubmitted: userReq.handleSearch,
//             onChanged: api.handleSearch,
//             decoration: InputDecoration(
//               filled: true,
//               hintText: 'Search',
//               fillColor: Colors.white,
//               suffixIcon: InkWell(
//                   // onTap: () =>
//                   // userReq.handleSearch(userReq.searchController.text),
//                   child: Icon(Icons.search)),
//             )),
//       ),
//     );
//   }
// }

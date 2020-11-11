import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/ui/views/home_view/widget/top_bar.dart';
import 'package:chateko_purse_admin/ui/views/investment/investment.dart';
import 'package:chateko_purse_admin/ui/views/manage_user/manage_user_page.dart';
import 'package:chateko_purse_admin/ui/views/ads_view/ads.dart';
import 'package:chateko_purse_admin/ui/views/widget/custom_effect.dart';
import 'package:chateko_purse_admin/view_models/detail_view_model/detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Menu {
  final String id;
  final String title;
  final IconData icon;
  final DetailState state;

  Menu({this.id, this.title, this.icon, this.state});
}

class HomeView extends StatelessWidget {
  final List<Menu> _menu = [
    Menu(
      id: '0',
      title: 'Manage User',
      icon: Icons.people,
      state: DetailState.InvestNow,
    ),
    Menu(
      id: '1',
      title: 'Manage Investment',
      icon: Icons.account_balance,
      state: DetailState.BonusEarnin,
    ),
    Menu(
      id: '2',
      title: 'Manage Bonus',
      icon: Icons.military_tech,
      state: DetailState.InvestHistory,
    ),
    Menu(
      id: '2',
      title: 'Others',
      icon: Icons.military_tech,
      state: DetailState.InvestHistory,
    ),
  ];

  final authApi = GetIt.I.get<AuthApi>();

  @override
  Widget build(BuildContext context) {
    var user = authApi.users;
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async => authApi.currentFirebase != null
          ? await authApi.getCurrentUser(user.userID)
          : null,
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.2,
                      child: CustomPaint(
                        painter: CustomToolbarShape(lineColor: Colors.pink),
                      )),
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: SafeArea(
                      child: Column(
                        children: [
                          HomeTopBar(authApi: authApi, user: user),
                          AdsView(),
                          TopWriteUp(authApi: authApi, user: user),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              GridView.builder(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _menu.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (_, i) {
                  final kMenu = _menu[i];
                  return Container(
                    margin: const EdgeInsets.all(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () async {
                        if (_menu[i].title == 'Manage User') {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => Investments()));
                        }
                        // if (authApi.currentFirebase == null) {
                        //   Navigator.of(context).pushReplacement(
                        //       MaterialPageRoute(
                        //           fullscreenDialog: true,
                        //           builder: (_) => SignUpLogin()));
                        // } else {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (_) => DetailView(
                        //         title: _menu[i].title,
                        //         state: _menu[i].state)));
                        // }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey[300]),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(kMenu.icon, color: Colors.pink[600], size: 35),
                            SizedBox(height: 10),
                            Text(kMenu.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF3C1361),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Container(height: 200)
            ],
          ),
        ),
      ),
    ));
  }
}

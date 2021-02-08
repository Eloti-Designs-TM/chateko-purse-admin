import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chateko_purse_admin/ui/views/investment/widget/invest_detail.dart';
import 'package:chateko_purse_admin/view_models/invest_view_model/invest_pagination.dart';
import 'package:chateko_purse_admin/models/user/user.dart';
import 'package:chateko_purse_admin/services/users_api/users_api.dart';
import 'package:chateko_purse_admin/ui/commons/sizes.dart';

class InvestmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InvestInjector(
      child: Consumer2<InvestPagination, UserApi>(
        builder: (_, api, userApi, child) => api.investments.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Container(
                  //   height: 40,
                  //   child: TextFormField(
                  //       // controller: userReq.searchController,
                  //       style: TextStyle(fontSize: 18),
                  //       onFieldSubmitted: api.handleSearch,
                  //       onChanged: api.handleSearch,
                  //       decoration: InputDecoration(
                  //         filled: true,
                  //         hintText: 'Search investment...',
                  //         fillColor: Colors.white,
                  //         suffixIcon: InkWell(
                  //             // onTap: () => userReq
                  //             //     .handleSearch(userReq.searchController.text),
                  //             child: Icon(Icons.search)),
                  //       )),
                  // ),
                  Expanded(
                      child: RefreshIndicator(
                    onRefresh: () {
                      return api.fetchNextInvestments();
                    },
                    child: ListView.separated(
                      separatorBuilder: (_, i) => Divider(),
                      itemCount: api.investments.length,
                      itemBuilder: (_, i) {
                        final kInvest = api.investments[i];
                        return StreamBuilder<DocumentSnapshot>(
                            stream:
                                userApi.getCurrentUser(userID: kInvest.userID),
                            builder: (context, snapshot2) {
                              if (!snapshot2.hasData) {
                                return Container();
                              }
                              final doc = snapshot2.data;
                              var user = Users();
                              user = Users.fromDoc(doc);

                              return Container(
                                child: ListTile(
                                  title: Text('${kInvest.id}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      sizedBoxHeight8,
                                      Text('${user.fullName}'),
                                      Text('N${kInvest.totalAmount}'),
                                      kInvest.isRead == true
                                          ? Chip(
                                              padding: const EdgeInsets.all(0),
                                              label: Text(
                                                'New',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: Colors.red,
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        user.imageUrl),
                                  ),
                                  trailing: Text('${kInvest.status}',
                                      style: TextStyle(
                                          color: kInvest.status == 'active'
                                              ? Colors.green
                                              : Colors.red)),
                                  onTap: () async {
                                    if (kInvest.isRead) {
                                      await api.isCardClick(kInvest.id);
                                    }
                                    await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => InvestmentDetails(
                                                investment: kInvest,
                                                user: user)));
                                  },
                                ),
                              );
                            });
                      },
                    ),
                  )),
                ],
              ),
      ),
    );
  }
}

class InvestInjector extends StatelessWidget {
  final Widget child;

  const InvestInjector({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InvestPagination(),
      child: child,
    );
  }
}

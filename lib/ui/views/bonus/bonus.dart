import 'package:cached_network_image/cached_network_image.dart';
import 'package:chateko_purse_admin/models/user/user.dart';
import 'package:chateko_purse_admin/services/bonus_api.dart/bonus_api.dart';
import 'package:chateko_purse_admin/services/users_api/users_api.dart';
import 'package:chateko_purse_admin/ui/commons/sizes.dart';
import 'package:chateko_purse_admin/ui/utils/number_to_currency_format.dart';
import 'package:chateko_purse_admin/ui/views/bonus/widget/bonus_request.dart';
import 'package:chateko_purse_admin/view_models/bonus_model/bonus_pagination.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BonusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BonusInjector(
        child: Container(
            child: Consumer2<BonusPagination, UserApi>(
                builder: (_, bonusApi, userApi, child) => bonusApi
                        .bonuses.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        controller: bonusApi.scrollController,
                        separatorBuilder: (_, i) => Divider(),
                        itemCount: bonusApi.bonuses.length,
                        itemBuilder: (_, i) {
                          final kBonus = bonusApi.bonuses[i];
                          return StreamBuilder<DocumentSnapshot>(
                              stream:
                                  userApi.getCurrentUser(userID: kBonus.userID),
                              builder: (context, snapshot2) {
                                if (!snapshot2.hasData) {
                                  return Container();
                                }
                                final doc = snapshot2.data;
                                var user = Users();
                                user = Users.fromDoc(doc);

                                return Container(
                                  child: ListTile(
                                    title: Text('${user.fullName}'),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        sizedBoxHeight8,
                                        Text('${user.email}'),
                                        Text(
                                            'N${convertNumberToCurrency(kBonus.amount)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                        Text('${kBonus.timeStamp}'),
                                        kBonus.isRead == false
                                            ? Chip(
                                                padding:
                                                    const EdgeInsets.all(0),
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
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              user.imageUrl),
                                    ),
                                    trailing: Text('${kBonus.status}',
                                        style: TextStyle(
                                            color: kBonus.status == 'paid'
                                                ? Colors.green
                                                : Colors.red)),
                                    onTap: () {
                                      if (kBonus.isRead) {
                                        // bonusApi.isCardClick(kBonus.id);
                                      }
                                      showDialog(
                                          context: context,
                                          builder: (_) => ShowRequestDetails(
                                              user: user, bonus: kBonus));
                                    },
                                  ),
                                );
                              });
                        },
                      ))));
  }
}

class BonusInjector extends StatelessWidget {
  final Widget child;

  const BonusInjector({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: BonusApi()),
        ChangeNotifierProvider.value(value: BonusPagination()),
      ],
      child: child,
    );
  }
}

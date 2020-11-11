import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chateko_purse_admin/models/invest/investment.dart';
import 'package:chateko_purse_admin/models/user/user.dart';
import 'package:chateko_purse_admin/services/invest_api/invest_api.dart';
import 'package:chateko_purse_admin/services/users_api/users_api.dart';
import 'package:chateko_purse_admin/ui/commons/sizes.dart';
import 'package:chateko_purse_admin/view_models/invest_view_model/invest_view_model.dart';

class Investments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer2<InvestApi, UserApi>(
        builder: (_, api, userApi, child) => StreamBuilder<QuerySnapshot>(
            stream: api.investResult,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final doc = snapshot.data.docs;
              var invest = Investment();
              var invests = List<Investment>();

              doc.map((e) {
                invest = Investment.fromDoc(e);
                invests.add(invest);
              }).toList();

              return ListView.separated(
                separatorBuilder: (_, i) => Divider(),
                itemCount: invests.length,
                itemBuilder: (_, i) {
                  final kInvest = invests[i];
                  return StreamBuilder<DocumentSnapshot>(
                      stream: userApi.getCurrentUser(userID: kInvest.userID),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sizedBoxHeight8,
                                Text('${user.fullName}'),
                                Text('N${kInvest.totalAmount}'),
                                kInvest.isRead == true
                                    ? Chip(
                                        padding: const EdgeInsets.all(0),
                                        label: Text(
                                          'New',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      )
                                    : Container(),
                              ],
                            ),
                            leading: CircleAvatar(
                              backgroundImage:
                                  CachedNetworkImageProvider(user.imageUrl),
                            ),
                            trailing: Text('${kInvest.status}',
                                style: TextStyle(
                                    color: kInvest.status == 'active'
                                        ? Colors.green
                                        : Colors.red)),
                            onTap: () {
                              if (kInvest.isRead) {
                                api.isCardClick(kInvest.id);
                              }
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => InvestmentDetails(
                                      investment: kInvest, user: user)));
                            },
                          ),
                        );
                      });
                },
              );
            }),
      ),
    );
  }
}

class InvestmentDetails extends StatelessWidget {
  final Investment investment;
  final Users user;
  final bool isActive = false;

  const InvestmentDetails({Key key, this.investment, this.user})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer2<InvestApi, InvestViewModel>(
      builder: (ctx, api, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Investment Details'),
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: api.getCurrentInvestment(investment.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              print(snapshot.data);

              final doc = snapshot.data;
              var invest = Investment();
              invest = Investment.fromDoc(doc);
              return SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'INVESTOR DETAILS',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 5),
                        Material(
                          // color: Colors.pink,
                          borderRadius: BorderRadius.circular(8),
                          elevation: 2,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              user.imageUrl),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _text('${user.fullName}', Icons.person),
                                        _text('${user.email}', Icons.email,
                                            size: 16,
                                            fontWeight: FontWeight.w400),
                                        _text('${user.phone}', Icons.phone,
                                            size: 16,
                                            fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _text(
                                          '${user.address == '' ? "No Address Found" : user.address}',
                                          Icons.place,
                                          size: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    FlatButton(
                                      shape: StadiumBorder(),
                                      onPressed: () {},
                                      textColor: Colors.white,
                                      color: Colors.pink,
                                      child: Text('Call'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'INVESTMENT DETAILS',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 5),
                        Material(
                          borderRadius: BorderRadius.circular(8),
                          elevation: 2,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _textInLine('Investment ID', '${invest.id}'),
                                _textInLine('Unit:', '${invest.unit}'),
                                _textInLine(
                                    'Amount:', 'N${invest.totalAmount}'),
                                _textInLine(
                                    'Account Name:', '${invest.accountName}'),
                                _textInLine(
                                    'Account No:', '${invest.accountNumber}'),
                                _textInLine('Bank Name:', '${invest.bankName}'),
                                _textInLine('Time:', '${invest.timeCreated}'),
                                _textInLine('Status:', '${invest.status}'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              shape: StadiumBorder(),
                              onPressed: () {
                                model.updateStatus(
                                    id: invest.id,
                                    status: 'pending',
                                    invest: invest);
                              },
                              textColor: invest.status == 'active'
                                  ? Colors.black
                                  : Colors.white,
                              color: invest.status == 'active'
                                  ? Colors.grey
                                  : Colors.red,
                              child: Text('Pending'),
                            ),
                            SizedBox(width: 20),
                            FlatButton(
                              shape: StadiumBorder(),
                              onPressed: () {
                                model.updateStatus(
                                    id: invest.id,
                                    status: 'active',
                                    invest: invest);
                              },
                              textColor: invest.status == 'active'
                                  ? Colors.white
                                  : Colors.black,
                              color: invest.status == 'active'
                                  ? Colors.green
                                  : Colors.grey,
                              child: Text('Active'),
                            ),
                          ],
                        ),
                      ],
                    )),
              );
            }),
      ),
    );
  }

  Padding _textInLine(String text1, String text2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$text1',
            style: TextStyle(
              color: Colors.purple[900],
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(width: 5),
          Text(
            '$text2',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Padding _text(String text, icon, {double size, FontWeight fontWeight}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey[600],
              size: 16,
            ),
            SizedBox(width: 10),
            Text(
              '$text',
              style: TextStyle(
                fontSize: size ?? 24,
                color: Colors.grey[800],
                fontWeight: fontWeight ?? FontWeight.w500,
              ),
            ),
          ],
        ),
      );
}

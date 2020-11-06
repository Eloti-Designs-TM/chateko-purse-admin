import 'package:bed_admin/provider/send_req/openUrls.dart';
import 'package:bed_admin/provider/send_req/ride_request.dart';
import 'package:bed_admin/provider/send_req/user_req.dart';
import 'package:bed_admin/ui/page/widget/custom_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class ManagePickMeUp extends StatefulWidget {
  @override
  _ManagePickMeUpState createState() => _ManagePickMeUpState();
}

class _ManagePickMeUpState extends State<ManagePickMeUp> {
  bool searchIconEnabled = false;

  @override
  void initState() {
    super.initState();
    initializeGetData();
  }

  initializeGetData() async {
    await Future.delayed(Duration(seconds: 2));
    if (!mounted) return;
    setState(() {});
    Provider.of<RideReq>(context, listen: false).getAllRidesFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: searchIconEnabled
            ? Consumer<RideReq>(builder: (context, userReq, child) {
                return Container(
                  height: 40,
                  child: TextFormField(
                      controller: userReq.searchController,
                      style: TextStyle(fontSize: 18),
                      onFieldSubmitted: userReq.handleSearch,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Search rides',
                        fillColor: Colors.white,
                        suffixIcon: InkWell(
                            onTap: () => userReq
                                .handleSearch(userReq.searchController.text),
                            child: Icon(Icons.search)),
                      )),
                );
              })
            : Text('Manage Rides'),
        centerTitle: true,
        actions: [
          InkWell(
              onTap: () {
                setState(() {
                  searchIconEnabled = !searchIconEnabled;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(searchIconEnabled ? Icons.close : Icons.search),
              )),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Consumer<RideReq>(builder: (context, userReq, ch) {
          return StreamBuilder<QuerySnapshot>(
              stream: userReq.resultFromUserColloection,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final data = snapshot.data.documents;
                if (data.isEmpty || data == null) {
                  return Center(child: Text('No Rides to show!'));
                }
                return searchIconEnabled
                    ? _buildSearchView(data, context)
                    : PaginateFirestore(
                        query: Firestore.instance
                            .collection('pickMeUp')
                            .orderBy('name'),
                        itemsPerPage: 10,
                        initialLoader: Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        bottomLoader: Container(
                              child: Center(
                            child: Column(
                              children: [
                                CupertinoActivityIndicator(),
                                Text('Getting more data!')
                              ],
                            ),
                          )),
                        itemBuilderType: PaginateBuilderType.listView,
                        itemBuilder: (i, context, snapshot) {
                          final username = data[i]['name'];
                          final phone = data[i]['phone'];
                          final email = data[i]['email'];
                          final pickUpAddress = data[i]['pickUpAddress'];
                          final destination = data[i]['destinationAddress'];

                          return ListTile(
                            title: Text(
                              '$username',
                              style: TextStyle(fontSize: 18),
                            ),
                            subtitle: Text('$email\n$phone'),
                            trailing: Icon(Icons.arrow_forward, size: 14),
                            onTap: () => showDialog(
                              context: context,
                              builder: (ctx) => CustomDialog(
                                  title: Container(
                                      padding: const EdgeInsets.all(16),
                                      color: Colors.blue[100],
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text('$username'),
                                          ],
                                        ),
                                      )),
                                  children: [
                                    titleWIthTrailingText(
                                        leadingText: 'Name',
                                        trailingText: '$username'),
                                    SizedBox(height: 10),
                                    titleWIthTrailingText(
                                        leadingText: 'Email',
                                        trailingText: '$email'),
                                    SizedBox(height: 10),
                                    titleWIthTrailingText(
                                        leadingText: 'Phone:',
                                        trailingText: '$phone'),
                                    SizedBox(height: 10),
                                    Divider(),
                                    titleWIthTrailingText(
                                        leadingText: 'Pick Up Address:',
                                        trailingText: "$pickUpAddress"),
                                    SizedBox(height: 10),
                                    titleWIthTrailingText(
                                        leadingText: 'Destination',
                                        trailingText: "$destination"),
                                    SizedBox(height: 10),
                                    Consumer<OpenUrls>(
                                        builder: (context, open, child) {
                                      return FlatButton.icon(
                                          color: Colors.grey[200],
                                          onPressed: () {
                                            open.makePhoneCall('tel:$phone');
                                          },
                                          icon: Icon(Icons.call),
                                          label: Text('Call'));
                                    }),
                                  ]),
                            ),
                          );
                        });
              });
        }),
      ),
    );
  }

  ListView _buildSearchView(List<DocumentSnapshot> data, BuildContext context) {
    return ListView.separated(
        separatorBuilder: (ctx, i) => Divider(),
        itemCount: data.length,
        itemBuilder: (ctx, i) {
          final username = data[i]['name'];
          final phone = data[i]['phone'];
          final email = data[i]['email'];
          final pickUpAddress = data[i]['pickUpAddress'];
          final destination = data[i]['destinationAddress'];

          return ListTile(
            title: Text(
              '$username',
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text('$email\n$phone'),
            trailing: Icon(Icons.arrow_forward, size: 14),
            onTap: () => showDialog(
              context: context,
              builder: (ctx) => CustomDialog(
                  title: Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.blue[100],
                      child: Center(
                        child: Column(
                          children: [
                            Text('$username'),
                          ],
                        ),
                      )),
                  children: [
                    titleWIthTrailingText(
                        leadingText: 'Name', trailingText: '$username'),
                    SizedBox(height: 10),
                    titleWIthTrailingText(
                        leadingText: 'Email', trailingText: '$email'),
                    SizedBox(height: 10),
                    titleWIthTrailingText(
                        leadingText: 'Phone:', trailingText: '$phone'),
                    SizedBox(height: 10),
                    Divider(),
                    titleWIthTrailingText(
                        leadingText: 'Pick Up Address:',
                        trailingText: "$pickUpAddress"),
                    SizedBox(height: 10),
                    titleWIthTrailingText(
                        leadingText: 'Destination',
                        trailingText: "$destination"),
                    SizedBox(height: 10),
                    Consumer<OpenUrls>(builder: (context, open, child) {
                      return FlatButton.icon(
                          color: Colors.grey[200],
                          onPressed: () {
                            open.makePhoneCall('tel:$phone');
                          },
                          icon: Icon(Icons.call),
                          label: Text('Call'));
                    }),
                  ]),
            ),
          );
        });
  }

  RichText titleWIthTrailingText({String leadingText, String trailingText}) =>
      RichText(
        text: TextSpan(children: [
          TextSpan(
              text: '$leadingText:   '.toUpperCase(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          TextSpan(
              text: trailingText,
              style: TextStyle(color: Colors.blue, fontSize: 12)),
        ]),
      );
}

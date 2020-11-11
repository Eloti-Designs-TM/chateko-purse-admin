import 'package:chateko_purse_admin/services/users_api/users_api.dart';
import 'package:chateko_purse_admin/ui/views/widget/custom_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class ManageUserPage extends StatefulWidget {
  @override
  _ManageUserPageState createState() => _ManageUserPageState();
}

class _ManageUserPageState extends State<ManageUserPage> {
  bool searchIconEnabled = false;

  @override
  void initState() {
    super.initState();
    initializeGetData();
  }

  initializeGetData() async {
    await Future.delayed(Duration(seconds: 2));
    await Provider.of<UserApi>(context, listen: false)
        .getAllUsersFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: searchIconEnabled
            ? Consumer<UserApi>(builder: (context, userReq, child) {
                return Container(
                  height: 40,
                  child: TextFormField(
                      controller: userReq.searchController,
                      style: TextStyle(fontSize: 18),
                      onFieldSubmitted: userReq.handleSearch,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Search user',
                        fillColor: Colors.white,
                        suffixIcon: InkWell(
                            onTap: () => userReq
                                .handleSearch(userReq.searchController.text),
                            child: Icon(Icons.search)),
                      )),
                );
              })
            : Text('Manage Users'),
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
        child: Consumer<UserApi>(builder: (context, userReq, ch) {
          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 3));
              // await Provider.of<ShippinReqs>(context, listen: false)
              //     .getAllShippingsFromFirestore();
            },
            child: StreamBuilder<QuerySnapshot>(
                stream: userReq.resultFromUserColloection,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final data = snapshot.data.docs;
                  if (data.isEmpty || data == null) {
                    return Center(child: Text('No Users'));
                  }
                  return searchIconEnabled
                      ? _buildSearch(data, context)
                      : PaginateFirestore(
                          query: FirebaseFirestore.instance
                              .collection('users')
                              .orderBy('firstName'),
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
                            final uid = data[i].data()['id'];
                            final username = data[i].data()['fullName'];
                            final phone = data[i].data()['phone'];
                            final email = data[i].data()['email'];
                            final photoUrl = data[i].data()['imageUrl'];
                            final address = data[i].data()['address'];

                            return ListTile(
                              title: Text(
                                '$username',
                                style: TextStyle(fontSize: 18),
                              ),
                              subtitle: Text('$email\n$phone'),
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                backgroundImage:
                                    photoUrl == null || photoUrl.isEmpty
                                        ? null
                                        : NetworkImage('$photoUrl'),
                                child: photoUrl == null
                                    ? Icon(Icons.person)
                                    : null,
                              ),
                              trailing: Icon(Icons.arrow_forward, size: 14),
                              onTap: () => showDialog(
                                context: context,
                                builder: (ctx) =>
                                    CustomDialog(title: '$username', children: [
                                  Container(
                                      height: 100,
                                      child: photoUrl == null
                                          ? Icon(Icons.person)
                                          : Image.network(photoUrl)),
                                  SizedBox(height: 20),
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
                                  titleWIthTrailingText(
                                      leadingText: 'Address:',
                                      trailingText: "$address"),
                                  SizedBox(height: 10),
                                  FlatButton.icon(
                                      color: Colors.grey[200],
                                      onPressed: () {
                                        // TextController.clearTextField();
                                        // return Navigator.of(context).push(
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             UpdateUserPage(
                                        //                 userID: uid)));
                                      },
                                      icon: Icon(Icons.edit),
                                      label: Text('Edit User')),
                                ]),
                              ),
                            );
                          });
                }),
          );
        }),
      ),
    );
  }

  ListView _buildSearch(List<DocumentSnapshot> data, BuildContext context) {
    return ListView.separated(
        separatorBuilder: (ctx, i) => Divider(),
        itemCount: data.length,
        itemBuilder: (ctx, i) {
          final uid = data[i].data()['uid'];
          final username = data[i].data()['fullName'];
          final phone = data[i].data()['phone'];
          final email = data[i].data()['email'];
          final photoUrl = data[i].data()['imageUrl'];
          final address = data[i].data()['address'];

          return ListTile(
            title: Text(
              '$username',
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text('$email\n$phone'),
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: photoUrl == null || photoUrl.isEmpty
                  ? null
                  : NetworkImage('$photoUrl'),
              child: photoUrl == null ? Icon(Icons.person) : null,
            ),
            trailing: Icon(Icons.arrow_forward, size: 14),
            onTap: () => showDialog(
              context: context,
              builder: (ctx) => CustomDialog(title: '$username', children: [
                Container(
                    height: 100,
                    child: photoUrl == null
                        ? Icon(Icons.person)
                        : Image.network(photoUrl)),
                SizedBox(height: 20),
                titleWIthTrailingText(
                    leadingText: 'Name', trailingText: '$username'),
                SizedBox(height: 10),
                titleWIthTrailingText(
                    leadingText: 'Email', trailingText: '$email'),
                SizedBox(height: 10),
                titleWIthTrailingText(
                    leadingText: 'Phone:', trailingText: '$phone'),
                SizedBox(height: 10),
                titleWIthTrailingText(
                    leadingText: 'Address:', trailingText: "$address"),
                SizedBox(height: 10),
                FlatButton.icon(
                    color: Colors.grey[200],
                    onPressed: () {
                      // TextController.clearTextField();
                      // return Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) =>
                      //         UpdateUserPage(userID: uid)));
                    },
                    icon: Icon(Icons.edit),
                    label: Text('Edit User')),
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

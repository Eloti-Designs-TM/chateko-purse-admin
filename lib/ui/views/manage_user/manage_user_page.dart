import 'package:chateko_purse_admin/ui/views/ads_view/ads.dart';
import 'package:chateko_purse_admin/ui/views/profile_view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chateko_purse_admin/models/user/user.dart';
import 'package:chateko_purse_admin/ui/views/widget/custom_dialog.dart';
import 'package:chateko_purse_admin/view_models/profile_view_model/user_pagination.dart';

class ManageUserPage extends StatefulWidget {
  @override
  _ManageUserPageState createState() => _ManageUserPageState();
}

class _ManageUserPageState extends State<ManageUserPage> {
  @override
  Widget build(BuildContext context) {
    return UserInjector(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Consumer<UsersPagination>(builder: (context, userReq, ch) {
          return RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 3));
              },
              child: Stack(
                children: [
                  Builder(builder: (context) {
                    return Column(
                      children: [
                        Container(
                          height: 40,
                          child: TextFormField(
                              // controller: userReq.searchController,
                              style: TextStyle(fontSize: 18),
                              onFieldSubmitted: userReq.handleSearch,
                              onChanged: userReq.handleSearch,
                              decoration: InputDecoration(
                                filled: true,
                                hintText: 'Search user',
                                fillColor: Colors.white,
                                suffixIcon: InkWell(
                                    // onTap: () => userReq
                                    //     .handleSearch(userReq.searchController.text),
                                    child: Icon(Icons.search)),
                              )),
                        ),
                        Expanded(
                          child: userReq.filteredUsers.isNotEmpty
                              ? ListView.separated(
                                  separatorBuilder: (_, i) => Divider(),
                                  controller: userReq.scrollController,
                                  itemCount: userReq.filteredUsers.length,
                                  itemBuilder: (context, i) {
                                    final kUser = userReq.filteredUsers[i];

                                    return ListTile(
                                      title: Text(
                                        '${kUser.fullName}',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${kUser.email}\n${kUser.phone}'),
                                          kUser.isNew == true
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
                                        backgroundColor: Colors.grey[300],
                                        backgroundImage:
                                            NetworkImage('${kUser.imageUrl}'),
                                      ),
                                      trailing:
                                          Icon(Icons.arrow_forward, size: 14),
                                      onTap: () async {
                                        if (kUser.isNew) {
                                          await userReq
                                              .isCardClick(kUser.userID);
                                        }
                                        await showDialog(
                                          context: context,
                                          builder: (ctx) =>
                                              UserDialog(users: kUser),
                                        );
                                      },
                                    );
                                  })
                              : StreamBuilder<List<Users>>(
                                  stream: userReq.controllerOut,
                                  builder: (context, snapshot) {
                                    if (snapshot.data == null) {
                                      return Center(
                                          child: Text('Failed to get data'));
                                    }
                                    final data = snapshot.data;
                                    return ListView.separated(
                                        separatorBuilder: (_, i) => Divider(),
                                        controller: userReq.scrollController,
                                        itemCount:
                                            userReq.filteredUsers.isNotEmpty
                                                ? userReq.filteredUsers.length
                                                : data.length,
                                        itemBuilder: (context, i) {
                                          final kUser =
                                              userReq.filteredUsers.isNotEmpty
                                                  ? userReq.filteredUsers[i]
                                                  : data[i];
                                          return ListTile(
                                            title: Text(
                                              '${kUser.fullName}',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    '${kUser.email}\n${kUser.phone}'),
                                                kUser.isNew == true
                                                    ? Chip(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        label: Text(
                                                          'New',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        backgroundColor:
                                                            Colors.red,
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.grey[300],
                                              backgroundImage: NetworkImage(
                                                  '${kUser.imageUrl}'),
                                            ),
                                            trailing: Icon(Icons.arrow_forward,
                                                size: 14),
                                            onTap: () async {
                                              if (kUser.isNew) {
                                                await userReq
                                                    .isCardClick(kUser.userID);
                                              }
                                              await showDialog(
                                                context: context,
                                                builder: (ctx) =>
                                                    UserDialog(users: kUser),
                                              );
                                            },
                                          );
                                        });
                                  }),
                        ),
                      ],
                    );
                  }),
                  if (userReq.users.isEmpty || userReq.users == null)
                    Center(
                      child: Container(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (userReq.hasNext)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: userReq.fetchNextUsers,
                        child: Container(
                            height: 25,
                            width: 25,
                            child: Icon(Icons.arrow_downward_rounded)),
                      ),
                    ),
                ],
              ));
        }),
      ),
    );
  }

// Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Theme.of(context).primaryColor,
//         title: searchIconEnabled
//             ? Consumer<UserApi>(builder: (context, userReq, child) {
  //   return Container(
  //     height: 40,
  //     child: TextFormField(
  //         controller: userReq.searchController,
  //         style: TextStyle(fontSize: 18),
  //         onFieldSubmitted: userReq.handleSearch,
  //         decoration: InputDecoration(
  //           filled: true,
  //           hintText: 'Search user',
  //           fillColor: Colors.white,
  //           suffixIcon: InkWell(
  //               onTap: () => userReq
  //                   .handleSearch(userReq.searchController.text),
  //               child: Icon(Icons.search)),
  //         )),
  //   );
  // })
//             : Text('Manage Users'),
//         centerTitle: true,
//         actions: [
//           InkWell(
//               onTap: () {
//                 setState(() {
//                   searchIconEnabled = !searchIconEnabled;
//                 });
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 8.0),
//                 child: Icon(searchIconEnabled ? Icons.close : Icons.search),
//               )),
//         ],
//       ),
//       body:

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

class UserInjector extends StatelessWidget {
  final Widget child;

  const UserInjector({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UsersPagination(),
      child: child,
    );
  }
}

class UserDialog extends StatelessWidget {
  final Users users;

  const UserDialog({Key key, @required this.users}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomDialog(title: '${users.fullName}', children: [
      GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ImagePreview(imageUrl: users.imageUrl))),
        child: Container(
            height: 100,
            child: users.imageUrl == null
                ? Icon(Icons.person)
                : Image.network(users.imageUrl)),
      ),
      SizedBox(height: 20),
      titleWIthTrailingText(
          leadingText: 'Name', trailingText: '${users.fullName}'),
      SizedBox(height: 10),
      titleWIthTrailingText(
          leadingText: 'Email', trailingText: '${users.email}'),
      SizedBox(height: 10),
      titleWIthTrailingText(
          leadingText: 'Phone:', trailingText: '${users.phone}'),
      SizedBox(height: 10),
      titleWIthTrailingText(
          leadingText: 'Address:', trailingText: "${users.address}"),
      Divider(),
      titleWIthTrailingText(
          leadingText: 'Bank Name:', trailingText: "${users.accountName}"),
      titleWIthTrailingText(
          leadingText: 'Account Name:', trailingText: "${users.accountName}"),
      titleWIthTrailingText(
          leadingText: 'Account Number:',
          trailingText: "${users.accountNumber}"),
      SizedBox(height: 10),
      FlatButton.icon(
          color: Colors.grey[200],
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfileView(users: users)));
          },
          icon: Icon(Icons.edit),
          label: Text('Edit User')),
    ]);
  }
}

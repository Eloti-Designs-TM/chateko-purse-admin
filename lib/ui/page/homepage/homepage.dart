import 'package:bed_admin/services/auth_services.dart';
import 'package:bed_admin/ui/image_assets/image_assets.dart';
import 'package:bed_admin/ui/page/manage_pick_me_up/pick_me_up.dart';
import 'package:bed_admin/ui/page/manage_ship/manage_shippings..dart';
import 'package:bed_admin/ui/page/manage_user/manage_user_page.dart';
import 'package:bed_admin/ui/page/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('BED Logistics ADMIN'),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          Consumer<AuthService>(
            builder: (context, auth, child) {
              return IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                  ),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        contentPadding: const EdgeInsets.all(0),
                        buttonPadding: const EdgeInsets.all(0),
                        title: Text('Are you sure you want to LogOut?'),
                            actions: [
                              FlatButton(
                                child: Text('Yes'),
                                onPressed: ()=> auth.signOut(context),
                              ),
                              FlatButton(
                                child: Text('No'),
                                onPressed: ()=> Navigator.of(context).pop(),

                              ),
                            ],
                          )));
            }
          )
        ],
      ),
      body: Container(
        // color: Colors.blue[100].withOpacity(.5),
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButtonWid(
                  buttonTitle: 'Manage Users',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ManageUserPage())),
                ),
                FlatButtonWid(
                  buttonTitle: 'Manage Shippings',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ManageShippingPage())),
                ),
                FlatButtonWid(
                  buttonTitle: 'Manage Rides',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ManagePickMeUp())),
                ),
              ]),
        ),
      ),
    );
  }
}

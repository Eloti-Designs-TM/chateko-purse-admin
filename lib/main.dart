import 'package:bed_admin/provider/send_req/openUrls.dart';
import 'package:bed_admin/provider/send_req/ride_request.dart';
import 'package:bed_admin/provider/send_req/shippings_req.dart';
import 'package:bed_admin/provider/send_req/user_req.dart';
import 'package:bed_admin/services/auth_services.dart';
import 'package:bed_admin/ui/page/auth_page/login_page/login.dart';
import 'package:bed_admin/ui/page/homepage/homepage.dart';
import 'package:bed_admin/ui/page/start_page/start_page.dart';
import 'package:bed_admin/view_models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: UserReqs()),
        ChangeNotifierProvider.value(value: AuthService()),
        ChangeNotifierProvider.value(value: ShippinReqs()),
        ChangeNotifierProvider.value(value: OpenUrls()),
        ChangeNotifierProvider.value(value: RideReq()),
      ],
      child: Builder(builder: (context) {
        return Consumer<ThemeModel>(builder: (context, model, chi) {
          return MaterialApp(
            title: 'BED Logistics ADMIN',
            theme: model.theme,
            debugShowCheckedModeBanner: false,
            home: StartPage(),
          );
        });
      }),
    );
  }
}

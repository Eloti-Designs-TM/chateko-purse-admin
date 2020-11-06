import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/ui/image_assets/images_assets.dart';
import 'package:chateko_purse_admin/view_models/start_view_model/auth_view_model/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_page/signup_login_views.dart';

class StartView extends StatefulWidget {
  @override
  _StartViewState createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  var auth = GetIt.I.get<AuthApi>();

  @override
  void initState() {
    super.initState();
    _checkTimer();
  }

  _checkTimer() async {
    auth.localStorage = await SharedPreferences.getInstance();
    if (auth.localStorage.get('email') == null) {
      Future.delayed(Duration(seconds: 5), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignUpLogin()));
      });
    } else {
      String email = auth.localStorage.get('email').toString();
      String password = auth.localStorage.get('password').toString();
      await auth.signInWithEmailAndPasswordForSharedPref(
        email: email,
        password: password,
      );
      await Future.delayed(Duration(seconds: 2));
      await Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => null()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.2,
          child: Image.asset(ImageAssets.chat_1),
        ),
      ),
    );
  }
}

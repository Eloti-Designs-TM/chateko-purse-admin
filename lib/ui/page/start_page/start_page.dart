import 'package:bed_admin/services/auth_services.dart';
import 'package:bed_admin/ui/page/auth_page/login_page/login.dart';
import 'package:bed_admin/view_models/theme_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    _checkTimer();
  }

  _checkTimer() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    localStorage = await SharedPreferences.getInstance();
    if (localStorage.get('email') == null) {
      Future.delayed(Duration(seconds: 5), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    } else {
      auth.signInWithEmailAndPasswordForSharedPref(context,
          email: localStorage.get('email').toString(),
          password: localStorage.get('password').toString());
      print('${localStorage.get('email').toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          height: screenSize.height,
          width: screenSize.width,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/bg_splash.png'),
            fit: BoxFit.cover,
          )),
          child: Container(
            height: screenSize.height,
            width: screenSize.width,
            color: Colors.black.withOpacity(.4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: screenSize.width / 2,
                    child: Image.asset('assets/images/bedlogo.png')),
                SizedBox(height: 40),
                Container(
                  child: SpinKitWave(
                    size: 30,
                    duration: Duration(milliseconds: 800),
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven ? primaryColor : Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

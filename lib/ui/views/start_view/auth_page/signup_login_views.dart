import 'package:chateko_purse_admin/ui/image_assets/images_assets.dart';
import 'package:chateko_purse_admin/ui/views/start_view/auth_page/widgets/logo_title_subtitle.dart';
import 'package:chateko_purse_admin/view_models/start_view_model/landing_view_model/start_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page/login.dart';
import 'widgets/custom_curves.dart';

class SignUpLogin extends StatefulWidget {
  @override
  _SignUpLoginState createState() => _SignUpLoginState();
}

class _SignUpLoginState extends State<SignUpLogin> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return StartPageInjector(
      child: Builder(builder: (context) {
        final model = Provider.of<StartPageViewModel>(context);
        return Scaffold(
          key: scaffoldKey,
          body: Stack(
            children: [
              CustomPaint(
                painter: CurvePainter(),
                child: Container(),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      LogoWithTitleAndSubtitle(
                        imageUrl: Image.asset(ImageAssets.chat_2),
                        title: '',
                        subtitle: '',
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey[200],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              child: Text('Login'),
                              onPressed: () {
                                // model.onTapChangePageView(0);
                                setState(() {
                                  isLogin = true;
                                });
                              },
                              textColor: isLogin ? Colors.white : Colors.black,
                              color: isLogin ? Colors.pink : Colors.grey[300],
                            ),
                            SizedBox(width: 4),
                            FlatButton(
                              textColor: !isLogin ? Colors.white : Colors.black,
                              color: !isLogin ? Colors.pink : Colors.grey[300],
                              child: Text('Create Account'),
                              onPressed: () {
                                setState(() {
                                  isLogin = false;
                                });
                                // model.onTapChangePageView(1);
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.blue[100].withOpacity(.1),
                        child: Container(
                            child: Login(
                                onTapSignUp: () {
                                  // model.onTapChangePageView(1);
                                },
                                scaffoldKey: scaffoldKey)

                            // child: PageView(
                            //   scrollDirection: Axis.horizontal,
                            //   controller: model.pageController,
                            //   physics: NeverScrollableScrollPhysics(),
                            //   onPageChanged: model.onPageChanged,
                            //   children: [

                            //   ],
                            // ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                  child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (_) => null)),
              )),
            ],
          ),
        );
      }),
    );
  }
}

class StartPageInjector extends StatefulWidget {
  final Widget child;

  StartPageInjector({@required this.child});

  @override
  _StartPageInjectorState createState() => _StartPageInjectorState();
}

class _StartPageInjectorState extends State<StartPageInjector> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StartPageViewModel(),
      child: widget.child,
    );
  }
}

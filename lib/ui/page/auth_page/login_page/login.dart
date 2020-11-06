import 'package:bed_admin/models/user/user.dart';
import 'package:bed_admin/provider/text_provider/textcontroller_provider.dart';
import 'package:bed_admin/services/auth_services.dart';
import 'package:bed_admin/ui/image_assets/image_assets.dart';
import 'package:bed_admin/ui/page/widget/button.dart';
import 'package:bed_admin/ui/page/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  User currentUser;
  bool _showPass = false;
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      key: AuthService.loginScaffoldkey,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _topWithLogo(),
                      _textfields(),
                      SizedBox(height: 20),
                      FlatButtonWid(
                        buttonTitle: 'Login',
                        onTap: auth.isLoading ? null : () => _submit(context),
                      ),
                     auth.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Text(''),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _submit(context) async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final form = _form.currentState;

    setState(() {
    _isLoading = true;
    });

    if (form.validate()) {
      print('validate');
       auth.signInWithEmailAndPassword(
        context,
        email: TextController.email.text,
        password: TextController.password.text,
      );
      setState(() {
        _isLoading = false;
      });
    } else {
      print('not validate');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Form _textfields() {
    return Form(
      key: _form,
      child: Column(
        children: [
          TextFieldLineWid(
            title: 'Email',
            controller: TextController.email,
            validator: EmailValidator.validate,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 5),
          TextFieldLineWid(
            title: 'Password',
            obscureText: _showPass ? false : true,
            suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    _showPass = !_showPass;
                  });
                },
                child:
                    Icon(_showPass ? Icons.visibility : Icons.visibility_off)),
            controller: TextController.password,
            validator: PasswordValidator.validate,
            keyboardType: TextInputType.visiblePassword,
          ),
        ],
      ),
    );
  }

  Column _topWithLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            height: 90,
            child: Image.asset(ImageAssets.bedLogo),
          ),
        ),
        SizedBox(height: 15),
        RichText(
          text: TextSpan(
              style: TextStyle(
                  color: Colors.black,
                  height: 1.4,
                  fontWeight: FontWeight.w600),
              children: [
                TextSpan( text:'Hello BED Admin,\n',
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
                TextSpan(
                  text: 'Login to continue',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ]),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

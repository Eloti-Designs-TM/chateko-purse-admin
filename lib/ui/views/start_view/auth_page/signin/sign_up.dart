import 'package:chateko_purse_admin/ui/commons/sizes.dart';
import 'package:chateko_purse_admin/ui/views/widget/button.dart';
import 'package:chateko_purse_admin/ui/views/widget/text_field_wid.dart';
import 'package:chateko_purse_admin/view_models/start_view_model/auth_view_model/auth_view_model.dart';
import 'package:chateko_purse_admin/view_models/start_view_model/auth_view_model/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  final onTapLogin;

  const SignUp({Key key, this.onTapLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpViewModel>(builder: (context, signUpModel, child) {
      return Form(
        key: AuthViewModel.signupFormKey,
        child: TweenAnimationBuilder(
          duration: Duration(milliseconds: 500),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, val, child) {
            return Opacity(
              opacity: val,
              child: Padding(
                padding: EdgeInsets.only(top: val * 50),
                child: child,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Column(
              children: [
                // LogoWithTitleAndSubtitle(
                //   imageUrl: Image.asset(ImageAssets.chat_5),
                //   title: 'Create Account',
                //   subtitle: 'Welcome, create an account to continue...',
                // ),
                // sizedBoxHeight8,
                Text(
                  'Create Account',
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldWidRounded(
                        title: 'First Name',
                        validator: AuthViewModel.validateName,
                        controller: signUpModel.firstName,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    Expanded(
                      child: TextFieldWidRounded(
                        title: 'Last Name',
                        validator: AuthViewModel.validateName,
                        controller: signUpModel.lastName,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                  ],
                ),
                TextFieldWidRounded(
                  title: 'Phone',
                  validator: AuthViewModel.validatePhone,
                  controller: signUpModel.phone,
                  keyboardType: TextInputType.phone,
                ),
                TextFieldWidRounded(
                  title: 'Email',
                  controller: signUpModel.emailController,
                  validator: AuthViewModel.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFieldWidRounded(
                  title: 'Password (At least 8 characters)',
                  maxLine: 1,
                  suffixIcon: Icon(Icons.visibility_off),
                  controller: signUpModel.passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: signUpModel.isVisiblePassword,
                  validator: AuthViewModel.validatePass,
                  onTapVisibilityIcon: () => signUpModel.onChangeVisibility(),
                ),
                TextFieldWidRounded(
                  title: 'Confirm Password',
                  maxLine: 1,
                  suffixIcon: Icon(Icons.visibility_off),
                  controller: signUpModel.confirmPass,
                  keyboardType: TextInputType.visiblePassword,
                  validator: signUpModel.validateConfirmPass,
                  obscureText: signUpModel.isVisiblePassword,
                  onTapVisibilityIcon: () => signUpModel.onChangeVisibility(),
                ),
                TextFieldWidRounded(
                  title: 'Referral Code(Optional)',
                  maxLine: 1,
                  controller: signUpModel.referralController,
                  keyboardType: TextInputType.name,
                ),
                sizedBoxHeight8,
                sizedBoxHeight8,
                GradiantButton(
                  title: 'Create Account',
                  isOutline: false,
                  buttonState: signUpModel.buttonState,
                  onPressed: signUpModel.isLoading
                      ? null
                      : () async {
                          await signUpModel.handleSubmit(context);
                        },
                ),
                // AlreadyHaveAnAccountCheck(
                //   login: false,
                //   onPressed: onTapLogin,
                // ),
                sizedBoxHeight24,
                // OrDivider(),
                // _socialMediaButtons(),
              ],
            ),
          ),
        ),
      );
    });
  }
}

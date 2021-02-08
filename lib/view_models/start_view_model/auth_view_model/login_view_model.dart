import 'package:chateko_purse_admin/models/user/user.dart';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/ui/views/widget/button.dart';
import 'package:chateko_purse_admin/ui/views/widget/snacks.dart';
import 'package:chateko_purse_admin/ui/views/home_view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../base_view_model.dart';
import 'auth_view_model.dart';

class LoginViewModel extends BaseViewModel with AuthViewModel {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ButtonState buttonState = ButtonState.Initial;
  bool isLoading = false;
  bool isLoadingReset = false;
  String alertMessage = '';
  bool isVisiblePassword = true;

  var loginApi = GetIt.I.get<AuthApi>();

  onChangeVisibility() {
    isVisiblePassword = !isVisiblePassword;
    notifyListeners();
  }

  handleSubmitForPasswordReset(BuildContext context) async {
    final resetForm = AuthViewModel.resetFormKey.currentState;
    isLoadingReset = true;
    if (resetForm.validate()) {
      print('validated');
      isLoadingReset = false;
      try {
        await loginApi.resetPassword(emailController.text);
        showSnackbarSuccess(context,
            msg: 'An email has been sent to you. To reset your password');
      } catch (e) {
        showSnackbarSuccess(context, msg: 'An Error Occurred');
      }
      notifyListeners();
    } else {
      print('Not validated');
      Future.delayed(Duration(seconds: 3), () {
        isLoadingReset = false;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  handleSubmit(BuildContext context) async {
    final loginForm = AuthViewModel.loginFormKey.currentState;
    isLoading = true;
    buttonState = ButtonState.Loading;
    notifyListeners();

    if (loginForm.validate()) {
      try {
        isLoading = true;
        buttonState = ButtonState.Loading;

        notifyListeners();

        await loginApi.loginUser(context,
            email: emailController.text, password: passwordController.text);
        isLoading = false;
        buttonState = ButtonState.Initial;
        if (loginApi.users.isAdmin) {
          isLoading = false;
          buttonState = ButtonState.Initial;
          notifyListeners();
          showSnackbarSuccess(
            context,
            msg: 'Welcome, ${loginApi.users.fullName} ',
          );

          await Future.delayed(Duration(seconds: 2));

          await Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => HomeView()));
          notifyListeners();
        } else {
          await showSnackbarFailed(
            context,
            msg:
                'Sorry you are not an admin, ${loginApi.users.fullName}\n Logging out....',
          );
          await loginApi.firebaseAuth.signOut();
          await loginApi.localStorage.clear();
          loginApi.users = Users();
          notifyListeners();
        }
      } catch (e) {
        showSnackbarFailed(context,
            msg: 'Request Failed, Try again!!\n[${e.message}]');

        isLoading = false;
        buttonState = ButtonState.Initial;

        notifyListeners();
        print(e);
      }
    } else {
      Future.delayed(Duration(seconds: 1), () {
        print('Not validated');
        isLoading = false;
        buttonState = ButtonState.Initial;

        notifyListeners();
      });
    }
    notifyListeners();
  }

  @override
  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }
}

import 'dart:math';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/ui/views/widget/button.dart';
import 'package:chateko_purse_admin/ui/views/widget/snacks.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../base_view_model.dart';
import 'auth_view_model.dart';

class SignUpViewModel extends BaseViewModel implements AuthViewModel {
  var signApi = GetIt.I.get<AuthApi>();

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController confirmPass = TextEditingController();
  TextEditingController referralController = TextEditingController();
  ButtonState buttonState = ButtonState.Initial;

  @override
  TextEditingController emailController = TextEditingController();
  @override
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String alertMessage = '';

  var referralCodeGenerator = Random();
  String referralCode;

  bool isVisiblePassword = true;

  onChangeVisibility() {
    isVisiblePassword = !isVisiblePassword;
    notifyListeners();
  }

  referralCodeGen() {
    var id = referralCodeGenerator.nextInt(92143543) + 09451234356;
    var randomId = "ref-${id.toString().substring(0, 7)}";
    referralCode = randomId;
    notifyListeners();
  }

  // var authService = GetIt.instance.get<AuthService>();

  @override
  void clearFields() {
    firstName.clear();
    lastName.clear();
    phone.clear();
    confirmPass.clear();
    emailController.clear();
    confirmPass.clear();
  }

  String validateConfirmPass(String value) {
    if (value.isEmpty) {
      return 'Passord can\'t be empty';
    } else if (value.trim() == passwordController.text.trim()) {
      return null;
    }
    return 'Password does not match';
  }

  handleSubmit(BuildContext context) async {
    final form = AuthViewModel.signupFormKey.currentState;
    isLoading = true;
    referralCodeGen();
    // await Future.delayed(Duration(seconds: 10));
    buttonState = ButtonState.Loading;

    if (form.validate()) {
      try {
        isLoading = true;
        buttonState = ButtonState.Loading;
        notifyListeners();
        await signApi.signUpUser(
            email: emailController.text,
            firstName: firstName.text,
            lastName: lastName.text,
            password: passwordController.text,
            referrarCode: referralController.text,
            referralCode: referralCode,
            phone: phone.text);

        showSnackbar(context,
            msg: 'Successfully created User ${signApi.users.email}, Welcome!!',
            icon: Icons.check_box_rounded);
        notifyListeners();

        buttonState = ButtonState.Initial;
        await Future.delayed(Duration(seconds: 3));
        // await Navigator.of(context)
        //     .pushReplacement(MaterialPageRoute(builder: (_) => HomeView()));
        isLoading = false;
        referralCode = '';
        alertMessage = '';
        notifyListeners();
      } catch (e) {
        buttonState = ButtonState.Initial;
        showSnackbarFailed(
          context,
          msg:
              'Failed Creating User ${emailController.text}, Try again!! [${e.message.toUpperCase()}]',
        );

        notifyListeners();
        print(e);
      }
    } else {
      print('Not validated');
      Future.delayed(Duration(seconds: 2), () {
        buttonState = ButtonState.Initial;

        isLoading = false;
        notifyListeners();
      });
    }
    notifyListeners();
  }
}

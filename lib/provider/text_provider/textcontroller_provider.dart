import 'package:flutter/material.dart';


class TextController{
  static TextEditingController firstname = TextEditingController();
  static TextEditingController lastname = TextEditingController();
  static TextEditingController email = TextEditingController();
  static TextEditingController phone = TextEditingController();
  static TextEditingController password = TextEditingController();
  static TextEditingController confirnPass = TextEditingController();
  static TextEditingController address = TextEditingController();


  static clearTextField(){
    firstname.clear();
    email.clear();
    phone.clear();
    password.clear();
    confirnPass.clear();
    lastname.clear();
    address.clear();
  }
}
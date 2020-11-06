import 'package:flutter/material.dart';


class InfoTextController{
  static TextEditingController pickupAddress = TextEditingController();
  static TextEditingController senderAcurrateAddress = TextEditingController();
  static TextEditingController senderName = TextEditingController();
  static TextEditingController senderState = TextEditingController();
  static TextEditingController senderPhone = TextEditingController();

//---------------------------------------
//---------------------------------------

  static TextEditingController dropOffAddress = TextEditingController();
  static TextEditingController recieverAcurrateAddress = TextEditingController();
  static TextEditingController recieverName = TextEditingController();
  static TextEditingController recieverState = TextEditingController();
  static TextEditingController recieverPhone = TextEditingController();

  static clearTextField(){
    pickupAddress.clear();
    senderAcurrateAddress.clear();
    senderName.clear();
    senderState.clear();
    senderPhone.clear();
    dropOffAddress.clear();
    recieverAcurrateAddress.clear();
    recieverName.clear();
    recieverState.clear();
    recieverState.clear();
  }
}
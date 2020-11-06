import 'package:flutter/material.dart';


class PickMeUpTextController{
  static TextEditingController pickupAddress = TextEditingController();
  static TextEditingController pickUpAccurateAddress = TextEditingController();

//---------------------------------------
//---------------------------------------

 static TextEditingController destinationAddress = TextEditingController();
  static TextEditingController accurateDestinationAddress = TextEditingController();

  static clearTextField(){
    pickupAddress.clear();
    pickUpAccurateAddress.clear();
    destinationAddress.clear();
    accurateDestinationAddress.clear();
  }
}
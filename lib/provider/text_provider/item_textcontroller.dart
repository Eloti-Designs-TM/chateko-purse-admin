import 'package:flutter/material.dart';

class ItemTextController{
  static TextEditingController itemName = TextEditingController();
  static TextEditingController qty = TextEditingController();
  static TextEditingController itemValuePrice = TextEditingController();
  static TextEditingController weight = TextEditingController();


  static clearTextField(){
    itemName.clear();
    qty.clear();
    itemValuePrice.clear();
    weight.clear();
  }
}
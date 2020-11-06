
import 'package:flutter/material.dart';

class TextFieldWid extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final Function onTap;

  final bool enableTextField;

  final TextInputType  keyboardType;
   Function(String) validator;

  int maxLength;

   TextFieldWid({
    Key key,
   @required this.title,
    this.controller,
    this.onTap,
    this.maxLength,
    this.validator,
    this.enableTextField, this.keyboardType
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
      enabled: enableTextField==null  ?  true : enableTextField,
        controller: controller,
        onTap: onTap,
      validator: validator,

        maxLength: maxLength == null ?null : maxLength,
        keyboardType: keyboardType,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          labelText: title,
          border: OutlineInputBorder(

          ),
        ),
      ),
    );
  }
}



class TextFieldLineWid extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final Function onTap;
    final TextInputType  keyboardType;
  final bool enableTextField;

  final suffixIcon;

   Function(String) validator;

 bool obscureText;

   TextFieldLineWid({
    Key key,
   @required this.title,
    this.controller,
    this.onTap,
    this.validator,
    this.obscureText,
    this.enableTextField, this.suffixIcon, this.keyboardType
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: TextFormField(
      validator: validator,
      enabled: enableTextField==null  ?  true : enableTextField,
        controller: controller,
        onTap: onTap,
        obscureText: obscureText == null ? false : obscureText,
        cursorColor: Colors.black,
         keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: title,
          suffixIcon: suffixIcon == null ?   null : suffixIcon,
        ),
      ),
    );
  }
}


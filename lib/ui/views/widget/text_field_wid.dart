import 'package:chateko_purse_admin/ui/commons/sizes.dart';
import 'package:chateko_purse_admin/view_models/theme_view_model/theme_model.dart';
import 'package:flutter/material.dart';

class TextFieldWid extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final TextEditingController controller;
  final bool removeIcon;

  TextFieldWid({
    Key key,
    @required this.title,
    this.leadingIcon,
    this.controller,
    @required this.removeIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaddingAll8(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          removeIcon
              ? Text('')
              : Expanded(
                  flex: 1,
                  child: Icon(
                    leadingIcon,
                    color: grey400,
                    size: 30,
                  )),
          Expanded(
            flex: removeIcon ? 10 : 9,
            child: TextField(
              decoration: InputDecoration(
                labelText: title,
                labelStyle: TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextFieldWidRounded extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Widget suffixIcon;
  final bool obscureText;
  final int maxLine;
  final Function(String) validator;

  final Function onTapVisibilityIcon;

  final bool enableTextField;

  final Function(String) onChanged;

  TextFieldWidRounded(
      {Key key,
      @required this.title,
      this.leadingIcon,
      this.controller,
      this.suffixIcon,
      this.obscureText,
      this.maxLine,
      this.keyboardType,
      this.validator,
      this.onTapVisibilityIcon,
      this.enableTextField,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaddingAll8(
      child: TextFormField(
        controller: controller,
        maxLines: maxLine,
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
        onTap: onTapVisibilityIcon,
        enabled: enableTextField ?? true,
        style: TextStyle(fontSize: 18),
        obscureText: obscureText == null ? false : obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          disabledBorder: InputBorder.none,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: primaryColor.withOpacity(.2),
          hintText: title,
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}

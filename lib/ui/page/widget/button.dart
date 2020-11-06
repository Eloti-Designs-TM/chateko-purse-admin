
import 'package:bed_admin/view_models/theme_model.dart';
import 'package:flutter/material.dart';

class FlatButtonWid extends StatelessWidget {
  final String buttonTitle;
  final Function() onTap;
  const FlatButtonWid({
    Key key,
    this.buttonTitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ButtonTheme(
        buttonColor: primaryColor,
        height: 50,
        child: RaisedButton(
          elevation: 0,
          shape: StadiumBorder(),
            onPressed: this.onTap, textColor: white, child: Text(this.buttonTitle, style: TextStyle(fontSize:18),)),
      ),
    );
  }
}


MaterialButton button(IconData icon, Function onPressed) {
    return MaterialButton(
      elevation: 3,
      onPressed: onPressed,
      color: primaryColor,
      textColor: Colors.white,
      child: Icon(icon, size: 20),
      padding: EdgeInsets.all(10),
      shape: CircleBorder(),
    );
  }

  
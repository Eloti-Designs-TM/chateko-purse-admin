import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final List<Widget> children;
  final Widget title;

  const CustomDialog({Key key, this.children, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      elevation: 30,
      titlePadding: const EdgeInsets.all(0),
      title: title,
      contentPadding: const EdgeInsets.all(16),
      children: children,
    );
  }
}

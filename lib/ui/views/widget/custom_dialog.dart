import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final Color color;

  const CustomDialog({Key key, this.title, this.children, this.color})
      : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: widget.color ?? null,
      titlePadding: const EdgeInsets.only(top: 16),
      title: Center(
          child: Text(widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, color: Colors.pink[700]))),
      contentPadding: const EdgeInsets.all(16),
      children: widget.children,
    );
  }
}

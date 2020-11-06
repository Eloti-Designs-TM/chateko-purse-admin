import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

copyToClipBoard({String clipBoardText}) {
  return Clipboard.setData(ClipboardData(text: clipBoardText)).then((result) {
    Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: "copied ✔",
        backgroundColor: Colors.green);
  });
}


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Modal {

  static showToast(
      {String? msg = "Toast Message",
      Color? color,
      Toast? toastLength,
      Color? textColor,
      ToastGravity? gravity}) {
    Fluttertoast.showToast(
        msg: msg as String,
        toastLength: toastLength ?? Toast.LENGTH_SHORT,
        gravity: gravity ?? ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color ?? Colors.black,
        textColor: textColor ?? Colors.white,
        fontSize: 16.0);
  }


}
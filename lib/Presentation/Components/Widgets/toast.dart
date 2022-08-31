import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> showToast({
  required String text,
  required ToastStates state,
}) {
  return Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

// enum
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green.withOpacity(.8);
      break;
    case ToastStates.ERROR:
      color = Colors.red.withOpacity(.8);
      break;
    case ToastStates.WARNING:
      color = Colors.amber.withOpacity(.8);
      break;
  }

  return color;
}

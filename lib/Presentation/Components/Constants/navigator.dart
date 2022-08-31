import 'package:flutter/material.dart';

Future<Object?> navigatorTo(context, Widget widget) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => widget));
}

Future<Object?> navigatorReplacement(context, Widget widget) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}
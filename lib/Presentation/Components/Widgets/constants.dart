import 'package:flutter/material.dart';

Widget sizedBox({double? height, double? width}) {
  return SizedBox(
    width: width,
    height: height,
  );
}

Widget divider({
  Color? color,
  double? width,
  double? height = 1,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
    child: Container(
      color: color ?? Colors.grey.withOpacity(.5),
      height: height,
      width: width,
    ),
  );
}

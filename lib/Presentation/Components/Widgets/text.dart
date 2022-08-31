import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget text(
  String? text, {
  Color? color = Colors.black,
  double? size,
  FontWeight? fontWeight,
}) {
  return Text(
    text!,
    style: GoogleFonts.aBeeZee(
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
    ),
  );
}

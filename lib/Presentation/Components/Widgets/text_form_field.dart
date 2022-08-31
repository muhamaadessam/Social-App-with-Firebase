import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String? title;
  final bool? isPassword;
  final FormFieldValidator<String>? validation;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLine;
  final Function(String)? onChanged;

  const CustomTextFormField({
    Key? key,
    required this.title,
    this.isPassword = false,
    required this.controller,
    required this.validation,
    this.maxLine = 1,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      validator: validation,
      controller: controller,
      obscureText: isPassword!,
      maxLines: maxLine,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: GoogleFonts.aBeeZee(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color.fromRGBO(147, 147, 147, 1),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgImage extends StatelessWidget {
  const SvgImage({
    Key? key,
    this.image,
    this.asset = false,
    this.network = false,
    this.imageFile,
    this.byte,
    this.file = false,
    this.memory = false,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  final String? image;
  final File? imageFile;
  final Uint8List? byte;
  final bool? asset;
  final bool? network;
  final bool? file;
  final bool? memory;

  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    if (asset!) {
      return SvgPicture.asset(
        image!,
        height: height,
        width: width,
        fit: fit!,
      );
    }
    if (network!) {
      return SvgPicture.network(
        image!,
        height: height,
        width: width,
        fit: fit!,
      );
    }
    if (network!) {
      return SvgPicture.file(
        imageFile!,
        height: height,
        width: width,
        fit: fit!,
      );
    }
    if (network!) {
      return SvgPicture.memory(
        byte!,
        height: height,
        width: width,
        fit: fit!,
      );
    }
    return Container();
  }
}

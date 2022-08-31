import 'package:flutter/material.dart';
import 'package:social/Presentation/Components/Widgets/text.dart';

PreferredSizeWidget customAppBar(context,{String? title, List<Widget>? actions}) {
  return AppBar(
    elevation: 0,
    titleSpacing: 0,
    title: text(title ?? '', size: 20),
    backgroundColor: Colors.white,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    actions: actions,
  );
}

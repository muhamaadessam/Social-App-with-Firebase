import 'package:flutter/material.dart';

import '../../Shared/Cubit/cubit.dart';

Widget bottomBarIcons(context, {IconData? icon, int? index}) {
  return Icon(
    icon,
    size: 30,
    color: AppCubit.get(context).currentIndex != index
        ? Colors.black
        : Colors.white,
  );
}

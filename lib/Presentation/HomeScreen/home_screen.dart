import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/Presentation/Components/Constants/navigator.dart';
import 'package:social/Presentation/Registration/sign_in_screen.dart';
import 'package:social/Shared/Cubit/cubit.dart';
import 'package:social/Shared/Cubit/states.dart';

import '../Components/Widgets/text.dart';
import 'bottom_nav_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) => () {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: text(cubit.titles[cubit.currentIndex], size: 20),
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    cubit.auth.signOut();
                    navigatorReplacement(context, const SignInScreen());
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            extendBody: true,
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: Colors.transparent,
              color: Colors.white,
              index: cubit.currentIndex,
              items: [
                bottomBarIcons(context, icon: Icons.home, index: 0),
                bottomBarIcons(context, icon: Icons.chat, index: 1),
                bottomBarIcons(context, icon: Icons.upload_file, index: 2),
                bottomBarIcons(context, icon: Icons.location_history, index: 3),
                bottomBarIcons(context, icon: Icons.settings, index: 4),
              ],
              onTap: (index) {
                cubit.changeBottomNav(context, index);
              },
            ),
            body: cubit.screens[cubit.currentIndex],
          );
        });
  }
}

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/Presentation/Components/Constants/icon_broken.dart';
import 'package:social/Presentation/Components/Constants/navigator.dart';
import 'package:social/Shared/Cubit/cubit.dart';
import '../../Shared/Cubit/states.dart';
import '../../Shared/Network/Local/cash_helper.dart';
import '../Components/Widgets/text.dart';
import '../Registration/sign_in_screen.dart';
import '../Settings/edit_profile.dart';
import '../UploadPost/upload_post.dart';
import 'bottom_nav_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) => () {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          var index = cubit.currentIndex;
          return WillPopScope(
            onWillPop: () => onBackButtonPressed(context),
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: text(cubit.titles[cubit.currentIndex], size: 20),
                backgroundColor: Colors.white,
                actions: [
                  if (cubit.currentIndex == 4)
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            navigatorTo(context, EditProfileScreen());
                          },
                          icon: const Icon(
                            IconBroken.Edit_Square,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            signOut(context, cubit);
                          },
                          icon: const Icon(
                            IconBroken.Logout,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    )
                  else
                    Container(),
                ],
              ),
              extendBody: true,
              bottomNavigationBar: CurvedNavigationBar(
                height: 60,
                animationDuration: const Duration(milliseconds: 700),
                backgroundColor: Colors.transparent,
                color: Colors.blue,
                letIndexChange: (index) {
                  if (index != 2) {
                    return true;
                  }
                  navigatorTo(context, const CreateNewPostScreen());
                  return false;
                },
                buttonBackgroundColor: Colors.blue,
                index: index,
                items: [
                  bottomBarIcons(context, icon: IconBroken.Home, index: 0),
                  bottomBarIcons(context, icon: IconBroken.Chat, index: 1),
                  bottomBarIcons(context,
                      icon: IconBroken.Paper_Upload, index: 2),
                  bottomBarIcons(context,
                      icon: IconBroken.Notification, index: 3),
                  bottomBarIcons(context, icon: IconBroken.User, index: 4),
                ],
                onTap: (index) {
                  cubit.changeBottomNav(context, index);
                },
              ),
              body: cubit.screens[cubit.currentIndex],
            ),
          );
        });
  }
}

Future<bool> onBackButtonPressed(context) async {
  bool? exitApp = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          title: text(
            'Exit App',
            color: Colors.blue,
            size: 20,
            fontWeight: FontWeight.w600,
          ),
          content: text(
            'Do you want to close the app',
            color: Colors.black,
            size: 16,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: text(
                'No',
                color: Colors.white,
                size: 16,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: text(
                'Yes',
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        );
      });
  return exitApp ?? false;
}

Future signOut(context, AppCubit cubit) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          title: text(
            'LogOut',
            color: Colors.blue,
            size: 20,
            fontWeight: FontWeight.w600,
          ),
          content: text(
            'Do you want to Log out the app',
            color: Colors.black,
            size: 16,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: text(
                'NO',
                color: Colors.white,
                size: 16,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                cubit.auth.signOut();
                CashHelper.put(key: 'Login', value: false);
                navigatorTo(context, const SignInScreen());
              },
              child: text(
                'Yes',
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        );
      });
}

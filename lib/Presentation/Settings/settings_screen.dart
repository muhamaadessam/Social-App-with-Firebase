import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/Models/user_model.dart';
import 'package:social/Presentation/Components/Constants/navigator.dart';
import 'package:social/Presentation/Components/Widgets/constants.dart';
import 'package:social/Presentation/Components/Widgets/text.dart';
import 'package:social/Presentation/Registration/sign_in_screen.dart';
import 'package:social/Shared/Cubit/cubit.dart';
import 'package:social/Shared/Cubit/states.dart';
import 'package:social/Shared/Network/Local/cash_helper.dart';

import '../Components/Constants/icon_broken.dart';
import 'edit_profile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) => () {},
      builder: (context, state) {
        UserModel? userModel = cubit.userModel;

        return state is GetUserLoadingState
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 250,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 1,
                                minHeight: 1,
                                maxWidth: double.infinity,
                                maxHeight: 180,
                              ),
                              child: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.zero,
                                      bottom: Radius.circular(20)),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image.network(
                                  '${userModel!.coverImageUrl}',
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 75,
                              backgroundImage:
                                  NetworkImage('${userModel.imageUrl}'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    sizedBox(height: 8),
                    text(
                      userModel.name,
                      fontWeight: FontWeight.w600,
                      size: 18,
                    ),
                    text(
                      userModel.bio,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      size: 14,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  text(
                                    '563',
                                    fontWeight: FontWeight.w600,
                                    size: 16,
                                  ),
                                  sizedBox(height: 8),
                                  text(
                                    'Posts',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  text(
                                    '265',
                                    fontWeight: FontWeight.w600,
                                    size: 16,
                                  ),
                                  sizedBox(height: 8),
                                  text(
                                    'Photos',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  text(
                                    '12K',
                                    fontWeight: FontWeight.w600,
                                    size: 16,
                                  ),
                                  sizedBox(height: 8),
                                  text(
                                    'Followers',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  text(
                                    '956',
                                    fontWeight: FontWeight.w600,
                                    size: 16,
                                  ),
                                  sizedBox(height: 8),
                                  text(
                                    'Friends',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              child: text('Add Photo', color: Colors.blue),
                            ),
                          ),
                          sizedBox(width: 8),
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
                          // sizedBox(width: 8)
                        ],
                      ),
                    ),
                    TextButton(onPressed: () {
                      cubit.auth.signOut();
                      CashHelper.put(key: 'login', value: false);
                      navigatorTo(context, const SignInScreen());
                    }, child: text('SignOut'))
                  ],
                ),
              );
      },
    );
  }
}

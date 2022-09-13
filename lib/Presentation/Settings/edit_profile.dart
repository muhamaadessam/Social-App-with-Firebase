import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/Presentation/Components/Widgets/app_bar.dart';
import '../../Models/user_model.dart';
import '../../Shared/Cubit/cubit.dart';
import '../../Shared/Cubit/states.dart';
import '../Components/Constants/icon_broken.dart';
import '../Components/Widgets/constants.dart';
import '../Components/Widgets/text.dart';
import '../Components/Widgets/text_form_field.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) => () {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        UserModel? userModel = cubit.userModel;
        var profileImage = cubit.profileImage;
        var coverImage = cubit.coverImage;
        nameController.text = userModel!.name!;
        bioController.text = userModel.bio!;
        phoneController.text = userModel.phone!;
        ImageProvider? imageProviderProfile;
        profileImage == null
            ? imageProviderProfile = NetworkImage(
                '${userModel.imageUrl}',
              )
            : imageProviderProfile = FileImage(
                profileImage,
              );
        return Scaffold(
          appBar: customAppBar(
            context,
            title: 'Edit Profile',
            actions: [
              TextButton(
                onPressed: () {
                  // cubit.uploadCoverImage();
                  // cubit.uploadProfileImage();
                  cubit.updateUser(
                    name: nameController.text,
                    bio: bioController.text,
                    phone: phoneController.text,
                  );
                  //cubit.getUser();
                },
                child: text(
                  'UPDATE',
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  size: 16,
                ),
              ),
              sizedBox(width: 16)
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is UpDateUserDataLoadingState ||
                      state is GetUserLoadingState)
                    const LinearProgressIndicator(),
                  SizedBox(
                    height: 250,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              ConstrainedBox(
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
                                  child: coverImage == null
                                      ? Image.network(
                                          '${userModel.coverImageUrl}',
                                          fit: BoxFit.fitWidth,
                                        )
                                      : Image.file(
                                          coverImage,
                                          fit: BoxFit.fitWidth,
                                        ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  cubit.getCoverImage();
                                },
                                icon: const CircleAvatar(
                                  radius: 20,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 75,
                                backgroundImage: imageProviderProfile,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                cubit.getProfileImage();
                              },
                              icon: const CircleAvatar(
                                radius: 20,
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  sizedBox(height: 32),
                  CustomTextFormField(
                    keyboardType: TextInputType.name,
                    onChanged: (value) {
                      debugPrint(value);
                    },
                    controller: nameController,
                    title: 'Name',
                    validation: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(IconBroken.User),
                  ),
                  sizedBox(height: 16),
                  CustomTextFormField(
                    prefixIcon:const Icon(IconBroken.Info_Circle),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      debugPrint(value);
                    },
                    controller: bioController,
                    title: 'Bio',
                    validation: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter your bio';
                      }
                      return null;
                    },
                  ),
                  sizedBox(height: 16),
                  CustomTextFormField(
                    prefixIcon: Icon(IconBroken.Call),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      debugPrint(value);
                    },
                    controller: phoneController,
                    title: 'Phone',
                    validation: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

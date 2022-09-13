import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/Models/post_model.dart';
import 'package:social/Presentation/Components/Widgets/app_bar.dart';
import 'package:social/Shared/Cubit/cubit.dart';
import 'package:social/Shared/Cubit/states.dart';

import '../Components/Constants/icon_broken.dart';
import '../Components/Widgets/constants.dart';
import '../Components/Widgets/text.dart';

class CreateNewPostScreen extends StatelessWidget {
  const CreateNewPostScreen({Key? key, this.postId}) : super(key: key);
  final String? postId;

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();
    var imageController = TextEditingController();

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, states) {},
      builder: (context, states) {
        PostModel? postModel;
        AppCubit cubit = AppCubit.get(context);
        if (postId != null) {
          cubit.getPostDataWithId(postId!);
          postModel = cubit.postModelWithId;
        }
        if (postModel != null) {
          print('nulls');
          textController.text = postModel.text!;
          imageController.text = postModel.postImageUrl!;
        }

        return Scaffold(
          appBar: customAppBar(
            context,
            onTap: () {
              cubit.currentIndex = 0;
              Navigator.pop(context);
            },
            title: postModel == null ? 'Create Post' : 'Update Post',
            actions: [
              TextButton(
                onPressed: () {
                  var now = DateTime.now();
                  if (postModel == null) {
                    if (cubit.postImage == null) {
                      cubit.createPost(
                        dateTime: now.toString(),
                        text: textController.text,
                      );
                    } else {
                      cubit.uploadPostImage(
                        update: false,
                        dateTime: now.toString(),
                        text: textController.text,
                      );
                    }
                  }
                  else {
                    if (cubit.postImage == null) {
                      cubit.updatePost(
                        updateDateTime: now.toString(),
                        text: textController.text,
                      );
                    } else {
                      cubit.uploadPostImage(
                        update: true,
                        dateTime: now.toString(),
                        text: textController.text,
                      );
                    }
                  }

                  textController.clear();
                  imageController.clear();
                  cubit.removePostImage();
                  Navigator.pop(context);
                },
                child: text(
                  postModel == null ? 'POST' : 'UPDATE',
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  size: 16,
                ),
              ),
              sizedBox(width: 16)
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                if (states is CreatePostLoadingState)
                  const LinearProgressIndicator(),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(cubit.userModel!.imageUrl!),
                    ),
                    sizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(cubit.userModel!.name!,
                              size: 16, fontWeight: FontWeight.w600),
                          sizedBox(width: 4),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'what is on your mind ...',
                      border: InputBorder.none,
                    ),
                    minLines: 1,
                    maxLines: 7,
                  ),
                ),
                TextField(
                  controller: imageController,
                  onChanged: (value) {
                    if (value != '') {
                      cubit.getPostImageUrlPut(value);
                    } else {
                      cubit.removePostImageUrl();
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter Image Url to upload',
                    border: InputBorder.none,
                  ),
                  minLines: 1,
                ),
                if (cubit.postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 1,
                          minHeight: 1,
                          maxWidth: double.infinity,
                          maxHeight: 250,
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: FileImage(cubit.postImage!),
                                fit: BoxFit.cover),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          cubit.removePostImage();
                        },
                        icon: const CircleAvatar(
                          radius: 20,
                          child: Icon(
                            IconBroken.Close_Square,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (cubit.postImageUrlPut != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 1,
                          minHeight: 1,
                          maxWidth: double.infinity,
                          maxHeight: 150,
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Image.network(
                            cubit.postImageUrlPut!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) =>
                                (loadingProgress == null)
                                    ? child
                                    : const Center(
                                        child: CircularProgressIndicator()),
                            errorBuilder: (context, error, stackTrace) =>
                                Column(
                              children: [
                                const Icon(
                                  IconBroken.Danger,
                                  color: Colors.red,
                                  size: 100,
                                ),
                                text("Not Found Image",
                                    color: Colors.red,
                                    size: 15,
                                    fontWeight: FontWeight.w800)
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          cubit.removePostImageUrl();
                          imageController.clear();
                        },
                        icon: const CircleAvatar(
                          radius: 20,
                          child: Icon(
                            IconBroken.Close_Square,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          cubit.getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(IconBroken.Image),
                            sizedBox(width: 8),
                            text('Add Photo', color: Colors.blue)
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: text('#tags', color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

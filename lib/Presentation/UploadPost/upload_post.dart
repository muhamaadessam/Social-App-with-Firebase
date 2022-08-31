import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/Presentation/Components/Widgets/app_bar.dart';
import 'package:social/Shared/Cubit/cubit.dart';
import 'package:social/Shared/Cubit/states.dart';

import '../Components/Widgets/constants.dart';
import '../Components/Widgets/text.dart';

class CreateNewPostScreen extends StatelessWidget {
  const CreateNewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, states) {},
      builder: (context, states) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: customAppBar(
            context,
            title: 'Create Post',
            actions: [
              TextButton(
                onPressed: () {
                  var now = DateTime.now();
                  if (cubit.postImage == null) {
                    cubit.createPost(
                      dateTime: now.toString(),
                      text: textController.text,
                    );
                  } else {
                    cubit.uploadPostImage(
                      dateTime: now.toString(),
                      text: textController.text,
                    );
                  }
                  textController.clear();
                  cubit.removePostImage();
                },
                child: text(
                  'POST',
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
                            Icons.close,
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
                            const Icon(Icons.image),
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

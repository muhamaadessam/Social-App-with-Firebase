import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social/Presentation/Components/Constants/navigator.dart';
import 'package:social/Presentation/Components/Widgets/text.dart';
import 'package:social/Presentation/UploadPost/upload_post.dart';

import '../../../Models/post_model.dart';
import '../../../Shared/Cubit/cubit.dart';
import '../Constants/icon_broken.dart';
import 'constants.dart';

Widget postItemBuilder(context,
    {PostModel? postModel,
    int? index = 1,
    String? postId,
    TextEditingController? controller}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(postModel!.imageUrl!),
              ),
              sizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        text(postModel.name!,
                            size: 16, fontWeight: FontWeight.w600),
                        sizedBox(width: 4),
                        const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 20,
                        )
                      ],
                    ),
                    text(postModel.dateTime!,
                        size: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 0,
                      onTap: () {
                        AppCubit.get(context).deletePosts(postId: postId);
                        AppCubit.get(context).getPosts();
                      },
                      child: text('Delete'),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: text('Update'),
                    ),
                  ];
                },
                icon: const Icon(Icons.more_horiz),
                onSelected: (value) {
                  if (value == 1) {
                    print(postId);
                    navigatorTo(context, CreateNewPostScreen(postId: postId));
                  }
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: divider(),
          ),
          text(postModel.text!, size: 15, fontWeight: FontWeight.w400),
          sizedBox(height: 8),
          sizedBox(height: 8),
          if (postModel.postImageUrl! != '')
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 1,
                minHeight: 1,
                maxWidth: double.infinity,
                maxHeight: 400,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  postModel.postImageUrl!,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          sizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                        stream: AppCubit.get(context).getLikeStream(postId!),
                        builder: (context, snapshots) {
                          if (!snapshots.hasData) {
                            return const Center(
                              child: Icon(
                                FontAwesomeIcons.heart,
                                color: Colors.blue,
                                size: 24,
                              ),
                            );
                          }
                          if (snapshots.data!.exists) {
                            return IconButton(
                              onPressed: () {
                                AppCubit.get(context)
                                    .addLike(liked: true, postId: postId);
                              },
                              icon: const Icon(
                                FontAwesomeIcons.solidHeart,
                                color: Colors.blue,
                                size: 24,
                              ),
                            );
                          } else {
                            return IconButton(
                              onPressed: () {
                                AppCubit.get(context)
                                    .addLike(liked: false, postId: postId);
                              },
                              icon: const Icon(
                                FontAwesomeIcons.heart,
                                color: Colors.blue,
                                size: 24,
                              ),
                            );
                          }
                        }),
                    sizedBox(width: 8),
                    StreamBuilder<QuerySnapshot>(
                      stream: AppCubit.get(context).getNumberLikeStream(postId),
                      builder: (context, snapshots) {
                        if (snapshots.hasData) {
                          return text(snapshots.data!.docs.length.toString(),
                              color: Colors.grey);
                        } else {
                          return text('0', color: Colors.grey);
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      IconBroken.Chat,
                      color: Colors.blue,
                      size: 20,
                    ),
                    sizedBox(width: 8),
                    StreamBuilder<QuerySnapshot>(
                      stream:
                          AppCubit.get(context).getCommentsLikeStream(postId),
                      builder: (context, snapshots) {
                        if (snapshots.hasData) {
                          return text('${snapshots.data!.docs.length} Comment',
                              color: Colors.grey);
                        } else {
                          return text('0 Comment', color: Colors.grey);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          divider(),
          sizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage:
                    NetworkImage(AppCubit.get(context).userModel!.imageUrl!),
              ),
              sizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (value) {
                    AppCubit.get(context)
                        .commentPost(postId: postId, comment: value);
                    controller!.clear();
                  },
                  decoration: const InputDecoration(
                    hintText: 'write a comment ...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

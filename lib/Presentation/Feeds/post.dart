import 'package:flutter/material.dart';
import 'package:social/Models/post_model.dart';
import 'package:social/Shared/Cubit/cubit.dart';
import '../Components/Constants/icon_broken.dart';
import '../Components/Widgets/constants.dart';
import '../Components/Widgets/text.dart';

class BuildPostItem extends StatelessWidget {
  const BuildPostItem({
    Key? key,
    required this.postModel,
    this.index,
  }) : super(key: key);
  final PostModel? postModel;
  final int? index;

  @override
  Widget build(BuildContext context) {
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
                          text(postModel!.name!,
                              size: 16, fontWeight: FontWeight.w600),
                          sizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 20,
                          )
                        ],
                      ),
                      text(postModel!.dateTime!,
                          size: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Colors.black,
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: divider(),
            ),
            text(postModel!.text!, size: 15, fontWeight: FontWeight.w400),
            sizedBox(height: 8),
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: SizedBox(
                    height: 25,
                    child: MaterialButton(
                      onPressed: () {},
                      minWidth: 1,
                      padding: EdgeInsets.zero,
                      child: text('#flutter', color: Colors.blue, size: 13),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: SizedBox(
                    height: 25,
                    child: MaterialButton(
                      onPressed: () {},
                      minWidth: 1,
                      padding: EdgeInsets.zero,
                      child: text('#software', color: Colors.blue, size: 13),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: SizedBox(
                    height: 25,
                    child: MaterialButton(
                      onPressed: () {},
                      minWidth: 1,
                      padding: EdgeInsets.zero,
                      child: text('#flutter_developer',
                          color: Colors.blue, size: 13),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: SizedBox(
                    height: 25,
                    child: MaterialButton(
                      onPressed: () {},
                      minWidth: 1,
                      padding: EdgeInsets.zero,
                      child: text('#mobile_app', color: Colors.blue, size: 13),
                    ),
                  ),
                ),
              ],
            ),
            sizedBox(height: 8),
            if (postModel!.postImageUrl! != '')
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
                    postModel!.postImageUrl!,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            sizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        const Icon(
                          IconBroken.Heart,
                          color: Colors.blue,
                          size: 24,
                        ),
                        sizedBox(width: 8),
                        text('${AppCubit.get(context).likes[index!]}',
                            color: Colors.grey)
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        IconBroken.Chat,
                        color: Colors.blue,
                        size: 20,
                      ),
                      sizedBox(width: 8),
                      text('${AppCubit.get(context).comments[index!]} Comment',
                          color: Colors.grey)
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
                sizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onSubmitted: (value) {
                      AppCubit.get(context).commentPost(
                          postId: AppCubit.get(context).postsId[index!],
                          comment: value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'write a comment ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    AppCubit.get(context)
                        .likePost(AppCubit.get(context).postsId[index!]);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        IconBroken.Heart,
                        color: Colors.blue,
                        size: 24,
                      ),
                      sizedBox(width: 8),
                      text('Like', color: Colors.grey)
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

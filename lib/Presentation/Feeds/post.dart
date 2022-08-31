import 'package:flutter/material.dart';
import 'package:social/Models/post_model.dart';
import 'package:social/Shared/Cubit/cubit.dart';

import '../Components/Widgets/constants.dart';
import '../Components/Widgets/text.dart';

class BuildPostItem extends StatelessWidget {
  const BuildPostItem({Key? key, required this.postModel}) : super(key: key);
  final PostModel? postModel;

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
                    child: Row(
                      children: [
                        const Icon(
                          Icons.favorite_border_rounded,
                          color: Colors.blue,
                          size: 24,
                        ),
                        sizedBox(width: 8),
                        text('120', color: Colors.grey)
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.comment,
                        color: Colors.blue,
                        size: 20,
                      ),
                      sizedBox(width: 8),
                      text('120 Comment', color: Colors.grey)
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
                  child: text('write a comment ...', color: Colors.grey),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.blue,
                      size: 24,
                    ),
                    sizedBox(width: 8),
                    text('Like', color: Colors.grey)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

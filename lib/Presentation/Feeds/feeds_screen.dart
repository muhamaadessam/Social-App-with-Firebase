import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/Models/post_model.dart';
import 'package:social/Presentation/Components/Widgets/constants.dart';
import '../../Shared/Cubit/cubit.dart';
import '../../Shared/Cubit/states.dart';
import '../Components/Constants/icon_broken.dart';
import '../Components/Widgets/text.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    cubit.posts.clear();
    cubit.getPosts();
    print('comments in screen ${cubit.comments.length}');
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) => () {},
      builder: (context, state) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
            child: Column(
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
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 3)),
                      ],
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.network(
                      'https://img.freepik.com/free-photo/no-problem-concept-bearded-man-makes-okay-gesture-has-everything-control-all-fine-gesture-wears-spectacles-jumper-poses-against-pink-wall-says-i-got-this-guarantees-something_273609-42817.jpg?w=900&t=st=1661931585~exp=1661932185~hmac=2654d033e3290d415aa25dab1e58ba101aeed045199c07f98ee7bc915e5578f0',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                sizedBox(height: 16),
                if (cubit.posts.isEmpty)
                  Column(
                    children: [
                      sizedBox(height: 64),
                      const Icon(
                        IconBroken.Danger,
                        color: Colors.blue,
                        size: 200,
                      ),
                      text("Not Found Posts",
                          color: Colors.blue,
                          size: 30,
                          fontWeight: FontWeight.w800)
                    ],
                  )
                else if (cubit.likes.isEmpty || cubit.comments.isEmpty)
                  // Center(
                  //   child: Column(
                  //     children: [
                  //       const CircularProgressIndicator(),
                  //       text('comments ${cubit.comments.length}'),
                  //       text('likes ${cubit.likes.length}'),
                  //     ],
                  //   ),
                  // )
                  Container()
                else
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => postItemBuilder(
                            context,
                            postModel: cubit.posts[index],
                            index: index,
                            postId: AppCubit.get(context).postsId[index],
                          ),
                      separatorBuilder: (context, index) =>
                          sizedBox(height: 16),
                      itemCount: cubit.posts.isEmpty ? 1 : cubit.posts.length),
                sizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget postItemBuilder(context,
    {PostModel? postModel, int? index = 1, String? postId}) {
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
                    text('${AppCubit.get(context).comments[index]} Comment',
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
                    AppCubit.get(context)
                        .commentPost(postId: postId, comment: value);
                  },
                  decoration: const InputDecoration(
                    hintText: 'write a comment ...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  AppCubit.get(context).likePost(postId!);
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/Presentation/Components/Widgets/constants.dart';
import '../../Shared/Cubit/cubit.dart';
import '../../Shared/Cubit/states.dart';
import '../Components/Constants/icon_broken.dart';
import '../Components/Widgets/post_item_builder.dart';
import '../Components/Widgets/text.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    // cubit.posts.clear();
    cubit.getPosts();
    TextEditingController controller = TextEditingController();
    cubit.auth.currentUser!.getIdToken().then((value) => debugPrint(value));
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
                      'https://img.freepik.com/free-photo/portrait-handsome-bearded-european-man-with-grey-hair-beard-smiles-pleasantly-looks-directly-front-being-good-mood-has-lucky-day-wears-spectacles-sweater-isolated-blue-wall_273609-44285.jpg?w=900&t=st=1662170139~exp=1662170739~hmac=cd01ed0382f2495e97472abf7dcdb5ffb83bffbc9866ff6262e5b9987d3ba25a',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                sizedBox(height: 16),
                if (state is SocialGetPostsLoadingState)
                  Column(
                    children: [
                      sizedBox(height: 128),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  )
                else if (cubit.posts.isEmpty)
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
                else
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => postItemBuilder(
                            context,
                            controller: controller,
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


// Widget postItemBuilder(context,
//     {PostModel? postModel,
//     int? index = 1,
//     String? postId,
//     TextEditingController? controller}) {
//   return Container(
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(10),
//       boxShadow: const [
//         BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
//       ],
//     ),
//     child: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 30,
//                 backgroundImage: NetworkImage(postModel!.imageUrl!),
//               ),
//               sizedBox(width: 8),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         text(postModel.name!,
//                             size: 16, fontWeight: FontWeight.w600),
//                         sizedBox(width: 4),
//                         const Icon(
//                           Icons.verified,
//                           color: Colors.blue,
//                           size: 20,
//                         )
//                       ],
//                     ),
//                     text(postModel.dateTime!,
//                         size: 12,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.w400),
//                   ],
//                 ),
//               ),
//               PopupMenuButton(
//                 itemBuilder: (context) {
//                   return [
//                     PopupMenuItem(
//                       value: 0,
//                       child: text('Delete'),
//                       onTap: () {
//                         AppCubit.get(context).deletePosts(postId: postId);
//                         AppCubit.get(context).getPosts();
//                       },
//                     ),
//                     PopupMenuItem(
//                       value: 1,
//                       child: text('Update'),
//                     ),
//                   ];
//                 },
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: divider(),
//           ),
//           text(postModel.text!, size: 15, fontWeight: FontWeight.w400),
//           sizedBox(height: 8),
//           sizedBox(height: 8),
//           if (postModel.postImageUrl! != '')
//             ConstrainedBox(
//               constraints: const BoxConstraints(
//                 minWidth: 1,
//                 minHeight: 1,
//                 maxWidth: double.infinity,
//                 maxHeight: 400,
//               ),
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 child: Image.network(
//                   postModel.postImageUrl!,
//                   fit: BoxFit.fitWidth,
//                 ),
//               ),
//             ),
//           sizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 0.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     StreamBuilder<DocumentSnapshot>(
//                         stream: AppCubit.get(context).getLikeStream(postId!),
//                         builder: (context, snapshots) {
//                           if (!snapshots.hasData) {
//                             return const Center(
//                               child: Icon(
//                                 FontAwesomeIcons.heart,
//                                 color: Colors.blue,
//                                 size: 24,
//                               ),
//                             );
//                           }
//                           if (snapshots.data!.exists) {
//                             return IconButton(
//                               onPressed: () {
//                                 AppCubit.get(context).addLike(liked: true, postId: postId);
//                               },
//                               icon: const Icon(
//                                 FontAwesomeIcons.solidHeart,
//                                 color: Colors.blue,
//                                 size: 24,
//                               ),
//                             );
//                           } else {
//                             return IconButton(
//                               onPressed: () {
//                                 AppCubit.get(context).addLike(liked: false, postId: postId);
//                               },
//                               icon: const Icon(
//                                 FontAwesomeIcons.heart,
//                                 color: Colors.blue,
//                                 size: 24,
//                               ),
//                             );
//                           }
//                         }),
//                     sizedBox(width: 8),
//                     StreamBuilder<QuerySnapshot>(
//                       stream: AppCubit.get(context).getNumberLikeStream(postId),
//                       builder: (context, snapshots) {
//                         if (snapshots.hasData) {
//                           return text(snapshots.data!.docs.length.toString(),
//                               color: Colors.grey);
//                         } else {
//                           return text('0', color: Colors.grey);
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     const Icon(
//                       IconBroken.Chat,
//                       color: Colors.blue,
//                       size: 20,
//                     ),
//                     sizedBox(width: 8),
//                     StreamBuilder<QuerySnapshot>(
//                       stream: AppCubit.get(context).getCommentsLikeStream(postId),
//                       builder: (context, snapshots) {
//                         if (snapshots.hasData) {
//                           return text('${snapshots.data!.docs.length} Comment',
//                               color: Colors.grey);
//                         } else {
//                           return text('0 Comment', color: Colors.grey);
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           divider(),
//           sizedBox(height: 8),
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 20,
//                 backgroundImage: NetworkImage(AppCubit.get(context).userModel!.imageUrl!),
//               ),
//               sizedBox(width: 16),
//               Expanded(
//                 child: TextField(
//                   controller: controller,
//                   onSubmitted: (value) {
//                     AppCubit.get(context).commentPost(postId: postId, comment: value);
//                     controller!.clear();
//                   },
//                   decoration: const InputDecoration(
//                     hintText: 'write a comment ...',
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }

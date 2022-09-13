import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/Models/user_model.dart';
import 'package:social/Presentation/Components/Widgets/constants.dart';
import 'package:social/Presentation/Components/Widgets/text.dart';
import 'package:social/Shared/Cubit/cubit.dart';
import 'package:social/Shared/Cubit/states.dart';
import '../../Shared/Network/Local/cash_helper.dart';
import '../Components/Constants/icon_broken.dart';
import '../Components/Widgets/post_item_builder.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    UserModel? userModel = cubit.userModel;
    cubit.myPosts.clear();
    cubit.getPosts(uId: CashHelper.get(key: 'uId'));
    TextEditingController controller = TextEditingController();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) => () {},
      builder: (context, state) {

        return state is GetUserLoadingState
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
              child: Padding(
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
                      sizedBox(height: 4),
                      text(
                        userModel.bio,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        size: 14,
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
                                  postModel: cubit.myPosts[index],
                                  index: index,
                                  postId: AppCubit.get(context).myPostsId[index],
                                ),
                            separatorBuilder: (context, index) =>
                                sizedBox(height: 16),
                            itemCount:
                                cubit.myPosts.isEmpty ? 1 : cubit.myPosts.length),
                      sizedBox(height: 32),

                    ],
                  ),
                ),
            );
      },
    );
  }
}

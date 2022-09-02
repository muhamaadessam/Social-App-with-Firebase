import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/Models/user_model.dart';
import 'package:social/Presentation/Components/Constants/navigator.dart';
import 'package:social/Shared/Cubit/cubit.dart';
import 'package:social/Shared/Cubit/states.dart';

import '../Components/Widgets/constants.dart';
import '../Components/Widgets/text.dart';
import 'chat_with_person.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) => () {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            child: ListView.separated(
                itemBuilder: (context, index) =>
                    buildChatItem(context,userModel: cubit.users[index]),
                separatorBuilder: (context, index) => divider(),
                itemCount: cubit.users.length),
          ),
        );
      },
    );
  }
}

Widget buildChatItem(context,{UserModel? userModel}) => InkWell(
      onTap: () {
        navigatorTo(context, ChatWithPerson(userModel));
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(userModel!.imageUrl!),
          ),
          sizedBox(width: 8),
          text(userModel.name!, size: 16, fontWeight: FontWeight.w600),
        ],
      ),
    );

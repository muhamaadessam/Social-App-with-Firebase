import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/Models/user_model.dart';
import 'package:social/Presentation/Components/Widgets/constants.dart';
import 'package:social/Shared/Cubit/cubit.dart';
import 'package:social/Shared/Cubit/states.dart';

import '../Components/Constants/icon_broken.dart';
import '../Components/Widgets/text.dart';
import 'messages.dart';

class ChatWithPerson extends StatelessWidget {
  bool? isMuhammad = true;
  final UserModel? userModel;
  var messageController = TextEditingController();

  ChatWithPerson(this.userModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      AppCubit.get(context).getMessages(receiverId: userModel!.uId);
      return BlocConsumer<AppCubit, AppStates>(
        listener: (context, states) => () {},
        builder: (context, states) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 70,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.black,
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(userModel!.imageUrl!),
                        ),
                        sizedBox(width: 8),
                        text(userModel!.name!, size: 18),
                      ],
                    ),
                  ),
                  Expanded(
                    child: AppCubit.get(context).messages.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            reverse: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var message =
                                  AppCubit.get(context).messages[index];
                              return MessageLine(
                                isSender:
                                    AppCubit.get(context).userModel!.uId ==
                                        message.senderId,
                                message: message.message,
                              );
                            },
                            itemCount: AppCubit.get(context).messages.length),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                controller: messageController,
                                decoration: const InputDecoration(
                                  hintText: 'Type Massage',
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(color: Colors.black),
                                maxLines: 5,
                                minLines: 1,
                                onChanged: (value) {
                                  // messageController = value;
                                },
                              ),
                            ),
                          ),
                        ),
                        sizedBox(width: 16),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.2),
                              borderRadius: BorderRadius.circular(50)),
                          child: IconButton(
                            onPressed: () {
                              if (messageController.text != '') {
                                AppCubit.get(context).sendMessage(
                                  receiverId: userModel!.uId,
                                  dateTime: DateTime.now().toString(),
                                  message: messageController.text);
                              }
                              messageController.clear();
                            },
                            icon: const Icon(
                              IconBroken.Send,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

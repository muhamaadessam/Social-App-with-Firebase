import 'package:flutter/material.dart';
import 'package:social/Presentation/Components/Widgets/app_bar.dart';

import '../Components/Widgets/constants.dart';
import '../Components/Widgets/text.dart';

class CreateNewPostScreen extends StatelessWidget {
  const CreateNewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: 'Create Post',
        actions: [
          TextButton(
            onPressed: () {},
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://img.freepik.com/free-photo/positive-delighted-bearded-man-appealing-you-points-fingers-makes-good-choice-has-funny-joyful-expression-chooses-someone-shows-its-up-you-gesture-picks-potential-client_273609-42154.jpg?w=900&t=st=1661932737~exp=1661933337~hmac=47e1793a4c6161c670f5d0d5a0b397be955b9941a455dfeb5f549a4762a150da'),
                ),
                sizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text('Muhammad Essam',
                          size: 16, fontWeight: FontWeight.w600),
                      sizedBox(width: 4),
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

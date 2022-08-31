import 'package:flutter/material.dart';
import 'package:social/Presentation/Components/Widgets/app_bar.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
        title: 'Edit Profile',
      ),
      body: const Center(child: Text('uploadPost')),
    );
  }
}

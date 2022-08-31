import 'package:flutter/material.dart';
import 'package:social/Presentation/Components/Widgets/app_bar.dart';

class UploadPostScreen extends StatelessWidget {
  const UploadPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: 'Add Post'),
      body: const Center(child: Text('uploadPost')),
    );
  }
}

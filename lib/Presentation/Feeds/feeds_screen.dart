import 'package:flutter/material.dart';
import 'package:social/Presentation/Components/Widgets/constants.dart';
import 'package:social/Presentation/Feeds/post.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            ListView.separated(
              shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => const BuildPostItem(),
                separatorBuilder: (context, index) => sizedBox(height: 16),
                itemCount: 10),
            sizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}
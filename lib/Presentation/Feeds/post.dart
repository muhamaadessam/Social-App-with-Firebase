import 'package:flutter/material.dart';

import '../Components/Widgets/constants.dart';
import '../Components/Widgets/text.dart';

class BuildPostItem extends StatelessWidget {
  const BuildPostItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      Row(
                        children: [
                          text('Muhammad Essam',
                              size: 16, fontWeight: FontWeight.w600),
                          sizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 20,
                          )
                        ],
                      ),
                      text('January 21 ,2021 at 11:00 pm',
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
            text(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                size: 15,
                fontWeight: FontWeight.w400),
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
                  'https://img.freepik.com/free-photo/no-problem-concept-bearded-man-makes-okay-gesture-has-everything-control-all-fine-gesture-wears-spectacles-jumper-poses-against-pink-wall-says-i-got-this-guarantees-something_273609-42817.jpg?w=900&t=st=1661931585~exp=1661932185~hmac=2654d033e3290d415aa25dab1e58ba101aeed045199c07f98ee7bc915e5578f0',
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
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      'https://img.freepik.com/free-photo/positive-delighted-bearded-man-appealing-you-points-fingers-makes-good-choice-has-funny-joyful-expression-chooses-someone-shows-its-up-you-gesture-picks-potential-client_273609-42154.jpg?w=900&t=st=1661932737~exp=1661933337~hmac=47e1793a4c6161c670f5d0d5a0b397be955b9941a455dfeb5f549a4762a150da'),
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

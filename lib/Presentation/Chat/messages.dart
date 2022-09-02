import 'package:flutter/material.dart';

import '../Components/Widgets/text.dart';

class MessageLine extends StatelessWidget {
  const MessageLine({Key? key, this.isSender, this.message}) : super(key: key);

  final bool? isSender;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Align(
        alignment: isSender!
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 240, minWidth: 10),
          child: Container(
            decoration: BoxDecoration(
              color: isSender!
                  ? Colors.blue[200]
                  : Colors.grey[200],
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                  bottomLeft: isSender!
                      ? const Radius.circular(10)
                      : const Radius.circular(0),
                  bottomRight: isSender!
                      ? const Radius.circular(0)
                      : const Radius.circular(10)),
            ),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                child: text(message!,
                    color: isSender!
                        ? Colors.white
                        : Colors.black,
                    size: 15)),
          ),
        ),
      ),
    );
  }
}

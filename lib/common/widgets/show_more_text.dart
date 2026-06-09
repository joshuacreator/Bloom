import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class AppShowMoreText extends StatelessWidget {
  const AppShowMoreText({
    super.key,
    required this.text,
    this.textAlign,
    this.trimLines = 3,
  });

  final String text;
  final TextAlign? textAlign;
  final int trimLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ReadMoreText(
        text,
        textAlign: textAlign,
        moreStyle: const TextStyle(
          fontSize: 12,
          color: Colors.amber,
        ),
        lessStyle: const TextStyle(
          fontSize: 12,
          color: Colors.amber,
        ),
        trimMode: TrimMode.Line,
        trimLines: trimLines,
        trimExpandedText: '\t\tless',
        trimCollapsedText: 'more',
      ),
    );
  }
}

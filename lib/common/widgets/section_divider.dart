import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({
    super.key,
    this.onTap,
    required this.turns,
    required this.title,
  });

  final void Function()? onTap;
  final double turns;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            AnimatedRotation(
              turns: turns,
              duration: const Duration(
                milliseconds: AppConstants.animationDuration,
              ),
              child: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

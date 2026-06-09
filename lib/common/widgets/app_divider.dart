import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Divider()),
        SizedBox(width: 10),
        Text('OR'),
        SizedBox(width: 10),
        Flexible(child: Divider()),
      ],
    );
  }
}

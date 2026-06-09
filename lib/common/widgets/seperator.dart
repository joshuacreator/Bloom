import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class Separator extends StatelessWidget {
  const Separator({
    super.key,
    this.height = 20,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: 2,
      color: AppColors.grey.withValues(alpha: 0.3),
    );
  }
}

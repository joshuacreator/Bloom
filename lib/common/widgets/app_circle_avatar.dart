import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';

class AppCircleAvatar extends ConsumerWidget {
  const AppCircleAvatar({
    super.key,
    required this.image,
    required this.isActive,
  });

  final ImageProvider<Object>? image;
  final bool isActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      constraints: BoxConstraints(
        maxHeight: context.defaultSize * 7,
        minHeight: context.defaultSize * 5,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          width: 4,
          color: isActive ? AppColors.go : AppColors.danger,
        ),
        image: image == null
            ? null
            : DecorationImage(image: image!, fit: BoxFit.contain),
        shape: BoxShape.circle,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.title,
    required this.leading,
    this.onTap,
  });

  final String title;
  final IconData leading;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leading, color: AppColors.grey),
      title: Text(title),
      onTap: onTap,
    );
  }
}

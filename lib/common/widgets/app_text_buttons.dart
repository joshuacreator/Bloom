import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppTextButtonIcon extends StatelessWidget {
  const AppTextButtonIcon({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      label: Text(label),
      icon: Icon(icon),
    );
  }
}

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color,
  });

  final String label;
  final void Function()? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: color ?? AppColors.button),
      ),
    );
  }
}

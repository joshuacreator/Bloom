import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.hasIcon = false,
  });

  final String label;
  final void Function()? onPressed;
  final bool isLoading;
  final bool hasIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: WidgetStatePropertyAll(
        AppColors.white.withValues(alpha: 0.5),
      ),
      borderRadius: BorderRadius.circular(50),
      onTap: isLoading ? null : onPressed,
      child: Ink(
        height: context.defaultSize * 1.3,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColors.button,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasIcon) ...[
                      const Icon(Icons.add, color: AppColors.white, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: WidgetStatePropertyAll(
        AppColors.white.withValues(alpha: 0.5),
      ),
      borderRadius: BorderRadius.circular(50),
      onTap: onPressed,
      child: Ink(
        height: context.defaultSize * 1.3,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: AppColors.button,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.button,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

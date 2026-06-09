import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.isBuild = false,
    this.label = 'Loading...',
  });

  final bool isBuild;
  final String label;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: context.defaultSize * 3.7,
            minWidth: context.defaultSize * 3.7,
          ),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: brightness == Brightness.dark
                ? AppColors.backgroundOnDark(isBuild: isBuild)
                : AppColors.backgroundOnLight(isBuild: isBuild),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: brightness == Brightness.dark
                    ? AppColors.foregroundOnDark(isBuild: isBuild)
                    : AppColors.foregroundOnLight(isBuild: isBuild),
              ),
              AppConstants.height16,
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: brightness == Brightness.dark
                      ? AppColors.foregroundOnDark(isBuild: isBuild)
                      : AppColors.foregroundOnLight(isBuild: isBuild),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showLoadingIndicator(BuildContext context, {String label = 'Loading...'}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return LoadingIndicator(isBuild: true, label: label);
    },
  );
}

import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

void showSnackBar(BuildContext context, {required String msg}) {
  final snackBar = SnackBar(
    content: Text(msg, textAlign: TextAlign.center),
    shape: RoundedRectangleBorder(
      borderRadius: AppConstants.defaultBorderRadius,
    ),
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
    duration: const Duration(seconds: 4),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

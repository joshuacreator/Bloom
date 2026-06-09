import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const int animationDuration = 500;
  static const double circularAvatarRadius = 25;

  static const String defaultRoomImgPath =
      'https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg';

  static const String defaultSpaceImgPath =
      'https://images.pexels.com/photos/2387877/pexels-photo-2387877.jpeg';

  static const String defaultUserImgPath =
      'https://images.pexels.com/photos/60579/pexels-photo-60579.jpeg';

  // Spacing
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;

  // Border radius
  static BorderRadius get defaultBorderRadius =>
      BorderRadius.circular(spacingSm);

  static BorderRadius get myBorderRadius => const BorderRadius.only(
        topLeft: Radius.circular(spacingMd),
        bottomLeft: Radius.circular(spacingMd),
        bottomRight: Radius.circular(spacingMd),
      );

  static BorderRadius get yourBorderRadius => const BorderRadius.only(
        topRight: Radius.circular(spacingMd),
        bottomLeft: Radius.circular(spacingMd),
        bottomRight: Radius.circular(spacingMd),
      );

  // SizedBox helpers
  static const SizedBox height4 = SizedBox(height: spacingXs);
  static const SizedBox height8 = SizedBox(height: spacingSm);
  static const SizedBox height16 = SizedBox(height: spacingMd);
  static const SizedBox height24 = SizedBox(height: spacingLg);
  static const SizedBox height32 = SizedBox(height: spacingXl);
}
